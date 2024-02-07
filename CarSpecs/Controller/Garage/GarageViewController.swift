//
//  GarageViewController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 06/09/23.
//

import SwiftyUserDefaults
import UIKit

class GarageViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    let carRepository = CarRepository()
    var favoriteCars: [Car] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Saved items"
        favoriteCars = Defaults[key: DefaultsKeys.favoriteCars]
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var id: Int = 0
        let currentCar = favoriteCars[indexPath.row]
        id = currentCar.carId
        navigationController?.pushViewController(CarInfosViewController(carId: id), animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let xib = UINib(nibName: "CarGarageCell", bundle: .main)
        tableView?.register(xib, forCellReuseIdentifier: "IdentifierCarGarageCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoriteCars.count
    }

    // Retorna a célula (UITableViewCell) que sera mostrada na linha indexPath.row e seçao indexPath.section
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IdentifierCarGarageCell") as? CarGarageCell else {
            return UITableViewCell()
        }
        let car = favoriteCars[indexPath.row]
        let item = CardItem(
            title: car.name,
            subtitle: car.price.currencyFR,
            imageName: car.imageName)
        cell.configure(item: item)
        return cell
    }
}
