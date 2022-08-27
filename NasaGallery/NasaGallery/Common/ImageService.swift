//
//  ImageService.swift
//  NasaGallery
//
//  Created by Rugmangathan on 21/08/22.
//

import UIKit
import Kingfisher

enum ImageServiceError: Error {
  case cacheError
  case others(String)
}

protocol ImageServiceApi {
  func getImage(for url: String, completion: @escaping (Result<UIImage, ImageServiceError>) -> Void)
  func getImageFromCache(with key: String, completion: @escaping (Result<UIImage, ImageServiceError>) -> Void)
  func isCached(for key: String) -> Bool
}

class ImageService {
  static let shared = ImageService()
  private lazy var cache: ImageCache = {
    var cache = ImageCache.default
    cache.diskStorage.config.sizeLimit = 1000 * 1024 * 1024 // 1GB
    cache.diskStorage.config.expiration = .never
    cache.memoryStorage.config.expiration = .seconds(600) // 10 minutes
    cache.memoryStorage.config.totalCostLimit = 300 * 1024 * 1024 // 300MB
    return cache
  }()
}

extension ImageService: ImageServiceApi {
  func isCached(for key: String) -> Bool {
    cache.isCached(forKey: key)
  }

  func getImage(for url: String, completion: @escaping (Result<UIImage, ImageServiceError>) -> Void) {
    if isCached(for: url) {
      getImageFromCache(with: url, completion: completion)
    } else {
      KingfisherManager.shared.retrieveImage(with: URL(string: url)!) { result in
        switch result {
        case .success(let cacheResult):
          completion(.success(cacheResult.image))
        case .failure(let kfError):
          completion(.failure(.others(kfError.localizedDescription)))
        }
      }
    }
  }

  func getImageFromCache(
    with key: String,
    completion: @escaping (Result<UIImage, ImageServiceError>) -> Void
  ) {
    cache.retrieveImage(forKey: key) { result in
      switch result {
      case .success(let cacheResult):
        if let image = cacheResult.image {
          completion(.success(image))
        } else {
          completion(.failure(ImageServiceError.cacheError))
        }
      case .failure(let kfError):
        completion(.failure(.others(kfError.localizedDescription)))
      }
    }
  }
}
