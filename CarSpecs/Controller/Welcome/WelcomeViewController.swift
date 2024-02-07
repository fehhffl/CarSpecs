//
//  ViewController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 18/07/23.
//

import UIKit

class WelcomeViewController: BaseViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    func setUpViews() {
        loginButton.layer.cornerRadius = loginButton.frame.size.height/2
        subtitleLabel.text = "first_screen_message".localize()
        titleLabel.text = "first_screen_message_welcome".localize()
        loginButton.setTitle("first_screen_message_log_in".localize(), for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }

    @IBAction func onLoginButtonTapped(_ sender: Any) {
        navigationController?.pushViewController(LoginViewController(), animated: true)
    }

}

extension String {
    func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
