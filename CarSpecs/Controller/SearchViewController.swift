//
//  SearchViewController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 15/09/23.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var realTableView: UITableView!
    let carRepository = CarRepository()
    var cars: [Car] = []
    var filtered: [Car] = []
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Search Cars"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // cars = carRepository.getAllCars()
        filtered = cars
        realTableView.delegate = self
        realTableView.dataSource = self
        searchBar.delegate = self
        let xib = UINib(nibName: "CarGarageCell", bundle: .main)
        realTableView.register(xib, forCellReuseIdentifier: "IdentifierCarGarageCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filtered.count
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered.removeAll()
        for car in cars {
            if car.name.lowercased().starts(with: searchText.lowercased()) {
                filtered.append(car)
            }
        }
        realTableView.reloadData()
    }

    func tableView(_ realTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = realTableView.dequeueReusableCell(withIdentifier: "IdentifierCarGarageCell") as? CarGarageCell else {
            return UITableViewCell()
        }

        let car = filtered[indexPath.row]
        let item = SquareCardItem(
            title: car.name,
            subtitle: String(format: "$%.2f", car.price),
            imageName: car.imageName)
        cell.configure(item: item)
        return cell
    }
}
