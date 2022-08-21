//
//  GalleryCell.swift
//  NasaGallery
//
//  Created by Rugmangathan on 21/08/22.
//

import UIKit

class GalleryCell: UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView!

  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = UIImage()
  }
}
