//
//  Database.swift
//  Backend
//
//  Created by Gabriel Carvalho on 23/09/23.
//

import Foundation

public class Database {
    public static let shared = Database()
    public lazy var cars = convertJSONToDictionary(fileName: "cars.json")

    private func convertJSONToDictionary(fileName: String) -> [[String: Any]] {
        guard let pathToJSON = Bundle.main.path(forResource: fileName.removeFileExtension, ofType: "json") else {
            print("Failed to find \(fileName)")
            return [[:]]
        }
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: pathToJSON), options: .mappedIfSafe)
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
            guard let jsonDict = jsonObject as? [String: Any] else {
                print("Failed to parse JSON Object to Dict")
                return [[:]]
            }
            guard let carsDictArray = jsonDict["cars"] as? [[String: Any]] else {
                print("Failed to obtain value for key 'cars' in dict:\n", jsonDict)
                return [[:]]
            }
            return carsDictArray
        } catch {
            print(error)
            return [[:]]
        }
    }
}

private extension String {
    var removeFileExtension: String {
        guard let indexOfDot = self.firstIndex(of: ".") else {
            return self
        }
        let lengthUntilReachDot = self.distance(from: self.startIndex, to: indexOfDot)
        let stringWithoutFileExtension = self.prefix(lengthUntilReachDot)
        return String(stringWithoutFileExtension)
    }
}
