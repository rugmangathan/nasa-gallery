//
//  Gallery+Tests.swift
//  NasaGalleryTests
//
//  Created by Rugmangathan on 21/08/22.
//

@testable import NasaGallery
import Foundation

extension Gallery {
  static let mock: Gallery = Gallery(
    copyright: "Melvin",
    date: Date(),
    explanation: "This is a mock text",
    hdUrl: "https://en.wikipedia.org/wiki/Mount_Everest#/media/File:Everest_North_Face_toward_Base_Camp_Tibet_Luca_Galuzzi_2006.jpg",
    mediaType: "image",
    serviceVersion: "1.0",
    title: "Mount Everest",
    url: "https://en.wikipedia.org/wiki/Mount_Everest#/media/File:Everest_North_Face_toward_Base_Camp_Tibet_Luca_Galuzzi_2006.jpg"
  )
}
