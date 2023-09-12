//
//  CarRepository.swift
//  CarSpecs
//
//  Created by Felipe Lima on 12/09/23.
//

import Foundation

struct CarRepository {
    private let cars = [
        Car(name: "Toyota Prius", price: 22959, imageName: "https://caredge.com/images/cars/photos/300_toyota-prius.jpg"),
        Car(name: "Honda HR-V", price: 25322, imageName: "https://caredge.com/images/cars/photos/300_honda-hr-v.jpg"),
        Car(name: "Subaru Crosstrek", price: 25672, imageName: "https://caredge.com/images/cars/photos/300_subaru-crosstrek.jpg"),
        Car(name: "Toyota RAV4", price: 26095, imageName: "https://caredge.com/images/cars/photos/300_toyota-rav4.jpg"),
        Car(name: "Honda CR-V", price: 26277, imageName: "https://caredge.com/images/cars/photos/300_toyota-camry.jpg"),
        Car(name: "Mazda CX-5", price: 28278, imageName: "https://caredge.com/images/cars/photos/300_toyota-camry.jpg"),
        Car(name: "Toyota Camry", price: 26810, imageName: "https://caredge.com/images/cars/photos/300_toyota-camry.jpg"),
        Car(name: "Subaru Forester", price: 27440, imageName: "https://caredge.com/images/cars/photos/300_subaru-forester.jpg"),
        Car(name: "Subaru Legacy", price: 27769, imageName: "https://caredge.com/images/cars/photos/300_subaru-legacy.jpg"),
        Car(name: "Honda Accord", price: 27880, imageName: "https://caredge.com/images/cars/photos/300_honda-accord.jpg")
    ]

    func getAllCars() -> [Car] {
        return cars
    }

    func searchCar(nameToSearch: String) -> Car? {
        for car in cars {
            if car.name == nameToSearch {
                return car
            }
        }
        return nil
    }
}
