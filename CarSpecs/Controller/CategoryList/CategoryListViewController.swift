//
//  CategoryListViewController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 11/10/23.
//

import UIKit

class CategoryListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    private let viewModel: CategoryListViewModel
    
    init(category: String) {
        super.init(nibName: nil, bundle: nil)
        viewModel = CategoryListViewModel(category: category)
    }

    func updateCars(carsArray: [Car]) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.hideLoader()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CarGarageCell", bundle: .main), forCellReuseIdentifier: "IdentifierCarGarageCell")
        showLoader()
        viewModel.getCarsFromCategory(viewControllerCompletion: updateCars)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cars.count
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let indiceItemAtual = currentItemIndex
        let indiceUltimaPosicao = viewModel.cars.count - 1
        if indiceItemAtual == indiceUltimaPosicao {
            viewModel.loadNextPage(viewControllerCompletion: updateCars)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCar = viewModel.cars[indexPath.row]
        navigationController?.pushViewController(CarInfosViewController(carId: currentCar.carId), animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IdentifierCarGarageCell", for: indexPath) as? CarGarageCell else {
            return UITableViewCell()
        }

        let car = viewModel.cars[indexPath.row]

        let item = CardItem(
            title: car.name,
            subtitle: car.price.currencyFR,
            imageName: car.imageName)

        cell.configure(item: item)

        return cell
    }

}
