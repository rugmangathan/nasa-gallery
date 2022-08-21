//
//  HomeEffectHandlerTests.swift
//  NasaGalleryTests
//
//  Created by Rugmangathan on 21/08/22.
//

import XCTest
import Cuckoo
@testable import NasaGallery

class HomeEffectHandlerTests: XCTestCase {
  func test_should_call_fetch_galleries_when_effect_is_fetch_galleries() {
    let spy = MockSpyableHomeAction()
      .withEnabledSuperclassSpy()

    let effectHandler = HomeEffectHandler(spy)

    effectHandler.handle(.fetchGalleries)

    verify(spy, times(1)).fetchGalleries()
  }
}
