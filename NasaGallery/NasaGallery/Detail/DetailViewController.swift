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
  private var detailViews: [DetailView?] = []
  private var transitioning: Bool = false
  private var imageService: ImageServiceApi = {
    ImageService.shared
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    detailViews = [DetailView?](repeating: nil, count: galleries.count)
    pageControl.numberOfPages = galleries.count
    pageControl.currentPage = selectedIndex
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    _ = setupInitialViews
  }

  lazy var setupInitialViews: Void = {
    setupScrollView()
    gotoPage(page: selectedIndex, animated: false)
  }()

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)

    removeAnyGalleries()

    coordinator.animate(alongsideTransition: nil) { _ in
      self.setupScrollView()
      self.detailViews = [DetailView?](repeating: nil, count: self.galleries.count)
      self.transitioning = true
      self.gotoPage(page: self.pageControl.currentPage, animated: false)
      self.transitioning = false
    }

    super.viewWillTransition(to: size, with: coordinator)
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

  @IBAction func unwindFromDetail(segue: UIStoryboardSegue) {}
}

extension DetailViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let pageWidth = self.scrollView.frame.width
    let page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
    pageControl.currentPage = Int(page)
    loadCurrentPages(page: pageControl.currentPage)
  }
}

// MARK: private methods
extension DetailViewController {
  private func setupScrollView() {
    scrollView.contentSize = CGSize(
      width: scrollView.frame.width * CGFloat(galleries.count),
      height: scrollView.frame.height - view.safeAreaInsets.top
    )
  }

  private func removeAnyGalleries() {
    for detailView in detailViews where detailView != nil {
      detailView?.removeFromSuperview()
    }
  }

  private func loadPage(_ page: Int) {
    guard page < galleries.count && page != -1 else { return }

    if detailViews[page] == nil {
      guard let detailView = Bundle.main
        .loadNibNamed("DetailView", owner: self)?.first as? DetailView else {
        return
      }
      imageService.getImage(for: galleries[page].url) { result in
        if case .success(let image) = result {
          detailView.imageView.image = image
        }
      }
      var frame = scrollView.frame
      frame.origin.x = frame.width * CGFloat(page)
      frame.origin.y = -self.view.safeAreaInsets.top
      frame.size.height += self.view.safeAreaInsets.top
      detailView.frame = frame
      scrollView.addSubview(detailView)

      detailViews[page] = detailView
    }
  }

  private func loadCurrentPages(page: Int) {
    guard (page > 0 && page + 1 < galleries.count) || transitioning else { return }

    removeAnyGalleries()
    detailViews = [DetailView?](repeating: nil, count: galleries.count)

    loadPage(Int(page) - 1)
    loadPage(Int(page))
    loadPage(Int(page) + 1)
  }

  private func gotoPage(page: Int, animated: Bool) {
    loadCurrentPages(page: page)
    var bounds = scrollView.bounds
    bounds.origin.x = bounds.width * CGFloat(page)
    bounds.origin.y = 0
    scrollView.scrollRectToVisible(bounds, animated: animated)
  }
}
