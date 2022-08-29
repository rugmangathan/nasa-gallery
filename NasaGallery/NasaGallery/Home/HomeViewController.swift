//
//  HomeViewController.swift
//  NasaGallery
//
//  Created by Rugmangathan on 21/08/22.
//

import ImageScout
import Kingfisher
import MobiusCore
import MobiusExtras
import UIKit

class HomeViewController: UIViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  var galleryService: GalleryApi = LocalGalleryService.shared
  private var collectionViewOptions: [Gallery] = []
  private lazy var effectHandler: HomeEffectHandler = {
    HomeEffectHandler(self)
  }()
  private var scout: ImageScout = ImageScout()
  private lazy var imageService: ImageServiceApi = {
    ImageService.shared
  }()
  private var imageSize: [CGSize] = []

  private lazy var loop = {
    Mobius
      .loop(update: HomeLogic.update, effectHandler: effectHandler)
      .start(from: HomeModel(fetchEvent: .inFlight))
  }()

  private lazy var renderer: HomeRenderer = {
    HomeRenderer(view: self)
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    loop.addObserver { [weak self] model in
      DispatchQueue.main.async {
        self?.renderer.render(model)
      }
    }

    loop.dispatchEvent(.viewCreated)

    collectionView.dataSource = self
    collectionView.prefetchDataSource = self
    if let layout = collectionView?.collectionViewLayout as? DynamicLayout {
      layout.delegate = self
    }
    collectionView.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)

    title = "Nasa Gallery"
  }
}

extension HomeViewController: HomeView {
  func showActivity() {
    activityIndicator.startAnimating()
    collectionView.isHidden = true
  }

  func showGalleries(_ galleries: [Gallery]) {
    activityIndicator.stopAnimating()
    collectionView.isHidden = false
    collectionViewOptions = galleries
    collectionView.reloadData()
  }

  func showFailedState(_ message: String) {
    let alertView = UIAlertController(
      title: "Alert",
      message: "Failed to load data",
      preferredStyle: UIAlertController.Style.alert
    )
    alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default))

    present(alertView, animated: true)
  }

  func showEmptyState() {

  }
}

extension HomeViewController: HomeAction {
  func fetchGalleries() {
    galleryService.fetch { [weak self] result in
      switch result {
      case .failure(let error):
        self?.loop.dispatchEvent(.fetchFailed)
      case .success(let galleries):
        self?.fetchImageSize(galleries: galleries)
      }
    }
  }

  func fetchImageSize(galleries: [Gallery]) {
    let sortedGalleries = galleries
      .sorted(by: { $0.date.compare($1.date) == .orderedDescending })
    sortedGalleries
      .forEach { gallery in
        if self.imageService.isCached(for: gallery.url) {
          self.imageService.getImageFromCache(with: gallery.url) { [weak self] result in
            if case .success(let image) = result {
              self?.imageSize.append(image.size)
            }
            if self?.imageSize.count == galleries.count {
              DispatchQueue.main.async {
                self?.loop.dispatchEvent(.fetchSuccessful(sortedGalleries))
              }
            }
          }
        } else {
          guard let url = URL(string: gallery.url) else {
            imageSize.append(.zero)
            return
          }
          scout.scoutImage(atURL: url) { [weak self] _, size, _ in
            self?.imageSize.append(size)
            if self?.imageSize.count == galleries.count {
              DispatchQueue.main.async {
                self?.loop.dispatchEvent(.fetchSuccessful(sortedGalleries))
              }
            }
          }
        }
      }
  }
}

extension HomeViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    imageSize.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "GalleryCell",
      for: indexPath
    ) as? GalleryCell else {
      return UICollectionViewCell()
    }

    cell.gallery = collectionViewOptions[indexPath.item]
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let detailView = storyboard?
      .instantiateViewController(withIdentifier: "DetailViewController")
      as? DetailViewController
    guard let detailView = detailView else { return }
    detailView.galleries = collectionViewOptions
    detailView.selectedIndex = indexPath.item
    navigationController?.show(detailView, sender: self)
  }
}

extension HomeViewController: UICollectionViewDataSourcePrefetching {
  func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    ImagePrefetcher(urls: indexPaths.compactMap { URL(string: collectionViewOptions[$0.item].hdUrl) }).start()
  }
}

extension HomeViewController: DynamicLayoutDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    heightForPhotoAtIndexPath indexPath: IndexPath
  ) -> CGFloat {
    if imageSize.isEmpty {
      return 150
    } else {
      let inset = collectionView.contentInset.left + collectionView.contentInset.right
      let itemSize = (collectionView.frame.width - (inset + 10)) / 2
      let sourceImageSize = imageSize[indexPath.item] == .zero
        ? CGSize(width: 150, height: 150)
        : imageSize[indexPath.item]
      let imageHeight = calculateImageHeight(sourceImage: sourceImageSize, scaledToWidth: itemSize)
      let textHeight = requiredHeight(text: collectionViewOptions[indexPath.item].title, cellWidth: itemSize)
      return imageSize.isEmpty
        ? 300
        : imageHeight + 4 + textHeight + 4
    }
  }

  private func requiredHeight(text:String , cellWidth : CGFloat) -> CGFloat {
    let font = UIFont.systemFont(ofSize: 17.0)
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: cellWidth, height: .greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.font = font
    label.text = text
    label.sizeToFit()
    return label.frame.height
  }

  private func calculateImageHeight (sourceImage: CGSize, scaledToWidth: CGFloat) -> CGFloat {
    let oldWidth = sourceImage.width
    let scaleFactor = scaledToWidth / oldWidth
    let newHeight = sourceImage.height * scaleFactor
    return newHeight
  }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let inset = collectionView.contentInset.left + collectionView.contentInset.right
    let itemSize = (collectionView.frame.width - (inset + 10)) / 2
    return CGSize(width: itemSize, height: itemSize)
  }
}
