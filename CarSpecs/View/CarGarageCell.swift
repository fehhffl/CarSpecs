//
//  CarGarageCell.swift
//  CarSpecs
//
//  Created by Felipe Lima on 06/09/23.
//

import UIKit

class CarGarageCell: UITableViewCell {
    @IBOutlet weak var viewCarCell: UIView!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var carName: UILabel!
    @IBOutlet weak var cardBackgroundView: UIView!
    @IBOutlet weak var carPrice: UILabel!

    func configure(item: SquareCardItem) {
        carPrice.text = item.subtitle
        cellImage.image = UIImage(named: item.imageName)
        carName.text = item.title
        cardBackgroundView.layer.cornerRadius = 10
        cardBackgroundView.clipsToBounds = true
    }
}
