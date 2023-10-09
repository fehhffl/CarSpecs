//
//  Car.swift
//  CarSpecs
//
//  Created by Felipe Lima on 12/09/23.
//

import SwiftyUserDefaults
import Foundation

struct CarsListResponse: Codable {
    var cars: [Car]
}

struct Car: Codable, DefaultsSerializable {
    let name: String
    let price: Int
    let imageName: String
    let carId: Int

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case imageName = "image"
        case price = "price"
        case carId = "id"
    }
}
