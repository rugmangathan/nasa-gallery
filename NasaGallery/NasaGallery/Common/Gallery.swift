//
//  Gallery.swift
//  NasaGallery
//
//  Created by Rugmangathan on 21/08/22.
//

import Foundation

struct Gallery: Decodable {
  let copyright: String?
  let date: Date
  let explanation: String
  let hdUrl: String
  let mediaType: String
  let serviceVersion: String
  let title: String
  let url: String

  init(
    copyright: String?,
    date: Date,
    explanation: String,
    hdUrl: String,
    mediaType: String,
    serviceVersion: String,
    title: String,
    url: String
  ) {
    self.copyright = copyright
    self.date = date
    self.explanation = explanation
    self.hdUrl = hdUrl
    self.mediaType = mediaType
    self.serviceVersion = serviceVersion
    self.title = title
    self.url = url
  }

  // MARK: Decodable helpers
  enum CodingKeys: String, CodingKey {
    case copyright
    case date
    case explanation
    case hdUrl = "hdurl"
    case mediaType
    case serviceVersion
    case title
    case url
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    copyright = try? container.decode(String?.self, forKey: .copyright)
    date = try container.decode(Date.self, forKey: .date)
    explanation = try container.decode(String.self, forKey: .explanation)
    hdUrl = try container.decode(String.self, forKey: .hdUrl)
    mediaType = try container.decode(String.self, forKey: .mediaType)
    serviceVersion = try container.decode(String.self, forKey: .serviceVersion)
    title = try container.decode(String.self, forKey: .title)
    url = try container.decode(String.self, forKey: .url)
  }
}

extension Gallery: Equatable {}
