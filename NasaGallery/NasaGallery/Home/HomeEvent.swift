//
//  HomeEvent.swift
//  NasaGallery
//
//  Created by Rugmangathan on 21/08/22.
//

import Foundation

enum HomeEvent {
  case viewCreated
  case fetchFailed
  case fetchSuccessful([Gallery])
}
