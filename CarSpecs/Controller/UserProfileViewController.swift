//
//  UserProfileViewController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 15/11/23.
//

import UIKit

class UserProfileViewController: UIViewController {
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userLogOutView: UIView!


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserView()

    }
    func setupUserView() {
        userView.styleAsPillView()
        userLogOutView.styleAsPillView()
    }

}
