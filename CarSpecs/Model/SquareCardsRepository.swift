//
//  CarRepository.swift
//  CarSpecs
//
//  Created by Felipe Lima on 06/09/23.
//

import Foundation
struct SquareCardsRepository {
    private let carRepository = CarRepository()

    func getCategoriesCar() -> [SquareCardItem] {
        return [
                SquareCardItem(title: "Eletric", imageName: "mercedes-benz-vision-eqs"),
                SquareCardItem(title: "New Cars", imageName: "vw_gti"),
                SquareCardItem(title: "Luxury", imageName: "morgan-aero 8"),
                SquareCardItem(title: "Hybrid", imageName: "bmw-i3"),
                SquareCardItem(title: "Trucks", imageName: "dodge-ram")
        ]
    }
}
