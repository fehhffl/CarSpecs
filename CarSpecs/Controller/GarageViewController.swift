//
//  GarageViewController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 06/09/23.
//

import UIKit

class GarageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var garageCarsCards: [CarGarageItem] = [
    .init(title:"Used Audi A4 1.8T 2015", imageName: "tesla-model-x", price: 300000.00),
        .init(title: "Audi", imageName: "tesla-model-x", price: 300000.00),
    .init(title: "Audi", imageName: "tesla-model-x", price: 300000.00),
    .init(title: "Audi", imageName: "tesla-model-x", price: 300000.00),
    .init(title: "Audi", imageName: "tesla-model-x", price: 300000.00)]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Saved items"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let xib = UINib(nibName: "CarGarageCell", bundle: .main)
        tableView?.register(xib, forCellReuseIdentifier: "IdentifierCarGarageCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        garageCarsCards.count
    }

    // Retorna a célula (UITableViewCell) que sera mostrada na linha indexPath.row e seçao indexPath.section
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IdentifierCarGarageCell") as? CarGarageCell else {
            return UITableViewCell()
        }
        let item = garageCarsCards[indexPath.row]
        cell.configure(item: item)
        return cell
    }
}
