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

    func getCarsSummaries(page: Int, limit: Int) -> [[String: Any]] {
        guard let (start, end) = getCarArrayStartEnd(page, limit) else {
            return []
        }
        let cars = Array(carsSortedByYear[start..<end])
        return cars.asCarSummaries()
    }

    func getCarsInCategory(category: String, page: Int, limit: Int) -> [[String: Any]] {
        guard let (start, end) = getCarArrayStartEnd(page, limit) else {
            return []
        }
        let filteredCars = cars.filter { car in
            guard let carCategory = car["type"] as? String else {
                return false
            }
            return carCategory == category
        }

        let cars = Array(filteredCars[start..<end])

        return cars.asCarSummaries()
    }

    func getAllCategories() -> [String] {
        return cars.compactMap { $0["type"] as? String }.removeDuplicates()
    }

    private func getCarArrayStartEnd(_ page: Int, _ limit: Int) -> (Int, Int)? {
        let start = (page - 1) * limit
        var end = start + limit

        guard start < cars.count else {
            print("Max page reached")
            return nil
        }
        if end > cars.count {
            end = cars.count
        }
        guard end > start else {
            print("Max page reached")
            return nil
        }
        return (start, end)
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

    func asCarSummaries() -> [[String: Any]] {
        return self.map { $0.asCarSummary() }
    }
}


extension Dictionary where Key == String {
    func asCarSummary() -> [String: Any] {
        let images: [String] = (self["images"] as? [String] ?? [])
        let firstImage: String = images.first { !$0.isEmpty } ?? ""
        return [
            "id": self["id"] as Any,
            "name": self["name"] as Any,
            "price": self["price"] as Any,
            "image": firstImage,
            "year": self["year"] as Any
        ]
    }
}

extension Array where Element == String {
    func removeDuplicates() -> [String] {
        return Array(Set(self))
    }
}
