//
//  RegisterViewController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 01/11/23.
//

import UIKit
import Security
import SwiftyUserDefaults

class RegisterViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var confirmEyeButton: UIButton!
    @IBOutlet weak var fullNameTextField: UITextField!
    var userRepository = UserRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
    }
    @IBAction func onConfirmEyeButtonTapped(_ sender: Any) {
        if confirmPasswordTextField.isSecureTextEntry {
            confirmEyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
            confirmPasswordTextField.isSecureTextEntry = false
        } else {
            confirmPasswordTextField.isSecureTextEntry = true
            confirmEyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }
    @IBAction func onEyeButtonTapped(_ sender: Any) {
        if passwordTextField.isSecureTextEntry {
            eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordTextField.isSecureTextEntry = true
            eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }

    @IBAction func onCreateAccountButtonTapped(_ sender: Any) {
        guard passwordTextField.text == confirmPasswordTextField.text else {
            showAlert("The password and the confirm password is different.")
            return
        }

        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let fullName = fullNameTextField.text else {
            print("username or password is nill")
            return
        }

        userRepository.registerUser(email: email, password: password, fullName: fullName) { error in
            if let error = error {
                switch error {
                case .alreadyCreated:
                    showAlert("Account already exists.")
                    return
                case .unexpectedError:
                    showAlert("Something went wrong. Please try again later")
                    return
                }
            }
            showLoginAlert("Your account has been created successfully.")
            navigationController?.pushViewController(LoginViewController(), animated: true)
        }
    }

    func showLoginAlert(_ message: String) {
        let alertController = UIAlertController(title: "Congratulations", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default)
        alertController.addAction(action)
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }

    func setupButtons() {
        emailTextField.styleAsPill()
        confirmPasswordTextField.styleAsPill()
        passwordTextField.styleAsPill()
        fullNameTextField.styleAsPill()
        createAccountButton.styleAsPill()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = "Sign up"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}
