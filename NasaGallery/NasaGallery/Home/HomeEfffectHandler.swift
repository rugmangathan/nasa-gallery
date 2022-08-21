//
//  HomeEfffectHandler.swift
//  NasaGallery
//
//  Created by Rugmangathan on 21/08/22.
//

import MobiusExtras

class HomeEffectHandler: ConnectableClass<HomeEffect, HomeEvent> {
  let action: HomeAction

  init(_ action: HomeAction) {
    self.action = action
  }

  override func handle(_ input: HomeEffect) {
    switch input {
    case .fetchGalleries:
      action.fetchGalleries()
    }
  }
}
