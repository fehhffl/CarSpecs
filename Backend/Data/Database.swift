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
        let carsSortedByYear = self.carsSortedByYear
        guard let (start, end) = getCarArrayStartEnd(page, limit, carsSortedByYear) else {
            return []
        }
        let cars = Array(carsSortedByYear[start..<end])
        return cars.asCarSummaries()
    }

    func getCarsInCategory(category: String, page: Int, limit: Int) -> [[String: Any]] {

        let filteredCars = carsSortedByYear.filter { car in
            guard let carCategory = car["type"] as? String else {
                return false
            }
            return carCategory == category
        }

        guard let (start, end) = getCarArrayStartEnd(page, limit, filteredCars) else {
            return []
        }

        let cars = Array(filteredCars[start..<end])

        return cars.asCarSummaries()
    }

    func getCarDetails(id: Int) -> [String: Any]? {
        return cars.first { car in
            guard let carId = car["id"] as? Int64 else {
                print("Car \(car["name"] as? String ?? "") doesn't have an id")
                return false
            }
            return carId == id
        }
    }

    func getCarsBy(name searchedName: String, page: Int, limit: Int) -> [[String: Any]] {
        let searchedName = (searchedName.removingPercentEncoding ?? searchedName)
                            .lowercased()
                            .trimmingCharacters(in: .whitespaces)
    
        guard !searchedName.isEmpty else {
            print("Car name is empty")
            return []
        }

        var filteredCars = cars.filter { car in
            guard var carName = car["name"] as? String else {
                return false
            }
            carName = carName.lowercased()
            return carName.contains(searchedName)
        }

        filteredCars = filteredCars.sorted(by: { next, previous in
            guard var previousCarName = previous["name"] as? String,
                  var nextCarName = next["name"] as? String else {
                return false
            }
            previousCarName = previousCarName.lowercased()
            nextCarName = nextCarName.lowercased()

            let nextCarPriority = nextCarName.starts(with: searchedName) ? 1 : 0
            let previousCarPriority = previousCarName.starts(with: searchedName) ? 1 : 0
            return nextCarPriority > previousCarPriority
        })

        guard let (start, end) = getCarArrayStartEnd(page, limit, filteredCars) else {
            return []
        }

        let cars = Array(filteredCars[start..<end])

        return cars.asCarSummaries()
    }

    func getAllCategories() -> [String] {
        return cars.compactMap { $0["type"] as? String }.removeDuplicates()
    }

    private func getCarArrayStartEnd(_ page: Int, _ limit: Int, _ carsArray: [[String: Any]]) -> (Int, Int)? {
        let start = (page - 1) * limit
        var end = start + limit

        guard start < carsArray.count else {
            print("Max page reached")
            return nil
        }
        if end > carsArray.count {
            end = carsArray.count
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
        let randomizedArray = self.shuffled(using: &fixedRandomNumberGenerator)

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
