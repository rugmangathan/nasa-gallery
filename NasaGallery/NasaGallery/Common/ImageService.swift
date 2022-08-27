//
//  ImageService.swift
//  NasaGallery
//
//  Created by Rugmangathan on 21/08/22.
//

import UIKit
import Kingfisher

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

  func getImageFromCache(url: String, completion: @escaping (Result<UIImage, KingfisherError>) -> Void) {
    let imageCache = cache.imageCachedType(forKey: url)
    if imageCache.cached {
      cache.retrieveImage(forKey: url) { result in
        switch result {
        case .success(let cacheResult):
          if let image = cacheResult.image {
            completion(.success(image))
          } else {
            completion(.failure(KingfisherError.cacheError(reason: .imageNotExisting(key: url))))
          }
        case .failure(let kfError):
          completion(.failure(kfError))
        }
      }
    } else {
      KingfisherManager.shared.retrieveImage(with: URL(string: url)!) { result in
        switch result {
        case .success(let cacheResult):
          completion(.success(cacheResult.image))
        case .failure(let kfError):
          completion(.failure(kfError))
        }
      }
    }

  }
}
