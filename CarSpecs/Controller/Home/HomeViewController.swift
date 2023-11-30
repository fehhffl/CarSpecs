//
//  HomeViewController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 09/08/23.
//

import SwiftyUserDefaults
import UIKit

protocol UserIconButtonDelegate: AnyObject {
    func navigateToUserPage()
}
protocol LogOutButtonDelegate: AnyObject {
    func completeLogOut()
}

class HomeViewController: BaseViewController, UserIconButtonDelegate, CarRepositoryDelegate, LogOutButtonDelegate {
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet private weak var newCarsLabel: UILabel!
    @IBOutlet private weak var exploreCollectionView: UICollectionView!
    @IBOutlet private weak var exploreLabel: UILabel!
    @IBOutlet private weak var newCarsCollectionView: UICollectionView!
    @IBOutlet private weak var newCarsCollectionViewHeightConstraint: NSLayoutConstraint!
    private let userIconButton = UserIconButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    private let lastItemLoadingView = LastItemLoadingView()

    private var exploreCards: [CardItem] = []
    private let carRepository = CarRepository()
    private var cars: [Car] = []

    private var currentPage = 1
    private var exploreCarsIsLoading = false
    private var newCarsIsLoading = false {
        didSet {
            lastItemLoadingView.isHidden = !newCarsIsLoading
            if newCarsIsLoading {
                lastItemLoadingView.play()
            } else {
                lastItemLoadingView.stop()
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateNewCarsCollectionViewHeight()
    }

    private func updateNewCarsCollectionViewHeight() {
        // To make the height of collection view to update when new cars appear
        // https://stackoverflow.com/questions/42437966/
        let height: CGFloat = self.newCarsCollectionView.collectionViewLayout.collectionViewContentSize.height
        newCarsCollectionViewHeightConstraint.constant = height
        newCarsCollectionView.layoutIfNeeded()
    }

    func getServerData() {
        newCarsIsLoading = true
        newCarsCollectionView.reloadData()
        carRepository.getAllCars(pageNumber: currentPage, completion: updateCars)
    }

    func completeLogOut() {
        Defaults[\.email] = nil
        UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: WelcomeViewController())
    }

    func updateCars(cars: [Car]) {
        self.cars += cars
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.newCarsIsLoading = false
            self.newCarsCollectionView.reloadData()
            self.newCarsCollectionView.layoutIfNeeded()
            self.updateNewCarsCollectionViewHeight()
            if !self.exploreCarsIsLoading && !self.newCarsIsLoading {
                self.hideLoader()
            }
        }
    }

    override func viewDidLoad() {
        showLoader()
        exploreCarsIsLoading = true
        carRepository.delegate = self
        carRepository.getAllCategories { [weak self] cardItems in
            guard let self = self else { return }
            self.exploreCards = cardItems
            DispatchQueue.main.async {
                self.exploreCollectionView.reloadData()
                self.exploreCollectionView.layoutIfNeeded()
                self.exploreCarsIsLoading = false
                if !self.exploreCarsIsLoading && !self.newCarsIsLoading {
                    self.hideLoader()
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
        userIconButton.delegate = self
        mainStackView.addArrangedSubview(lastItemLoadingView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        showLoader()
        title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: userIconButton)
        lastItemLoadingView.isHidden = true
        newCarsCollectionView.reloadData()
    }

    func navigateToUserPage() {
        let viewController = UserProfileViewController()
        viewController.delegate = self
        viewController.view.backgroundColor = .white
        viewController.modalPresentationStyle = .formSheet
        navigationController?.present(viewController, animated: true, completion: nil)
    }
}
extension HomeViewController: UIScrollViewDelegate {
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
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        switch collectionView {
        case exploreCollectionView:
            let category = exploreCards[indexPath.row].title
            navigationController?.pushViewController(CategoryListViewController(category: category), animated: true)

        case newCarsCollectionView:
            let currentCar = cars[indexPath.row]
            navigationController?.pushViewController(CarInfosViewController(carId: currentCar.carId), animated: true)

        default:
            break
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SquareCard", for: indexPath) as? SquareCard else {
            return UICollectionViewCell()
        }

        switch collectionView {
        case exploreCollectionView:
            cell.configure(with: .style1, item: exploreCards[indexPath.row])

        case newCarsCollectionView:
            let currentCar = cars[indexPath.item]
            let squareCardItem = CardItem(
                title: currentCar.name,
                subtitle: currentCar.price.currencyFR,
                imageName: currentCar.imageName)
            cell.configure(with: .style2, item: squareCardItem, car: currentCar)

        default:
            break
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        switch collectionView {
        case exploreCollectionView:
            return CGSize(width: 128, height: 128)

        case newCarsCollectionView:
            let itemsPerLine = 2
            let spaceBetweenElements = 12
            let marginSpacing = 12

            let emptySpaces = ((itemsPerLine - 1) * spaceBetweenElements) + (2 * marginSpacing)
            let itemWidth = (screenWidth - emptySpaces) / itemsPerLine

            return CGSize(width: itemWidth, height: 200)

        default:
            return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case exploreCollectionView:
            return exploreCards.count
        case newCarsCollectionView:
            return cars.count
        default:
            return 0
        }
    }
}
