//
//  HomeViewController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 09/08/23.
//

import UIKit

class HomeViewController: UIViewController,
                          UICollectionViewDelegate,
                          UICollectionViewDataSource,
                          UICollectionViewDelegateFlowLayout {
    @IBOutlet private weak var newCarsLabel: UILabel!
    @IBOutlet private weak var exploreCollectionView: UICollectionView!
    @IBOutlet private weak var exploreLabel: UILabel!
    @IBOutlet private weak var newCarsCollectionView: UICollectionView!
    private var exploreCards: [SquareCardItem] = []
    private var newCarCards: [SquareCardItem] = []
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    override func viewDidLoad() {
        exploreCards = [
            SquareCardItem(title: "Eletric", imageName: "tesla-model-x"),
            SquareCardItem(title: "New Cars", imageName: "morgan-aero 8"),
            SquareCardItem(title: "Luxury", imageName: "morgan-aero 8"),
            SquareCardItem(title: "Hybrid", imageName: "bmw-i3"),
            SquareCardItem(title: "Trucks", imageName: "dodge-ram")
        ]

        newCarCards = [
            SquareCardItem(title: "New Cars", subtitle: "Used Audi A4 1.8T 2015", imageName: "tesla-model-x"),
            SquareCardItem(title: "New Cars", subtitle: "Used Audi A4 1.8T 2015", imageName: "tesla-model-x"),
            SquareCardItem(title: "New Cars", subtitle: "Used Audi A4 1.8T 2015", imageName: "tesla-model-x"),
            SquareCardItem(title: "New Cars", subtitle: "Used Audi A4 1.8T 2015", imageName: "tesla-model-x"),
            SquareCardItem(title: "New Cars", subtitle: "Used Audi A4 1.8T 2015", imageName: "tesla-model-x")
        ]

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
        title = "home_title_screen_label".localize()
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == exploreCollectionView {
            return exploreCards.count
        } else {
            return newCarCards.count
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
            cell.configure(with: .style2, item: newCarCards[indexPath.row])
            return cell
        }
    }
}
