//
//  CarRepository.swift
//  CarSpecs
//
//  Created by Felipe Lima on 12/09/23.
//

import Foundation

struct CarRepository {
    var favorites: [Car] = []
    func getCategorysCars(pageNumber: Int, category: String, completion: @escaping ([Car]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let urlEncodedCategory = category.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let urlString: String = "https://www.cars-data.com/carList?page=\(pageNumber)&limit=10&category=\(urlEncodedCategory ?? category)"

            guard let url = URL(string: urlString)
            else {
                print("Invalid url")
                return
            }

            let task = URLSession.shared.dataTaskLocal(with: url) { (data, urlResponse, error) in
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
                    do {
                        let decoderJson = try JSONDecoder().decode(CarsListResponse.self, from: data)
                        let carsArray = decoderJson.cars
                        completion(carsArray)
                    }catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }

    func getTechnicalInformation(carId: Int, completion: @escaping (CarTechnicalInformation) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let url = URL(string: "https://www.cars-data.com/details/\(carId)")
            let task = URLSession.shared.dataTaskLocal(with: url!) { (data, urlResponse, error) in
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
            task.resume()
        }
    }

    func getAllCars(pageNumber: Int, completion: @escaping ([Car]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let url = URL(string: "https://www.cars-data.com/carList?page=\(pageNumber)")
            URLSession.shared.dataTaskLocal(with: url!) { (data, urlResponse, error) in
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
                    do {
                        let decoderJson = try JSONDecoder().decode(CarsListResponse.self, from: data)
                        let carsArray = decoderJson.cars
                        completion(carsArray)
                    } catch {
                        print(error)
                        print(error.localizedDescription)
                    }
                } else {
                    print("No data")
                }
            }.resume()
        }
    }

}
