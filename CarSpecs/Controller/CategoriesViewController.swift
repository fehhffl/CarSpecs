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
        CategoryItem(title: "Eletric", imageName: "tesla-model-x"),
        CategoryItem(title: "New Cars", imageName: "vw_gti"),
        CategoryItem(title: "Luxury", imageName: "morgan-aero 8"),
        CategoryItem(title: "Hybrid", imageName: "bmw-i3"),
        CategoryItem(title: "Trucks", imageName: "dodge-ram")
    ]
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Categories"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.delegate = self
        tableView?.dataSource = self
        let xib = UINib(nibName: "CategoryCell", bundle: .main)
        tableView?.register(xib, forCellReuseIdentifier: "IndentifierCategoryCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryItems.count    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView?.dequeueReusableCell(withIdentifier: "IndentifierCategoryCell", for: indexPath)
            as? CategoryCell else {
            return UITableViewCell()

        }
        cell.configure(with: categoryItems[indexPath.row])
        return cell
    }
}
