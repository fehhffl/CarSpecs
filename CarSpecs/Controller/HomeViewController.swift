//
//  HomeViewController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 09/08/23.
//

import UIKit
import SwiftyUserDefaults

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    @IBOutlet private weak var newCarsLabel: UILabel!
    @IBOutlet private weak var exploreCollectionView: UICollectionView!
    @IBOutlet private weak var exploreLabel: UILabel!
    @IBOutlet private weak var newCarsCollectionView: UICollectionView!
    @IBOutlet private weak var newCarsCollectionViewHeightConstraint: NSLayoutConstraint!
    private var exploreCards: [CardItem] = []
    private let carRepository = CarRepository()
    private var cars: [Car] = []
    private let squareCardsRepository = SquareCardsRepository()
    @IBOutlet weak var mainScrollView: UIScrollView!
    private var currentPage = 1
    private var exploreCarsIsLoading = false
    private var newCarsIsLoading = false
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
        newCarsIsLoading = true
        carRepository.getAllCars(pageNumber: currentPage) { [weak self] (carsArray: [Car]) -> Void in
            self?.cars += carsArray
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                strongSelf.newCarsCollectionView.reloadData()
                strongSelf.newCarsCollectionView.layoutIfNeeded()
                strongSelf.newCarsIsLoading = false
                if !strongSelf.exploreCarsIsLoading && !strongSelf.newCarsIsLoading {
                    strongSelf.hideLoader()
                }
            }
        }
    }
    override func viewDidLoad() {
        showLoader()
        exploreCarsIsLoading = true
        carRepository.getAllCategories { (categories: [String]) in
            var cardItems: [CardItem] = []
            var categoriesProcessed = 0
            for categoryName in categories {
                self.carRepository.getCarsFromCategory(pageNumber: 1, category: categoryName) { carsFromCategory in
                    let imageName = carsFromCategory.first?.imageName ?? "no-image"
                    let item = CardItem(title: categoryName.capitalized, imageName: imageName)
                    cardItems.append(item)
                    categoriesProcessed += 1
                    if categoriesProcessed == categories.count {
                        self.exploreCards = cardItems.sorted(by: { (next, prev) -> Bool in
                            if prev.title > next.title {
                                return true
                            } else {
                                return false
                            }
                        })
                        DispatchQueue.main.async {
                            self.exploreCollectionView.reloadData()
                            self.exploreCollectionView.layoutIfNeeded()
                            self.exploreCarsIsLoading = false
                            if !self.exploreCarsIsLoading && !self.newCarsIsLoading {
                                self.hideLoader()
                            }
                        }
                    }
                }
            }
        }
        super.viewDidLoad()
        mainScrollView.delegate = self
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
            let squareCardItem = CardItem(
                title: currentCar.name,
                subtitle: currentCar.price.currencyFR,
                imageName: currentCar.imageName)

            cell.configure(with: .style2, item: squareCardItem, car: currentCar)

            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == newCarsCollectionView {
            var id: Int = 0
            let currentCar = cars[indexPath.row]
            id = currentCar.carId
            navigationController?.pushViewController(CarInfosViewController(carId: id), animated: true)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == mainScrollView {
            // check if scrollview has reached the bottom
            let height = scrollView.frame.height
            let contentSizeHeight = scrollView.contentSize.height
            let offset = scrollView.contentOffset.y
            let reachedBottom = (offset > contentSizeHeight - height)
            if reachedBottom && !newCarsIsLoading {
                currentPage += 1
                getServerData()
            }
        }
    }
}
