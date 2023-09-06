//
//  TabBarController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 05/09/23.
//

import UIKit

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
        arrayViewControllers[0].tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
    arrayViewControllers[1].tabBarItem = UITabBarItem(title: "Categories", image: UIImage(systemName: "heart"), tag: 1)
        setViewControllers(arrayViewControllers, animated: true)
    }
}
