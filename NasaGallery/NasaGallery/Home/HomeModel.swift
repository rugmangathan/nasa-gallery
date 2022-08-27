//
//  HomeModel.swift
//  NasaGallery
//
//  Created by Rugmangathan on 21/08/22.
//

class HomeModel {
  let fetchEvent: FetchEvent
  let galleries: [Gallery]?

  init(
    fetchEvent: FetchEvent,
    _ galleries: [Gallery] = []
  ) {
    self.fetchEvent = fetchEvent
    self.galleries = galleries
  }
}

enum FetchEvent: Equatable {
  case inFlight
  case fetchFailed
  case fetchSuccessful
}

extension HomeModel: Equatable {
  static func == (lhs: HomeModel, rhs: HomeModel) -> Bool {
    lhs.fetchEvent == rhs.fetchEvent
  }
}
