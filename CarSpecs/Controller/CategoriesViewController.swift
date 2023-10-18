//
//  CategoriesViewController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 30/08/23.
//

import UIKit

class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView?
    private let categoryItems: [CategoryItem] = [
        CategoryItem(title: "suv", imageName: "tesla-model-x"),
        CategoryItem(title: "coupé", imageName: "vw_gti"),
        CategoryItem(title: "sedan", imageName: "morgan-aero 8"),
        CategoryItem(title: "hatchback", imageName: "bmw-i3"),
        CategoryItem(title: "van", imageName: "dodge-ram")
    ]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Collection"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
