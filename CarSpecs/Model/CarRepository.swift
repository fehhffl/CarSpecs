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
        return httpClient.get(path: "carList?page=1&limit=10", rootKey: "cars", completion: completion)
    }

    func getCarDetails(id: Int, completion: ([String: Any]?) -> Void) {
        return httpClient.get(path: "details/\(id)", completion: completion)
    }

    func searchCarBy(name carName: String, completion: ([[String: Any]]) -> Void) {
        return httpClient.get(path: "search?name=\(carName)&page=1&limit=10", rootKey: "cars", completion: completion)
    }
}
