//
//  CategoryCell.swift
//  CarSpecs
//
//  Created by Felipe Lima on 30/08/23.
//

import UIKit

class CategoryCell: UITableViewCell {
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    let gradientLayer = CAGradientLayer()
    func configure(with item: CategoryItem) {
        setGradientBackground()
        titleLabel.text = item.title
        mainImage.image = UIImage(named: item.imageName)
    }
    func setGradientBackground() {
        let colorTop =  UIColor.black.cgColor
        let colorBottom = UIColor.clear.cgColor
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1]
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }

}
