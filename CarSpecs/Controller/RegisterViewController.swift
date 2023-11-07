//
//  RegisterViewController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 01/11/23.
//

import UIKit
import Foundation

class RegisterViewController: UIViewController {
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    let username = "Felipe"
    let password = "banana123a".data(using: .utf8)!
   
    
    enum KeyChainClass {
        case genericPassword
    }
    enum keyChainResult {
        case noError
        case error
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let atributes: Dictionary<String, Any> = [
            "class": KeyChainClass.genericPassword,
            "account": username,
            "password": password
        ]
        if savePasswordToKeyChain(atributes: atributes) == .noError {
            print("User Saved sucessfully in the keychain.")
        } else {
            print("Something went wrong trying to save the user in the keychain.")
        }
        setupButtons()
    }
    func savePasswordToKeyChain(atributes: Dictionary<String, Any>)-> keyChainResult{
        if (atributes["password"] != nil) {
            return .noError
        } else {
            return .error
        }
    }

    func setupButtons() {
        userTextField.styleAsPill()
        confirmPasswordTextField.styleAsPill()
        passwordTextField.styleAsPill()
        userNameTextField.styleAsPill()
        createAccountButton.styleAsPill()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = "Sign up"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}
