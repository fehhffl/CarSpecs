//
//  HomeViewController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 09/08/23.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet private weak var newCarsLabel: UILabel!
    @IBOutlet private weak var exploreLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        exploreLabel.text = "explore_home_screen_label".localize()
        newCarsLabel.text = "new_cars_home_screen_label".localize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = "home_title_screen_label".localize()
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}
