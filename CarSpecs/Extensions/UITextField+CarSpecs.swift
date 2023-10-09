//
//  UITextFieldExtension.swift
//  CarSpecs
//
//  Created by Felipe Lima on 10/08/23.
//

import UIKit

extension UITextField {
    func styleAsPill() {
        layer.cornerRadius = frame.size.height / 2
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        clipsToBounds = true
    }
}
