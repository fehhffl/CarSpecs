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
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var squareCardView: UIView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var labelsStackView: UIStackView!
    private var carroQueRepresento: Car?
    private var listaCarrosFavoritos: [Car] {
        return Defaults[key: DefaultsKeys.favoriteCars]
    }

    private var isFavorite: Bool = false
    func isCarFavorite() -> Bool {
        return listaCarrosFavoritos.contains(where: { (car) -> Bool in
            if car.name == carroQueRepresento?.name {
                return true
            } else {
                return false
            }
        })
    }

    func configure(with style: Style, item: SquareCardItem, car: Car? = nil) {
        self.carroQueRepresento = car

        if isCarFavorite() {
            isFavorite = true
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            isFavorite = false
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }

        switch style {
        case .style1:
            imageViewHeightConstraint.constant = 75
            squareCardView.layer.cornerRadius = 8
            squareCardView.clipsToBounds = true
            squareCardView.layer.borderWidth = 1
            secondLabel.isHidden = true
            squareCardView.layer.borderColor = UIColor.lightGray.cgColor
            heartButton.isHidden = true
            firstLabel.text = item.title
            imageView.image = UIImage(named: item.imageName)
            labelsStackView.axis = .vertical
        case .style2:
            heartButton.isHidden = false
            imageViewHeightConstraint.constant = 120
            if let imageUrl = URL(string: item.imageName) {
                imageView.kf.setImage(with: imageUrl)
            } else {
                imageView.image = UIImage(named: "no-image")
            }
            secondLabel.isHidden = false
            secondLabel.text = item.subtitle
            firstLabel.text = item.title
            squareCardView.layer.borderWidth = 0
            labelsStackView.axis = .vertical
        case .style3:
            heartButton.isHidden = true
            squareCardView.layer.borderWidth = 10
            imageViewHeightConstraint.constant = 120
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
            addCellCarToFavorites()
        } else {
            isFavorite = false
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
            removeFromFavorites()
        }
    }
    private func removeFromFavorites() {
        Defaults[key: DefaultsKeys.favoriteCars].removeAll { (car) -> Bool in
            if car.name == carroQueRepresento?.name {
                return true
            } else {
                return false
            }
        }
    }

    private func addCellCarToFavorites() {
        if let carro = carroQueRepresento {
            Defaults[key: DefaultsKeys.favoriteCars].append(carro)
        }
    }
}
