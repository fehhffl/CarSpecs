//
//  LoginViewController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 03/08/23.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var logInButton: UIButton!
    let user = "fe.forioni@gmail.com"
    let password = "Banana123"
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Sign In"
        navigationController?.navigationBar.prefersLargeTitles = true
        passwordErrorLabel.isHidden = true

    }

    @IBAction func onLogInButtonTapped(_ sender: Any) {
        if userTextField.text == user,
           passwordTextField.text == password {
            passwordErrorLabel.isHidden = false
            passwordErrorLabel.text = "Success"
            passwordErrorLabel.textColor = .green
            navigationController?.pushViewController(HomeViewController(), animated: true)
        } else {
            passwordErrorLabel.isHidden = false
            passwordErrorLabel.text = "Wrong password or email!"
            passwordErrorLabel.textColor = .red

        }
    }
        func setupButtons() {
            logInButton.layer.cornerRadius = logInButton.frame.size.height/2
            passwordTextField.layer.cornerRadius = passwordTextField.frame.size.height/2
            passwordTextField.layer.borderWidth = 1
            passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
            passwordTextField.clipsToBounds = true
            userTextField.layer.cornerRadius = userTextField.frame.size.height/2
            userTextField.layer.borderWidth = 1
            userTextField.layer.borderColor = UIColor.lightGray.cgColor
            userTextField.clipsToBounds = true
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
    }

}
