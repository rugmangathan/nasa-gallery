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
  @IBOutlet weak var retryButton: UIButton!
  @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
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
    progressIndicator.stopAnimating()
    retryButton.isHidden = true
  }

  @IBAction func retryButtonTapped(_ sender: UIButton) {
    setupImage()
    retryButton.isHidden = true
  }

  private func setupImage() {
    guard let gallery = gallery else { return }
    progressIndicator.startAnimating()
    let completion: (Result<UIImage, ImageServiceError>) -> Void = { [weak self] result in
      self?.progressIndicator.stopAnimating()
      if case .success(let image) = result {
        self?.imageView.image = image
        self?.retryButton.isHidden = true
      } else {
        self?.imageView.image = UIImage(systemName: "photo")
        self?.retryButton.isHidden = false
      }
    }
    if imageService.isCached(for: gallery.url) {
      imageService.getImageFromCache(with: gallery.url, completion: completion)
    } else {
      imageService.getImage(for: gallery.url, completion: completion)
    }
  }

  private func setupCell() {
    titleLabel.text = gallery?.title
    setupImage()
  }
}
