//
//  UIImage+Extensions.swift
//  CarSpecs
//
//  Created by Felipe Lima on 01/11/23.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func setImageResized(with imageURL: URL?, placeholder: UIImage? = nil) {
        self.kf.setImage(
            with: imageURL,
            placeholder: placeholder,
            options: [
                .processor(DownsamplingImageProcessor(size: self.bounds.size)),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])
    }

    func setAspectRatio(_ horizontal: Int, _ vertical: Int) {
        self.heightAnchor.constraint(
            equalTo: self.widthAnchor,
            multiplier: Double(vertical)/Double(horizontal)
        ).isActive = true
    }
}
