//
//  DetailViewController.swift
//  NasaGallery
//
//  Created by Rugmangathan on 27/08/22.
//

import UIKit

class DetailViewController: UIViewController {
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
  var galleries: [Gallery] = []
  var selectedIndex: Int = 0
  private var imageService: ImageServiceApi = {
    ImageService.shared
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    title = galleries[selectedIndex].title
    dateLabel.text = galleries[selectedIndex].date
    imageService.getImage(for: galleries[selectedIndex].url) { [weak self] result in
      guard let self = self else { return }
      if case .success(let image) = result {
        self.imageViewHeightConstraint.constant = self.calculateImageHeight(sourceImage: image.size)
        self.imageView.image = image
        self.descriptionLabel.text = self.galleries[self.selectedIndex].explanation
      }
    }
  }

  private func calculateImageHeight(sourceImage: CGSize) -> CGFloat {
    let oldWidth = sourceImage.width
    let scaleFactor = view.bounds.width / oldWidth
    let newHeight = sourceImage.height * scaleFactor
    return newHeight
  }
}
