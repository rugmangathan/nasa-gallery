//
//  DetailViewController.swift
//  NasaGallery
//
//  Created by Rugmangathan on 27/08/22.
//

import UIKit
import SwiftUI

class DetailViewController: UIViewController {
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var pageControl: UIPageControl!
  var galleries: [Gallery] = []
  var selectedIndex: Int = 0
  private var detailViews: [DetailView] = []
  private var imageService: ImageServiceApi = {
    ImageService.shared
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    scrollView.delegate = self
    setupViews()
  }

  @IBAction func infoButtonTapped(_ sender: UIButton) {
    guard let infoView = storyboard?
      .instantiateViewController(withIdentifier: "InfoViewController")
            as? InfoViewController else {
      return
    }
    infoView.gallery = galleries[selectedIndex]
    navigationController?.showDetailViewController(infoView, sender: self)
  }

  @IBAction func unwindFromDetail(segue: UIStoryboardSegue) {

  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    scrollView.subviews.forEach { $0.removeFromSuperview() }
    setupViews()
  }
}

extension DetailViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let page = Int(round(scrollView.contentOffset.x / view.frame.width))
    pageControl.currentPage = page
    selectedIndex = page
  }
}

// MARK: private methods
extension DetailViewController {
  private func setupViews() {
    detailViews = createDetailViews()

    setupScrollView(detailViews: detailViews)
    pageControl.numberOfPages = galleries.count
    pageControl.currentPage = selectedIndex
  }

  private func setupScrollView(detailViews : [DetailView]) {
    scrollView.contentSize = CGSize(
      width: view.bounds.width * CGFloat(detailViews.count),
      height: scrollView.bounds.height
    )
    scrollView.isPagingEnabled = true
    scrollView.contentOffset = CGPoint(x: view.frame.width * CGFloat(selectedIndex), y: 0)

    for index in 0 ..< detailViews.count {
      detailViews[index].frame = CGRect(
        x: view.bounds.width * CGFloat(index),
        y: 0,
        width: view.bounds.width,
        height: scrollView.bounds.height
      )
      scrollView.addSubview(detailViews[index])
    }
  }

  private func createDetailViews() -> [DetailView] {
    galleries.compactMap { gallery in
      guard let detailView = Bundle.main
        .loadNibNamed("DetailView", owner: self)?.first as? DetailView else {
        return nil
      }
      imageService.getImage(for: gallery.url) { result in
        if case .success(let image) = result {
          detailView.imageViewHeightConstraint.constant = self.calculateImageHeight(sourceImage: image.size)
          detailView.imageView.image = image
        }
      }
      return detailView
    }
  }

  private func calculateImageHeight(sourceImage: CGSize) -> CGFloat {
    let oldWidth = sourceImage.width
    let scaleFactor = view.bounds.width / oldWidth
    let newHeight = sourceImage.height * scaleFactor
    return newHeight
  }
}
