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
}

class TabBarController: UITabBarController {

    let arrayViewControllers: [UINavigationController] = [
        UINavigationController(rootViewController: HomeViewController()),
        UINavigationController(rootViewController: CategoriesViewController())
    ]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        arrayViewControllers[TabOption.home.rawValue].tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            tag: TabOption.home.rawValue
        )

        arrayViewControllers[TabOption.categories.rawValue].tabBarItem = UITabBarItem(
            title: "Categories",
            image: UIImage(systemName: "heart"),
            tag: TabOption.categories.rawValue
        )

        setViewControllers(arrayViewControllers, animated: true)
    }
}
