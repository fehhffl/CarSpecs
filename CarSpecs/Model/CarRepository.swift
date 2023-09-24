//
//  CarRepository.swift
//  CarSpecs
//
//  Created by Felipe Lima on 12/09/23.
//

import Backend
import Foundation

struct CarRepository {
    var favorites: [Car] = []
    private let httpClient = HttpClient()

    func getAllCategories(completion: ([String]) -> Void) {
        return httpClient.get(path: "categories", rootKey: "categories", completion: completion)
    }

    func getAllCars(completion: ([[String: Any]]) -> Void) {
        return httpClient.get(path: "carList?page=1&limit=10&category=suv", rootKey: "cars", completion: completion)
    }

    func searchCar(nameToSearch: String) -> Car? {
//        for car in cars {
//            if car.name == nameToSearch {
//                return car
//            }
//        }
        return nil
    }
}
