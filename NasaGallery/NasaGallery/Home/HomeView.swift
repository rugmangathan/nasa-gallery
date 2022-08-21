//
//  HomeView.swift
//  NasaGallery
//
//  Created by Rugmangathan on 21/08/22.
//

import Foundation

protocol HomeView {
  func showActivity()
  func showGalleries(_ galleries: [Gallery])
  func showFailedState(_ message: String)
  func showEmptyState()
}
