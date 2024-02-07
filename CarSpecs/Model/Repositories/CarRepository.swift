//
//  CarRepository.swift
//  CarSpecs
//
//  Created by Felipe Lima on 12/09/23.
//

import Foundation
import SwiftyUserDefaults

protocol CarRepositoryDelegate {
    func updateCars(cars: [Car])
}

class CarRepository {
    var favorites: [Car] = []
    var cardItems: [CardItem]? = []
    var delegate: CarRepositoryDelegate?

     func removeFromFavorites(car: Car?) {
        Defaults[key: DefaultsKeys.favoriteCars].removeAll { (savedCar) -> Bool in
            if savedCar.name == car?.name {
                return true
            } else {
                return false
            }
        }
    }

     func addCarToFavorites(car: Car?) {
        if let carro = car {
            Defaults[key: DefaultsKeys.favoriteCars].append(carro)
        }
    }

    func callBackend(urlString: String, completion: @escaping (Data) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            guard let url = URL(string: encodedUrl ?? urlString)
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
                    DispatchQueue.main.async {
                        completion(data)
                    }
                } else {
                    print("No data")
                }
            }.resume()
        }
    }

    func getAllCategoriesNames(completion: @escaping ([String]) -> Void) {
        callBackend(urlString: "https://www.cars-data.com/categories") { (data) in
            do {
                let response = try JSONDecoder().decode(CarsCategoriesResponse.self, from: data)
                completion(response.categories)
            } catch {
                print(error)
            }
        }
    }

    func getAllCategories(completion: @escaping ([CardItem]) -> Void) {
        completion([
            CardItem(title: "Bus", imageName: "https://www.cars-data.com/pictures/thumbs/350px/mercedes-benz/mercedes-benz-eqv_4666_1.jpg"),
            CardItem(title: "Convertible", imageName: "https://www.cars-data.com/pictures/thumbs/350px/ferrari/ferrari-f8-spider_4601_1.jpg"),
            CardItem(title: "Coupé", imageName: "https://www.cars-data.com/pictures/thumbs/350px/ferrari/ferrari-812-gts_4600_1.jpg"),
            CardItem(title: "Double", imageName: "https://www.cars-data.com/pictures/thumbs/350px/mercedes-benz/mercedes-benz-sprinter-dubbele-cabine_4374_1.jpg"),
            CardItem(title: "Hatchback", imageName: "https://www.cars-data.com/pictures/thumbs/350px/audi/audi-rs5-sportback_4625_1.jpg"),
            CardItem(title: "Mpv", imageName: "https://www.cars-data.com/pictures/thumbs/350px/toyota/toyota-proace-city-verso_4635_1.jpg"),
            CardItem(title: "Pick-Up", imageName: "https://www.cars-data.com/pictures/thumbs/350px/mitsubishi/mitsubishi-l200-club-cab_4661_1.jpg"),
            CardItem(title: "Sedan", imageName: "https://www.cars-data.com/pictures/thumbs/350px/tesla/tesla-model-y_4615_1.jpg"),
            CardItem(title: "Station", imageName: "https://www.cars-data.com/pictures/thumbs/350px/volvo/volvo-v90-cross-country_4628_1.jpg"),
            CardItem(title: "Suv", imageName: "https://www.cars-data.com/pictures/thumbs/350px/toyota/toyota-c-hr_4596_1.jpg"),
            CardItem(title: "Van", imageName: "https://www.cars-data.com/pictures/thumbs/350px/mercedes-benz/mercedes-benz-esprinter_4672_1.jpg")
       ])
    }
    func getCarsForSearch(carName: String, pageNumber: Int, completion: @escaping ([Car]) -> Void) {
        let urlString: String = "https://www.cars-data.com/search?name=\(carName)&page=\(pageNumber)"
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

    func getCarsFromCategory(pageNumber: Int, category: String, completion: @escaping ([Car]) -> Void) {
       callBackend(urlString: "https://www.cars-data.com/carList?page=\(pageNumber)&limit=10&category=\(category)") { data in
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
                // self.delegate?.updateCars(cars: carsArray)
                completion(carsArray)
            } catch {
                print(error)
                print(error.localizedDescription)
            }
        }
    }
}
