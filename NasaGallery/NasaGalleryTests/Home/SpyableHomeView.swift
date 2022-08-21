//
//  SpyableHomeView.swift
//  NasaGalleryTests
//
//  Created by Rugmangathan on 21/08/22.
//

@testable import NasaGallery

class SpyableHomeView: HomeView {
  func showActivity() {}

  func showGalleries(_ galleries: [Gallery]) {}

  func showFailedState(_ message: String) {}

  func showEmptyState() {}
}
