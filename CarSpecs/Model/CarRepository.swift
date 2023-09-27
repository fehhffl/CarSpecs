//
//  CarRepository.swift
//  CarSpecs
//
//  Created by Felipe Lima on 12/09/23.
//

import Foundation

struct CarRepository {
    var favorites: [Car] = []
    private let cars: [Car] = [
//        Car(name: "Toyota Prius", price: 22959, imageName: "https://caredge.com/images/cars/photos/300_toyota-prius.jpg"),
//        Car(name: "Honda HR-V", price: 25322, imageName: "https://caredge.com/images/cars/photos/300_honda-hr-v.jpg"),
//        Car(name: "Subaru Crosstrek", price: 25672, imageName: "https://caredge.com/images/cars/photos/300_subaru-crosstrek.jpg"),
//        Car(name: "Toyota RAV4", price: 26095, imageName: "https://caredge.com/images/cars/photos/300_toyota-rav4.jpg"),
//        Car(name: "Honda CR-V", price: 26277, imageName: "https://images.drive.com.au/driveau/image/upload/c_fill,f_auto,g_auto,h_1080,q_auto:eco,w_1920/v1/cms/uploads/dtdosuwovnyzbwkozjkb"),
//        Car(name: "Jaguar XE", price: 28278, imageName: "https://cdn.boatinternational.com/convert/bi_prd/bi/library_images/IUWZRHoiSyqRsRg4K44j_jaguar-XE-P250-Caesium-Blue.jpg/r%5Bwidth%5D=1366/IUWZRHoiSyqRsRg4K44j_jaguar-XE-P250-Caesium-Blue.webp"),
//        Car(name: "Toyota Camry", price: 26810, imageName: "https://caredge.com/images/cars/photos/300_toyota-camry.jpg"),
//        Car(name: "Subaru Forester", price: 27440, imageName: "https://caredge.com/images/cars/photos/300_subaru-forester.jpg"),
//        Car(name: "Subaru Legacy", price: 27769, imageName: "https://caredge.com/images/cars/photos/300_subaru-legacy.jpg"),
//        Car(name: "Honda Accord", price: 27880, imageName: "https://caredge.com/images/cars/photos/300_honda-accord.jpg")
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
