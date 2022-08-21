//
//  HomeLogic.swift
//  NasaGallery
//
//  Created by Rugmangathan on 21/08/22.
//

import MobiusCore

struct HomeLogic {
  static func update(_ model: HomeModel, _ event: HomeEvent) -> Next<HomeModel, HomeEffect> {
    switch event {
    case .viewCreated:
      return .next(model, effects: [.fetchGalleries])
    case .fetchFailed:
      return .next(.init(fetchEvent: .fetchFailed))
    case .fetchSuccessful(let galleries):
      return .next(.init(fetchEvent: .fetchSuccessful, galleries))
    }
  }
}
