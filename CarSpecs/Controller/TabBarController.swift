//
//  TabBarController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 05/09/23.
//

import UIKit

enum TabOption: Int {
    case home
    case categories
    case garage
}

class TabBarController: UITabBarController {

    let arrayViewControllers: [UINavigationController] = [
        UINavigationController(rootViewController: HomeViewController()),
        UINavigationController(rootViewController: CategoriesViewController()),
        UINavigationController(rootViewController: GarageViewController())
    ]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        arrayViewControllers[TabOption.garage.rawValue].tabBarItem = UITabBarItem(
        title: "Garage",
        image: UIImage(systemName: "heart"),
        tag: TabOption.garage.rawValue
        )

        arrayViewControllers[TabOption.home.rawValue].tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            tag: TabOption.home.rawValue
        )

        arrayViewControllers[TabOption.categories.rawValue].tabBarItem = UITabBarItem(
            title: "Categories",
            image: UIImage(systemName: "list.bullet.indent"),
            tag: TabOption.categories.rawValue
        )

        setViewControllers(arrayViewControllers, animated: true)
    }
}
