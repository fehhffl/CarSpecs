//
//  LoginViewController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 03/08/23.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet private weak var userTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordErrorLabel: UILabel!
    @IBOutlet private weak var logInButton: UIButton!
    private let user = "fe.forioni@gmail.com"
    private let password = "Banana123"

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Sign In"
        navigationController?.navigationBar.prefersLargeTitles = true
        passwordErrorLabel.isHidden = true
        userTextField.text = user
        passwordTextField.text = password
    }

    @IBAction private func onLogInButtonTapped(_ sender: Any) {
        if userTextField.text == user,
           passwordTextField.text == password {
            passwordErrorLabel.isHidden = false
            passwordErrorLabel.text = "Success"
            passwordErrorLabel.textColor = .green
            navigationController?.pushViewController(TabBarController(), animated: true)
        } else {
            passwordErrorLabel.isHidden = false
            passwordErrorLabel.text = "Wrong password or email!"
            passwordErrorLabel.textColor = .red
        }
    }

    private func setupButtons() {
        logInButton.styleAsPill()
        passwordTextField.styleAsPill()
        userTextField.styleAsPill()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
    }

}
