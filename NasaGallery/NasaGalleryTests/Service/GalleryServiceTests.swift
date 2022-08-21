//
//  GalleryServiceTests.swift
//  NasaGalleryTests
//
//  Created by Rugmangathan on 21/08/22.
//

@testable import NasaGallery
import XCTest

class GalleryServiceTests: XCTestCase {
  func test_should_return_galleries() {
    let service = MockGalleryService()
    service.galleries = [
      Gallery()
    ]

    service.fetch { result in }
    XCTAssertTrue(service.fetchSuccess)
  }

  func test_should_return_error() {
    let service = MockGalleryService()
    service.fetch { result in
      if case .failure(let error as GalleryError) = result {
        XCTAssertEqual(GalleryError.notFound, error)
      }
    }
  }
}
