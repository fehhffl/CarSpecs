//
//  CarInfosViewController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 21/09/23.
//
import Kingfisher

import UIKit

class CarInfosViewController: BaseViewController {
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var topSpeedInformationText: UILabel!
    @IBOutlet weak var zeroToOneHundredInformationText: UILabel!
    @IBOutlet weak var horsepowersInformationText: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var carPrice: UILabel!
    @IBOutlet weak var engine: UILabel!
    @IBOutlet weak var carType: UILabel!
    @IBOutlet weak var transmission: UILabel!
    @IBOutlet weak var carName: UILabel!
    @IBOutlet weak var stackViewImages: UIStackView!
    @IBOutlet weak var carYear: UILabel!
    @IBOutlet weak var carGasImage: UIImageView!
    var isFavorite = false
    var heartButton: UIBarButtonItem?
    private let carRepository = CarRepository()
    private var carTechnicalInformation: CarTechnicalInformation?
    private var car: Car?
    var carId: Int

    init(carId: Int) {
        self.carId = carId
        self.carTechnicalInformation = nil
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clearLabels() {
        
    }

    @objc func onHeartButtonTapped() {
        if !isFavorite {
            isFavorite = true
            heartButton?.image = UIImage(systemName: "heart.fill")
            carRepository.addCarToFavorites(car: car)
        } else {
            isFavorite = false
            heartButton?.image = UIImage(systemName: "heart")
            carRepository.removeFromFavorites(car: car)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        heartButton = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(onHeartButtonTapped)
        )
        navigationItem.rightBarButtonItem = heartButton

        showLoader()
        carRepository.getTechnicalInformation(
            carId: carId,
            completion: { [weak self] (info: CarTechnicalInformation) in
                guard let self = self else {
                    return
                }
                self.carTechnicalInformation = info
                self.car = Car(
                    name: info.name,
                    price: info.price,
                    imageName: info.images.first ?? "no-image",
                    carId: info.id
                )
                self.isFavorite = self.car?.isFavorited ?? false
                if self.isFavorite {
                    self.heartButton?.image = UIImage(systemName: "heart.fill")
                } else {
                    self.heartButton?.image = UIImage(systemName: "heart")
                }
                DispatchQueue.main.async {
                    self.hideLoader()
                    self.configLabels()
                }
            })
    }

    func updateCarInfo(information: CarTechnicalInformation) {
        self.carTechnicalInformation = information
        DispatchQueue.main.async {
            self.hideLoader()
            self.configLabels()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Car Information"
        configView()
    }

    func configLabels() {
        guard let info = carTechnicalInformation else {
            return
        }
        let performance = info.performance

        if let topSpeed = performance.topSpeed {
            topSpeedInformationText.text = String(format: "%dKm/h", topSpeed)
        } else {
            topSpeedInformationText.text = "?"
        }

        if let acceleration = performance.acceleration {
            zeroToOneHundredInformationText.text = String(format: "%.1fs", acceleration)
        } else {
            zeroToOneHundredInformationText.text = "?"
        }

        horsepowersInformationText.text = String(format: "%dHP", info.drive.horsePower)
        descriptionText.text = info.description
        carPrice.text = info.price.currencyFR
        carName.text = info.name
        engine.text = info.drive.engineType.capitalized
        carType.text = info.type.capitalized
        transmission.text = info.transmission.capitalized
        carYear.text = String(info.year)

        let marginSpacing = 24
        let imageViewWidth = screenWidth - (2 * marginSpacing)

        let carImageOriginalWidth = 350
        let carImageOriginalHeight = 233

        info.images.forEach { (imageUrlString) in
            let imageView: UIImageView = UIImageView()
            imageView.widthAnchor.constraint(equalToConstant: CGFloat(imageViewWidth)).isActive = true
            imageView.setAspectRatio(carImageOriginalWidth, carImageOriginalHeight)
            let url = URL(string: imageUrlString)
            imageView.kf.setImage(with: url)
            imageView.contentMode = .scaleAspectFill
            stackViewImages.addArrangedSubview(imageView)
        }
    }

    func configView() {
        view1.layer.cornerRadius = 15
        view1.clipsToBounds = true
        view1.layer.borderWidth = 0
        view2.layer.cornerRadius = 15
        view2.clipsToBounds = true
        view2.layer.borderWidth = 0
        view3.layer.cornerRadius = 15
        view3.clipsToBounds = true
        view3.layer.borderWidth = 0
    }
}
