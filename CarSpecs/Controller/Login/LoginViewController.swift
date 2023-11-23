//
//  LoginViewController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 03/08/23.
//

import UIKit
import SwiftyUserDefaults
import Security

class LoginViewController: UIViewController {
    @IBOutlet private weak var userTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet private weak var logInButton: UIButton!
    @IBOutlet weak var eyeButtonPassword: UIButton!
    let userRepository = UserRepository()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Sign In"
        navigationController?.navigationBar.prefersLargeTitles = true
        userTextField.text = ""
        passwordTextField.text = ""
    }
    @IBAction func onEyeButtonTapped(_ sender: Any) {
        if passwordTextField.isSecureTextEntry {
            eyeButtonPassword.setImage(UIImage(systemName: "eye"), for: .normal)
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordTextField.isSecureTextEntry = true
            eyeButtonPassword.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }
    @IBAction func onRegisterButtonTapped(_ sender: Any) {
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }

    @IBAction private func onLogInButtonTapped(_ sender: Any) {
        guard let typedPassword = passwordTextField.text,
              let user = userTextField.text else {
            return
        }
        userRepository.login(typedPassword: typedPassword, typedUser: user) { error in
            if error == nil {
                navigationController?.pushViewController(TabBarController(), animated: true)
                Defaults[\.email] = userTextField.text
            } else {
                showAlert("Invalid password or Email.")
            }
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
