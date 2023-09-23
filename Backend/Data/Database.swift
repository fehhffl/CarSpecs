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

    func getCarsPreviews(page: Int, limit: Int) -> [[String: Any]] {
        let start = (page - 1) * limit
        let end = start + limit
        return Array(cars[start..<end])
    }
}
