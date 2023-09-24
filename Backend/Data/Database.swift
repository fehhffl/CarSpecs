//
//  Database.swift
//  Backend
//
//  Created by Gabriel Carvalho on 23/09/23.
//

import Foundation

class Database {
    static let shared = Database()
    private(set) lazy var cars = JSONConverter.convertJSONToDictionary(fileName: "cars.json")
    private(set) lazy var carsSortedByYear = cars.randomizeAndSortByYear()

    func getCarsPreviews(page: Int, limit: Int) -> [[String: Any]] {
        let start = (page - 1) * limit
        var end = start + limit

        guard start < cars.count else {
            print("Max page reached")
            return []
        }
        if end > cars.count {
            end = cars.count
        }
        guard end > start else {
            print("Max page reached")
            return []
        }

        let cars = Array(carsSortedByYear[start..<end])

        return cars.map { dict -> [String: Any] in
            let images: [String] = (dict["images"] as? [String] ?? [])
            let firstImage: String = images.first { !$0.isEmpty } ?? ""
            return [
                "id": dict["id"] as Any,
                "name": dict["name"] as Any,
                "price": dict["price"] as Any,
                "image": firstImage,
                "year": dict["year"] as Any
            ]
        }
    }
}

extension Array where Element == Dictionary<String, Any> {
    func randomizeAndSortByYear() -> [[String: Any]]{
        // We shuffle the cars so we don't aways have in alphabetical order
        //in the home screen, but we use our FixedRandomNumberGenerator to
        // always randomize the array in the same way on every run
        var fixedRandomNumberGenerator = FixedRandomNumberGenerator()
        let randomizedArray = self.shuffled(/*using: &fixedRandomNumberGenerator*/)

        // Sort the cars by year
        let sortedCars = randomizedArray.sorted { next, previous in
            guard let previousCarYear = previous["year"] as? Int64,
                  let nextCarYear = next["year"] as? Int64 else {
                return false
            }
            return nextCarYear > previousCarYear
        }

        return sortedCars
    }
}
