//
//  SquareCardConfig.swift
//  CarSpecs
//
//  Created by Felipe Lima on 28/08/23.
//

import Foundation

class SquareCardItem {
    let title: String
    let subtitle: String
    let imageName: String

    init(title: String, subtitle: String = "", imageName: String) {
        self.title = title
        self.subtitle = subtitle
        self.imageName = imageName
    }
}
