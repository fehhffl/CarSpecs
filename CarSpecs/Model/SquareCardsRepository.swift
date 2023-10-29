//
//  CarRepository.swift
//  CarSpecs
//
//  Created by Felipe Lima on 06/09/23.
//

import Foundation
struct SquareCardsRepository {
    private let carRepository = CarRepository()

    func convertCategoryToSquareCard(using categoryName: String) -> CardItem {
        var imageName = ""
        switch categoryName {
        case "suv":
            imageName = "suv"
        case "coupé":
            imageName = "bmw_m440i"
        case "sedan":
            imageName = "tesla-model-x"
        case "hatchback":
            imageName = "vw_gti"
        case "van":
            imageName = "van"
        case "pick-up":
            imageName = "dodge-ram"
        case "convertible":
            imageName = "morgan-aero 8"
        default:
            print("Unknown category name:", categoryName)
        }
        return CardItem(title: categoryName, imageName: imageName)
    }
}
