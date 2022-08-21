//
//  HomeRendererTests.swift
//  NasaGalleryTests
//
//  Created by Rugmangathan on 21/08/22.
//

import Cuckoo
import XCTest
@testable import NasaGallery

class HomeRendererTests: XCTestCase {
  private var spy: MockSpyableHomeView!

  override func setUp() {
    super.setUp()

    spy = MockSpyableHomeView().withEnabledSuperclassSpy()

  }

  func test_should_verify_show_activity_is_called_when_in_flight() {
    let renderer = HomeRenderer(view: spy)

    renderer.render(HomeModel.init(fetchEvent: .inFlight))

    verify(spy, times(1)).showActivity()
    verify(spy, never()).showFailedState(any())
    verify(spy, never()).showEmptyState()
    verify(spy, never()).showGalleries(any())

  }

  func test_should_show_failed_state_when_fetch_failed() {
    let renderer = HomeRenderer(view: spy)

    renderer.render(HomeModel.init(fetchEvent: .fetchFailed))

    verify(spy, times(1)).showFailedState(any())
    verify(spy, never()).showActivity()
    verify(spy, never()).showEmptyState()
    verify(spy, never()).showGalleries(any())
  }

  func test_should_show_fetched_galleries_when_fetch_successful() {
    let renderer = HomeRenderer(view: spy)
    let model = HomeModel.init(fetchEvent: .fetchSuccessful, [Gallery()])

    renderer.render(model)

    verify(spy, times(1)).showGalleries(any())
    verify(spy, never()).showFailedState(any())
    verify(spy, never()).showEmptyState()
    verify(spy, never()).showActivity()
  }

  func test_should_show_empty_message_when_fetch_successful_and_galleries_are_empty() {
    let renderer = HomeRenderer(view: spy)
    let model = HomeModel.init(fetchEvent: .fetchSuccessful, [])

    renderer.render(model)

    verify(spy, times(1)).showEmptyState()
    verify(spy, never()).showFailedState(any())
    verify(spy, never()).showGalleries(any())
    verify(spy, never()).showActivity()
  }
}
