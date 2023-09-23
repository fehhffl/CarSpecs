//
//  ViewController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 18/07/23.
//

import UIKit
import Backend

class WelcomeViewController: UIViewController {
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
        guard let url = URL(string: "https://www.cars-data.com/carList?page=1&limit=5") else {
            print("Invalid URL")
            return
        }
        API.shared.get(request: URLRequest(url: url)) { data, response, error in
            if let data = data {
                do {
                    let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    print(dict)
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print(data, response, error)
            }
        }
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
