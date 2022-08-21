//
//  HomeViewController.swift
//  NasaGallery
//
//  Created by Rugmangathan on 21/08/22.
//

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

    collectionView.collectionViewLayout = generateLayout()
    collectionView.dataSource = self
    title = "Nasa Gallery"
  }

  private func generateLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0))
    let fullPhotoItem = NSCollectionLayoutItem(layoutSize: itemSize)
    fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(
      top: 2,
      leading: 2,
      bottom: 2,
      trailing: 2
    )
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalWidth(1/2))
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitem: fullPhotoItem,
      count: 2)
    let section = NSCollectionLayoutSection(group: group)
    let layout = UICollectionViewCompositionalLayout(section: section)
    return layout
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
        self?.loop.dispatchEvent(.fetchSuccessful(galleries))
      }
    }
  }
}

extension HomeViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    collectionViewOptions.count
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

    let gallery = collectionViewOptions[indexPath.item]
    let processor = DownsamplingImageProcessor(size: cell.imageView.bounds.size)
    |> RoundCornerImageProcessor(cornerRadius: 2)
    cell.imageView.kf.indicatorType = .activity
    cell.imageView.kf.setImage(
      with: URL(string: gallery.hdUrl),
      options: [
        .processor(processor),
        .scaleFactor(UIScreen.main.scale),
        .transition(.fade(1)),
        .cacheOriginalImage
      ]) { result in
        if case .success(let value) = result {
          ImageCache.default.store(value.image, forKey: gallery.hdUrl)
        }
      }
    return cell
  }
}

extension HomeViewController: UICollectionViewDelegate {}
