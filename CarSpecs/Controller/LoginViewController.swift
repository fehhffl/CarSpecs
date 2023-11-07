//
//  LoginViewController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 03/08/23.
//

import UIKit
import SwiftyUserDefaults

class LoginViewController: UIViewController {
    @IBOutlet private weak var userTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet private weak var logInButton: UIButton!
    private let user = "Felipe"
    private let password = "Banana123"

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Sign In"
        navigationController?.navigationBar.prefersLargeTitles = true
        userTextField.text = user
        passwordTextField.text = password
    }

    @IBAction func onRegisterButtonTapped(_ sender: Any) {
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }

    @IBAction private func onLogInButtonTapped(_ sender: Any) {
        if userTextField.text == user,
           passwordTextField.text == password {
            navigationController?.pushViewController(TabBarController(), animated: true)
            Defaults[\.username] = userTextField.text
        } else {
            showAlert("Invalid password or Email.")
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
