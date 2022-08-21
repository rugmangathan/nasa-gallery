//
//  HomeRenderer.swift
//  NasaGallery
//
//  Created by Rugmangathan on 21/08/22.
//

import Foundation

class HomeRenderer {
  let view: HomeView

  init(view: HomeView) {
    self.view = view
  }

  func render(_ model: HomeModel) {
    switch model.fetchEvent {
    case .inFlight:
      view.showActivity()
    case .fetchFailed:
      view.showFailedState("Error")
    case .fetchSuccessful:
      if let galleries = model.galleries, !galleries.isEmpty {
        view.showGalleries(galleries)
      } else {
        view.showEmptyState()
      }
    }
  }
}
