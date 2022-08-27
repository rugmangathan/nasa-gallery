//
//  GalleryCell.swift
//  NasaGallery
//
//  Created by Rugmangathan on 21/08/22.
//

import UIKit

class GalleryCell: UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    contentView.layer.cornerRadius = 6
    layer.cornerRadius = 6
    layer.borderColor = UIColor.gray.cgColor
    layer.borderWidth = 1.0
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = UIImage()
    titleLabel.text = ""
  }
}
