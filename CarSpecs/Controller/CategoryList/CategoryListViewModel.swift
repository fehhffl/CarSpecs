//
//  CategoryListViewModel.swift
//  CarSpecs
//
//  Created by Felipe Lima on 29/11/23.
//

import Foundation

class CategoryListViewModel {

    var carRepository = CarRepository()
    var cars: [Car] = []
    var pageNumber: Int = 1
    var category: String
    
    init(category: String) {
        self.category = category
    }

    func getCarsFromCategory(viewControllerCompletion: @escaping([Car]) -> Void) {
        carRepository.getCarsFromCategory(pageNumber: pageNumber, category: category, completion: { carsArray in
            self.cars += carsArray
            viewControllerCompletion(carsArray)
        })
    }
    
    func loadNextPage(viewControllerCompletion: @escaping([Car]) -> Void) {
        pageNumber += 1
        carRepository.getCarsFromCategory(pageNumber: pageNumber, category: category, completion: viewControllerCompletion)
    }
    
}
