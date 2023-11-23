//
//  SquareCard.swift
//  CarSpecs
//
//  Created by Felipe Lima on 09/08/23.
//

import UIKit
import SwiftyUserDefaults
import Lottie
import SnapKit

enum Style {
    case style1
    case newCarsStyle
    case style3
}

class SquareCard: UICollectionViewCell {
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var loadingContainerView: UIView! {
        didSet {
            setUpLoadingView()
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var squareCardView: UIView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var labelsStackView: UIStackView!
    private var carroQueRepresento: Car?
    var carRepository = CarRepository()
    private lazy var animationView = AnimationView(name: "loader")
    private var isFavorite: Bool = false

    func setUpLoadingView() {
        loadingContainerView.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
    }
    
    func styleAsLoading() {
        loadingContainerView.isHidden = false
    }

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
            loadingContainerView.isHidden = true
            imageViewHeightConstraint.constant = 75
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
        case . newCarsStyle:
            loadingContainerView.isHidden = true
            heartButton.isHidden = false
            imageViewHeightConstraint.constant = 120
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
            loadingContainerView.isHidden = true
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

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        animationView.play()
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
