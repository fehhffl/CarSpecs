//
//  CarInfosViewController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 21/09/23.
//

import UIKit

class CarInfosViewController: UIViewController {
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var topSpeedInformationText: UILabel!
    @IBOutlet weak var zeroToOneHundredInformationText: UILabel!
    @IBOutlet weak var horsepowersInformationText: UILabel!
    @IBOutlet weak var descriptionText: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Car Information"
        configView()
    }
    func configView() {
        view1.layer.cornerRadius = 15
        view1.clipsToBounds = true
        view1.layer.borderWidth = 0
        view2.layer.cornerRadius = 15
        view2.clipsToBounds = true
        view2.layer.borderWidth = 0
        view3.layer.cornerRadius = 15
        view3.clipsToBounds = true
        view3.layer.borderWidth = 0
    }
}
