//
//  MockGalleryService.swift
//  NasaGalleryTests
//
//  Created by Rugmangathan on 21/08/22.
//

@testable import NasaGallery

class MockGalleryService: GalleryApi {
  var galleries: [Gallery]?
  var fetchSuccess: Bool = false

  func fetch(completion: (Result<[Gallery], Error>) -> Void) {
    if let galleries = galleries {
      fetchSuccess = true
      return completion(.success(galleries))
    } else {
      return completion(.failure(GalleryError.notFound))
    }
  }
}

