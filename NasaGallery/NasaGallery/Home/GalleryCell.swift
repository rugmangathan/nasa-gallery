//
//  GalleryCell.swift
//  NasaGallery
//
//  Created by Rugmangathan on 21/08/22.
//

import UIKit
import Kingfisher

class GalleryCell: UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  private lazy var imageService: ImageServiceApi = {
    ImageService.shared
  }()
  var gallery: Gallery? {
    didSet {
      setupCell()
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    contentView.layer.cornerRadius = 6
    layer.cornerRadius = 6
    layer.borderColor = UIColor.gray.cgColor
    layer.borderWidth = 1.0
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    guard let gallery = gallery else { return }
    imageService.cancelDownloadTask(for: gallery.url)
    imageView.image = nil
    titleLabel.text = ""
  }

  private func setupCell() {
    guard let gallery = gallery else {
      return
    }

    titleLabel.text = gallery.title
    let completion: (Result<UIImage, ImageServiceError>) -> Void = { result in
      if case .success(let image) = result {
        self.imageView.image = image
      }
    }
    if ImageService.shared.isCached(for: gallery.url) {
      imageService.getImageFromCache(with: gallery.url, completion: completion)
    } else {
      imageService.getImage(for: gallery.url, completion: completion)
    }
  }
}
