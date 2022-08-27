//
//  InfoViewController.swift
//  NasaGallery
//
//  Created by Rugmangathan on 27/08/22.
//

import UIKit

class InfoViewController: UIViewController {
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var copyrightLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  var gallery: Gallery?

  override func viewDidLoad() {
    super.viewDidLoad()

    descriptionLabel.text = gallery?.explanation
    copyrightLabel.text = gallery?.copyright
    dateLabel.text = gallery?.date
  }

  @IBAction func cancelButtonTap(_ sender: UIBarButtonItem) {
    performSegue(withIdentifier: "UnwindSegue", sender: nil)
  }
}
