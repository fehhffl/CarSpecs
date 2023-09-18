//
//  Car.swift
//  CarSpecs
//
//  Created by Felipe Lima on 12/09/23.
//

import SwiftyUserDefaults
import Foundation

struct Car: Codable, DefaultsSerializable {
    let name: String
    let price: Double
    let imageName: String
}
