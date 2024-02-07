//
//  SquareCard.swift
//  CarSpecs
//
//  Created by Felipe Lima on 09/08/23.
//

import UIKit
import SwiftyUserDefaults

enum Style {
    case style1
    case style2
    case style3
}

class SquareCard: UICollectionViewCell {
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var squareCardView: UIView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var labelsStackView: UIStackView!
    private var carroQueRepresento: Car?
    var carRepository = CarRepository()
    private var isFavorite: Bool = false

    func configure(with style: Style, item: CardItem, car: Car? = nil) {
        self.carroQueRepresento = car
        if carroQueRepresento?.isFavorited == true {
            isFavorite = true
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            isFavorite = false
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }

        switch style {
        case .style1:
            imageView.setAspectRatio(4, 3)
            squareCardView.layer.cornerRadius = 8
            squareCardView.clipsToBounds = true
            squareCardView.layer.borderWidth = 1
            secondLabel.isHidden = true
            squareCardView.layer.borderColor = UIColor.lightGray.cgColor
            heartButton.isHidden = true
            firstLabel.text = item.title
            if let imageUrl = URL(string: item.imageName) {
                imageView.setImageResized(with: imageUrl)
            } else {
                imageView.image = UIImage(named: "no-image")
            }
            labelsStackView.axis = .vertical
        case .style2:
            imageView.setAspectRatio(16, 9)
            heartButton.isHidden = false
            if let imageUrl = URL(string: item.imageName) {
                imageView.setImageResized(with: imageUrl)
            } else {
                imageView.image = UIImage(named: "no-image")
            }
            secondLabel.isHidden = false
            secondLabel.text = item.subtitle
            firstLabel.text = item.title
            squareCardView.layer.borderWidth = 0
            labelsStackView.axis = .vertical
        case .style3:
            imageView.setAspectRatio(16, 9)
            heartButton.isHidden = true
            squareCardView.layer.borderWidth = 10
            imageView.image = UIImage(named: item.imageName)
            secondLabel.isHidden = false
            secondLabel.text = item.subtitle
            firstLabel.text = item.title
            squareCardView.layer.borderWidth = 0
            labelsStackView.axis = .horizontal
            labelsStackView.removeArrangedSubview(firstLabel)
            labelsStackView.removeArrangedSubview(secondLabel)
            labelsStackView.addArrangedSubview(secondLabel)
            labelsStackView.addArrangedSubview(firstLabel)
        }
    }

    @IBAction func onHeartButtonTapped(_ sender: Any) {
        if !isFavorite {
            isFavorite = true
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            carRepository.addCarToFavorites(car: carroQueRepresento)
        } else {
            isFavorite = false
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
            carRepository.removeFromFavorites(car: carroQueRepresento)
        }
    }
}
