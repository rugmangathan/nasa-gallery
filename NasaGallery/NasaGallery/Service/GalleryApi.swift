//
//  GalleryApi.swift
//  NasaGallery
//
//  Created by Rugmangathan on 21/08/22.
//

enum GalleryError: Error, Equatable {
  case fileNotFound
  case decodingError(String)
  case others(String)
}
protocol GalleryApi {
  func fetch(completion: (Result<[Gallery], GalleryError>) -> Void)
}
