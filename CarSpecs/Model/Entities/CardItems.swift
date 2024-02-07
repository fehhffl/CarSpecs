//
//  CardItem.swift
//  CarSpecs
//
//  Created by Felipe Lima on 30/08/23.
//

class CardItem {
    let title: String
    let subtitle: String
    let imageName: String

    init(title: String, subtitle: String = "", imageName: String) {
        self.title = title
        self.subtitle = subtitle
        self.imageName = imageName
    }
}
