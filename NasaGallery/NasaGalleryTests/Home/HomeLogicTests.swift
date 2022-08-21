//
//  HomeLogicTests.swift
//  NasaGalleryTests
//
//  Created by Rugmangathan on 21/08/22.
//

import XCTest
import MobiusTest
@testable import NasaGallery

class HomeLogicTests: XCTestCase {
  private var logic: UpdateSpec<HomeModel, HomeEvent, HomeEffect>!
  private var model: HomeModel!

  override func setUp() {
    super.setUp()

    logic = UpdateSpec<HomeModel, HomeEvent, HomeEffect>(HomeLogic.update)
    model = HomeModel(fetchEvent: .inFlight)
  }

  override func tearDown() {
    logic = nil
    model = nil
    super.tearDown()
  }

  func test_should_fetch_gallery_data_when_view_is_initiated() {
    logic
      .given(model)
      .when(HomeEvent.viewCreated)
      .then(
        assertThatNext(
          hasModel(model),
          hasEffects([.fetchGalleries])
        )
      )
  }

  func test_should_show_failed_state_when_fest_failed() {
    logic
      .given(model)
      .when(.fetchFailed)
      .then(
        assertThatNext(
          hasModel(.init(fetchEvent: .fetchFailed)),
          hasNoEffects()
        )
      )
  }

  func test_should_show_gallery_when_fetch_galleries_is_successful() {
    let galleries = [Gallery.mock]

    logic
      .given(model)
      .when(.fetchSuccessful(galleries))
      .then(
        assertThatNext(
          hasModel(.init(fetchEvent: .fetchSuccessful, galleries))
        )
      )
  }
}
