//
//  HomeViewController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 09/08/23.
//

import UIKit
import SwiftyUserDefaults

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet private weak var newCarsLabel: UILabel!
    @IBOutlet private weak var exploreCollectionView: UICollectionView!
    @IBOutlet private weak var exploreLabel: UILabel!
    @IBOutlet private weak var newCarsCollectionView: UICollectionView!
    @IBOutlet private weak var newCarsCollectionViewHeightConstraint: NSLayoutConstraint!
    private var exploreCards: [SquareCardItem] = []
    private let carRepository = CarRepository()
    private var cars: [Car] = []
    private let squareCardsRepository = SquareCardsRepository()

    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // To make the height of collection view to update when new cars appear
        // https://stackoverflow.com/questions/42437966/
        let height: CGFloat = self.newCarsCollectionView.collectionViewLayout.collectionViewContentSize.height
        newCarsCollectionViewHeightConstraint.constant = height
        newCarsCollectionView.layoutIfNeeded()
    }
    func getServerData() {
        showLoader()
        DispatchQueue.global(qos: .userInitiated).async {
            let url = URL(string: "https://www.cars-data.com/carList?page=1")
            URLSession.shared.dataTaskLocal(with: url!) { (data, urlResponse, error) in
                if let error = error {
                    self.showAlert(error.localizedDescription)
                    return
                }
                if let urlResponse = urlResponse as? HTTPURLResponse {
                    if urlResponse.statusCode != 200 {
                        let statusCode = urlResponse.statusCode
                        if (400..<500).contains(statusCode) {
                            self.showAlert("Not authorized")
                            return
                        } else if (500..<600).contains(statusCode) {
                            self.showAlert("Backend Error")
                            return
                        }
                    }
                }
                if let data = data {
                    do {
                        let decoderJson = try JSONDecoder().decode(CarsListResponse.self, from: data)
                        self.cars = decoderJson.cars
                        DispatchQueue.main.async {
                            self.hideLoader()
                            self.newCarsCollectionView.reloadData()
                        }
                    } catch {
                        print(error)
                        self.showAlert(error.localizedDescription)
                    }
                } else {
                    self.showAlert("No data")
                }
            }.resume()
        }
    }

    override func viewDidLoad() {
        exploreCards = squareCardsRepository.getCategoriesCar()
        // cars = carRepository.getAllCars()

        super.viewDidLoad()
        getServerData()
        exploreLabel.text = "explore_home_screen_label".localize()
        newCarsLabel.text = "new_cars_home_screen_label".localize()
        exploreCollectionView.register(UINib(nibName: "SquareCard", bundle: .main), forCellWithReuseIdentifier: "SquareCard")
        exploreCollectionView.delegate = self
        exploreCollectionView.dataSource = self
        newCarsCollectionView.register(UINib(nibName: "SquareCard", bundle: .main), forCellWithReuseIdentifier: "SquareCard")
        newCarsCollectionView.delegate = self
        newCarsCollectionView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = "Home"
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
            return CGSize(width: screenWidth / 2 - 15, height: 200 )
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SquareCard", for: indexPath) as? SquareCard else {
            return UICollectionViewCell()
        }
        if collectionView == exploreCollectionView {
            cell.configure(with: .style1, item: exploreCards[indexPath.row])
            return cell
        } else {
            let currentCar = cars[indexPath.row]
            let squareCardItem = SquareCardItem(
                title: currentCar.name,
                subtitle: currentCar.price.currencyUS,
                imageName: currentCar.imageName)

            cell.configure(with: .style2, item: squareCardItem, car: currentCar)

            return cell
        }
    }
}
