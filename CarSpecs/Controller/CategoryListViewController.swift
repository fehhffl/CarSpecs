//
//  CategoryListViewController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 11/10/23.
//

import UIKit

class CategoryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    private let category: String
    private let carRepository = CarRepository()
    private var cars: [Car] = []
    var pageNumber: Int = 1

    init(category: String) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }

    func completion(carsArray: [Car]) {
        self.cars += carsArray
        DispatchQueue.main.sync {
            tableView.reloadData()
            hideLoader()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CarGarageCell", bundle: .main), forCellReuseIdentifier: "IdentifierCarGarageCell")
        showLoader()
        carRepository.getCarsFromCategory(pageNumber: pageNumber, category: category, completion: completion)
    }
    func loadMoreCarsIfLast(currentItemIndex: Int) {
        let indiceItemAtual = currentItemIndex
        let indiceUltimaPosicao = cars.count - 1

        if indiceItemAtual == indiceUltimaPosicao {
            pageNumber += 1
            carRepository.getCarsFromCategory(pageNumber: pageNumber, category: category, completion: completion )
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cars.count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        loadMoreCarsIfLast(currentItemIndex: indexPath.row)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var id: Int = 0
        let currentCar = cars[indexPath.row]
        id = currentCar.carId
        showLoader()
        navigationController?.pushViewController(CarInfosViewController(carId: id), animated: true)
        hideLoader()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IdentifierCarGarageCell", for: indexPath) as? CarGarageCell else {
            return UITableViewCell()
        }

        let car = cars[indexPath.row]

        let item = CardItem(
            title: car.name,
            subtitle: car.price.currencyFR,
            imageName: car.imageName)

        cell.configure(item: item)

        return cell
    }

}
