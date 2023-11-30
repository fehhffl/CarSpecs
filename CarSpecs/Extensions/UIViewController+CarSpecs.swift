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

    var screenWidth: Int {
        return Int(UIScreen.main.bounds.width)
    }
    var screenHeight: Int {
        return Int(UIScreen.main.bounds.height)
    }

   

    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default)
        alertController.addAction(action)
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }

    func allLabelsInThisScreen() -> [UILabel] {
        var allLabels: [UILabel] = []
        findLabelsInSubviews(self.view.subviews, labelsArray: &allLabels)
        return allLabels
    }

    func findLabelsInSubviews(_ subviews: [UIView], labelsArray: inout [UILabel]) {
        for view in subviews {
            if let label = view as? UILabel {
                labelsArray.append(label)
            } else {
                findLabelsInSubviews(view.subviews, labelsArray: &labelsArray)
            }
        }
    }
}
