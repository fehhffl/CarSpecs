//
//  GarageViewController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 06/09/23.
//

import UIKit

class GarageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let squareCardsRepository = SquareCardsRepository()
    var squareCardItems: [SquareCardItem] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Saved items"
    }

    override func viewDidLoad() {
        squareCardItems = squareCardsRepository.getAllSquareCards()
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let xib = UINib(nibName: "CarGarageCell", bundle: .main)
        tableView?.register(xib, forCellReuseIdentifier: "IdentifierCarGarageCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        squareCardItems.count
    }

    // Retorna a célula (UITableViewCell) que sera mostrada na linha indexPath.row e seçao indexPath.section
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IdentifierCarGarageCell") as? CarGarageCell else {
            return UITableViewCell()
        }
        let item = squareCardItems[indexPath.row]
        cell.configure(item: item)
        return cell
    }
}
