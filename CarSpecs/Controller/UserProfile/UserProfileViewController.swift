//
//  UserProfileViewController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 15/11/23.
//

import UIKit
import SwiftyUserDefaults

class UserProfileViewController: BaseViewController {
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userLogOutView: UIView!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var fullNameLabel: UILabel!
    weak var delegate: LogOutButtonDelegate?
    var userRepository = UserRepository()
    var email = Defaults[\.email]

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let emailNotNill = email else {
            return
        }
        let fullName = userRepository.getFullName(using: emailNotNill)
        setupUserView()
        fullNameLabel.text = fullName
    }
    @IBAction func onLogOutTapped(_ sender: Any) {
        delegate?.completeLogOut()
    }
    
    func setupUserView() {
        userView.styleAsPillView()
        userLogOutView.styleAsPillView()
    }

}
