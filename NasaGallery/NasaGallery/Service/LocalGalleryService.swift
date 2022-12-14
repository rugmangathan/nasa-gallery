//
//  LocalGalleryService.swift
//  NasaGallery
//
//  Created by Rugmangathan on 21/08/22.
//

import Foundation

class LocalGalleryService {
  private let bundle: Bundle
  static let shared = LocalGalleryService()
  init(bundle: Bundle = Bundle.main) {
    self.bundle = bundle
  }
}

extension LocalGalleryService: GalleryApi {
  func fetch(completion: (Result<[Gallery], GalleryError>) -> Void) {
    guard let path = bundle.path(forResource: "data", ofType: "json") else {
      completion(.failure(GalleryError.fileNotFound))
      return
    }

    do {
      let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
      let jsonDecoder = JSONDecoder()
      jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
      jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
      let galleries = try jsonDecoder.decode([Gallery].self, from: data)
      completion(.success(galleries))
    } catch let error as DecodingError {
      completion(.failure(GalleryError.decodingError(error.errorDescription ?? error.localizedDescription)))
    } catch let error {
      completion(.failure(GalleryError.others(error.localizedDescription)))
    }
  }
}

extension DateFormatter {
  static let yyyyMMdd: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
  }()
}
