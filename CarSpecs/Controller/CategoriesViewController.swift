//
//  CategoriesViewController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 30/08/23.
//

import UIKit

class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView?
    private var categoryItems: [CardItem] = []
    private let squareCardsRepository = SquareCardsRepository()
    var carRepository = CarRepository()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Collection"
    }
    func completionGetCategories(allCategories: [String]) {
        var cardItems: [CardItem] = []
        for categoryName in allCategories {
            let cardItem = squareCardsRepository.convertCategoryToSquareCard(using: categoryName)
            cardItems.append(cardItem)
        }
        categoryItems = cardItems
        DispatchQueue.main.sync {
            tableView?.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        carRepository.getAllCategories(completion: completionGetCategories)
        tableView?.delegate = self
        tableView?.dataSource = self
        let xib = UINib(nibName: "CategoryCell", bundle: .main)
        tableView?.register(xib, forCellReuseIdentifier: "IndentifierCategoryCell")
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categoryItems[indexPath.row].title
        navigationController?.pushViewController(CategoryListViewController(category: category), animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView?.dequeueReusableCell(withIdentifier: "IndentifierCategoryCell", for: indexPath) as? CategoryCell else {
            return UITableViewCell()
        }
        cell.configure(with: categoryItems[indexPath.row])
        return cell
    }
}
