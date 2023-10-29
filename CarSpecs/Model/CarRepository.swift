//
//  CarRepository.swift
//  CarSpecs
//
//  Created by Felipe Lima on 12/09/23.
//

import Foundation

struct CarRepository {
    var favorites: [Car] = []

    func callBackend(urlString: String, completion: @escaping (Data) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let url = URL(string: urlString)
            else {
                print("Invalid url")
                return
            }

            URLSession.shared.dataTaskLocal(with: url) { (data, urlResponse, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                if let urlResponse = urlResponse as? HTTPURLResponse {
                    if urlResponse.statusCode != 200 {
                        let statusCode = urlResponse.statusCode
                        if (400..<500).contains(statusCode) {
                            print("Not authorized")
                            return
                        } else if (500..<600).contains(statusCode) {
                            print("Backend Error")
                            return
                        }
                    }
                }
                if let data = data {
                    completion(data)
                } else {
                    print("No data")
                }
            }.resume()
        }
    }

    func getAllCategories(completion: @escaping ([String]) -> Void) {
        callBackend(urlString: "https://www.cars-data.com/categories") { (data) in
            do {
                let response = try JSONDecoder().decode(CarsCategoriesResponse.self, from: data)
                completion(response.categories)
            } catch {
                print(error)
            }
        }
    }

    func getCategorysCars(pageNumber: Int, category: String, completion: @escaping ([Car]) -> Void) {
        let urlEncodedCategory = category.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let urlString: String = "https://www.cars-data.com/carList?page=\(pageNumber)&limit=10&category=\(urlEncodedCategory ?? category)"
       callBackend(urlString: urlString) { data in
            do {
                let decodedJson = try JSONDecoder().decode(CarsListResponse.self, from: data)
                let carsArray = decodedJson.cars
                completion(carsArray)
            } catch {
                print(error)
            }
        }
    }

    func getTechnicalInformation(carId: Int, completion: @escaping (CarTechnicalInformation) -> Void) {
        callBackend(urlString: "https://www.cars-data.com/details/\(carId)") { data in
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let information = try decoder.decode(CarTechnicalInformation.self, from: data)
                completion(information)
            } catch {
                print(error)
            }
        }
    }

    func getAllCars(pageNumber: Int, completion: @escaping ([Car]) -> Void) {
        callBackend(urlString: "https://www.cars-data.com/carList?page=\(pageNumber)") { data in
            do {
                let decoderJson = try JSONDecoder().decode(CarsListResponse.self, from: data)
                let carsArray = decoderJson.cars
                completion(carsArray)
            } catch {
                print(error)
                print(error.localizedDescription)
            }
        }
    }
}
