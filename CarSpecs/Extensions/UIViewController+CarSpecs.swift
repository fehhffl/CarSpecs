//
//  File.swift
//  CarSpecs
//
//  Created by Felipe Lima on 24/09/23.
//

import Foundation
import UIKit
import SnapKit

extension UIViewController {

    // Singleton
    func showLoader() {
        let loadingViewSingleton = LoadingView.shared
        DispatchQueue.main.async {
            self.view.addSubview(loadingViewSingleton)
            loadingViewSingleton.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }

    func hideLoader() {
        let loadingViewSingleton = LoadingView.shared
        DispatchQueue.main.async {
            loadingViewSingleton.removeFromSuperview()
        }
    }

    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default)
        alertController.addAction(action)
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }

}
