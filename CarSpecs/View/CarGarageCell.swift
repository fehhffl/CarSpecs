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

    func configure(item: CarGarageItem) {
        let moeda = "USD"
        carPrice.text = String(format: "$%.2f %@", item.price, moeda)
        cellImage.image = UIImage(named: item.imageName)
        carName.text = item.title
        cardBackgroundView.layer.cornerRadius = 10
        cardBackgroundView.clipsToBounds = true
    }
}
