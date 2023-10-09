//
//  CarTechnicalInformation.swift
//  CarSpecs
//
//  Created by Felipe Lima on 06/10/23.
//

import Foundation

struct CarTechnicalInformation: Codable {
    var name: String
    var price: Int
    var year: Int
    var description: String
    var type: String
    var performance: Perfomance
    var drive: Drive
    var transmission: String
    var images: [String]
}

struct Perfomance: Codable {
    var topSpeed: Int
    var acceleration: Double
}

struct Drive: Codable {
    enum CodingKeys: String, CodingKey {
        case engineType
        case fuelType
        case horsePower = "power"
    }
    var engineType: String
    var fuelType: String
    var horsePower: Int
}
