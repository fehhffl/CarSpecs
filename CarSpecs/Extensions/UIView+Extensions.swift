//
//  UIView+Extensions.swift
//  CarSpecs
//
//  Created by Felipe Lima on 15/11/23.
//

import Foundation
import UIKit

extension UIView {
    func styleAsPillView() {
        layer.cornerRadius = frame.size.height / 2
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        clipsToBounds = true
        layer.masksToBounds = true
    }
}
