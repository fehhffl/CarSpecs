//
//  SquareCard.swift
//  CarSpecs
//
//  Created by Felipe Lima on 09/08/23.
//

import UIKit
enum Style {
    case style1
    case style2
}
class SquareCard: UICollectionViewCell {
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var squareCardView: UIView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    private var isFavorite: Bool = false
    public var size = CGSize(width: 150, height: 100)
    func configure(with style: Style) {
        switch style {
        case .style1:
            size = CGSize(width: 200, height: 150)
            imageViewHeightConstraint.constant = 75
            squareCardView.layer.cornerRadius = 8
            squareCardView.clipsToBounds = true
            squareCardView.layer.borderWidth = 1
            secondLabel.isHidden = true
            squareCardView.layer.borderColor = UIColor.lightGray.cgColor
            heartButton.isHidden = true
        case .style2:
            heartButton.isHidden = false
            size = CGSize(width: 350, height: 200)
            imageViewHeightConstraint.constant = 120
            imageView.image = UIImage(named: "tesla-model-x.jpg")
            secondLabel.isHidden = false
            secondLabel.text = "Used Audi A4 1.8T 2016"
            firstLabel.text = "Eletric"
            squareCardView.layer.borderWidth = 0
        }
    }
    @IBAction func onHeartButtonTapped(_ sender: Any) {
        if isFavorite == false {
            isFavorite = true
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            isFavorite = false
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
}
