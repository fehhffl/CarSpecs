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

    func getAllCars(completion: ([[String: Any]]) -> Void) {
        guard let url = URL(string: "https://www.cars-data.com/carList?page=1&limit=10") else {
            print("Invalid URL")
            completion([])
            return
        }
        API.shared.get(request: URLRequest(url: url)) { data, response, error in
            if let data = data {
                do {
                    let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let cars = dict?["cars"] as? [[String: Any]] {
                        completion(cars)
                    } else {
                        print("Could not obtain cars")
                        completion([])
                        return
                    }
                } catch {
                    print(error.localizedDescription)
                    completion([])
                    return
                }
            } else {
                if let data = data {
                    print(data)
                }
                if let response = response {
                    print(response)
                }
                if let error = error {
                    print(error)
                }
                completion([])
                return
            }
        }
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
