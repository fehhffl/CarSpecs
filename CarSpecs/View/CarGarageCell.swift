//
//  CarGarageCell.swift
//  CarSpecs
//
//  Created by Felipe Lima on 06/09/23.
//

import Kingfisher
import UIKit

class CarGarageCell: UITableViewCell {
    @IBOutlet weak var viewCarCell: UIView!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var carName: UILabel!
    @IBOutlet weak var cardBackgroundView: UIView!
    @IBOutlet weak var carPrice: UILabel!

    func configure(item: CardItem) {
        carPrice.text = item.subtitle

        cellImage.kf.setImage(
            with: URL(string: item.imageName),
            placeholder: UIImage(named: "no-image")
        )
        carName.text = item.title
        cardBackgroundView.layer.cornerRadius = 10
        cardBackgroundView.clipsToBounds = true
    }
}
