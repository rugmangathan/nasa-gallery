//
//  GalleryApi.swift
//  NasaGallery
//
//  Created by Rugmangathan on 21/08/22.
//

enum GalleryError: String, Error {
  case notFound
}
protocol GalleryApi {
  func fetch(completion: (Result<[Gallery], Error>) -> Void)
}
