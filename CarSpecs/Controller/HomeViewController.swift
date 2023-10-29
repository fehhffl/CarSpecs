//
//  HomeViewController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 09/08/23.
//

import UIKit
import SwiftyUserDefaults

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet private weak var collectionView: UICollectionView!
    private var exploreCards: [CardItem] = []
    private let carRepository = CarRepository()
    private var cars: [Car] = []
    private let squareCardsRepository = SquareCardsRepository()
    var pageNumber: Int = 1

    private enum Section: Int, CaseIterable {
        case exploreCars = 0
        case newCars = 1
    }

    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }

    func atualizaListaCarros(arrayDoRepositorio: [Car]) {
        self.cars += arrayDoRepositorio
        DispatchQueue.main.async {
            self.hideLoader()
            self.collectionView.reloadData()
        }
    }

    func getServerData() {
        showLoader()
        carRepository.getAllCars(pageNumber: pageNumber, completion: atualizaListaCarros)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        carRepository.getAllCategories(completion: completionGetCategories)
        getServerData()
        // exploreLabel.text = "explore_home_screen_label".localize()
        // newCarsLabel.text = "new_cars_home_screen_label".localize()
        collectionView.register(UINib(nibName: "SquareCard", bundle: .main), forCellWithReuseIdentifier: "SquareCard")
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case Section.exploreCars.rawValue:
            return exploreCards.count
        case Section.newCars.rawValue:
            return cars.count
        default:
            return 0
        }
    }

    func completionGetCategories(allCategories: [String]) {
        var squareCards: [CardItem] = []
        for categoryName in allCategories {
            let cardItem = squareCardsRepository.convertCategoryToSquareCard(using: categoryName)
            squareCards.append(cardItem)
        }
        exploreCards = squareCards
        DispatchQueue.main.sync {
            collectionView.reloadData()
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch Section(rawValue: indexPath.section) {
        case .exploreCars:
            return CGSize(width: 128, height: 128)
        case .newCars:
            return CGSize(width: screenWidth / 2 - 15, height: 200 )
        case .none:
            return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SquareCard", for: indexPath) as? SquareCard else {
            return UICollectionViewCell()
        }
        switch Section(rawValue: indexPath.section) {
        case .exploreCars:
            cell.configure(with: .style1, item: exploreCards[indexPath.row])
            return cell
        case .newCars:

            let currentCar = cars[indexPath.row]
            let squareCardItem = CardItem(
                title: currentCar.name,
                subtitle: currentCar.price.currencyFR,
                imageName: currentCar.imageName)

            cell.configure(with: .style2, item: squareCardItem, car: currentCar)

            return cell
        case .none:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section) {
        case .exploreCars:
            break
        case .newCars:
            var id: Int = 0
            let currentCar = cars[indexPath.row]
            id = currentCar.carId
            navigationController?.pushViewController(CarInfosViewController(carId: id), animated: true)
        case .none:
            break
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            break
        case 1:
            loadMoreCarsIfLast(currentItemIndex: indexPath.item)
        default:
            break
        }
    }

    func loadMoreCarsIfLast(currentItemIndex: Int) {
        let indiceItemAtual = currentItemIndex
        let indiceUltimaPosicao = cars.count - 1

        if indiceItemAtual == indiceUltimaPosicao {
            pageNumber += 1
            getServerData()
        }
    }
}
