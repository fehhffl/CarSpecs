//
//  HomeViewController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 09/08/23.
//

import UIKit
import SwiftyUserDefaults

class HomeViewController: UIViewController,
                          UICollectionViewDelegate,
                          UICollectionViewDataSource,
                          UICollectionViewDelegateFlowLayout {
    @IBOutlet private weak var newCarsLabel: UILabel!
    @IBOutlet private weak var exploreCollectionView: UICollectionView!
    @IBOutlet private weak var exploreLabel: UILabel!
    @IBOutlet private weak var newCarsCollectionView: UICollectionView!
    private var exploreCards: [SquareCardItem] = []
    private let carRepository = CarRepository()
    private var cars: [Car] = []
    let squareCardsRepository = SquareCardsRepository.init()
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    override func viewDidLoad() {
        exploreCards = squareCardsRepository.getCategoriesCar()
        cars = carRepository.getAllCars()

        super.viewDidLoad()
        exploreLabel.text = "explore_home_screen_label".localize()
        newCarsLabel.text = "new_cars_home_screen_label".localize()
        exploreCollectionView.register(UINib(nibName: "SquareCard", bundle: .main
        ), forCellWithReuseIdentifier: "SquareCard")
        exploreCollectionView.delegate = self
        exploreCollectionView.dataSource = self
        newCarsCollectionView.register(UINib(nibName: "SquareCard", bundle: .main
        ), forCellWithReuseIdentifier: "SquareCard")
        newCarsCollectionView.delegate = self
        newCarsCollectionView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let valorRecuperado = Defaults[keyPath: \.username]
        title = valorRecuperado
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == exploreCollectionView {
            return exploreCards.count
        } else {
            return cars.count
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == exploreCollectionView {
            return CGSize(width: 128, height: 128)
        } else {
            return CGSize(width: screenWidth / 2 - 10, height: 200 )
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "SquareCard",
                for: indexPath) as? SquareCard
        else {
            fatalError()
        }
        if collectionView == exploreCollectionView {
            cell.configure(with: .style1, item: exploreCards[indexPath.row])
            return cell
        } else {
            let car = cars[indexPath.row]
            let squareCardItem = SquareCardItem(
                title: car.name,
                subtitle: String(format: "$%.2f", car.price),
                imageName: car.imageName)

            cell.configure(with: .style2, item: squareCardItem)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == newCarsCollectionView {
            let selectedCar = cars[indexPath.item]
            var currentFavoriteCars = Defaults[key: DefaultsKeys.favoriteCars]
            currentFavoriteCars.append(selectedCar)
            Defaults[key: DefaultsKeys.favoriteCars] = currentFavoriteCars

            let alertController = UIAlertController(title: "Saved", message: "Car added to favorites", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true)
        }
    }
}
extension DefaultsKeys {
    static var favoriteCars: DefaultsKey<[Car]> { DefaultsKey("favoriteCarsKey", defaultValue: []) }
}
