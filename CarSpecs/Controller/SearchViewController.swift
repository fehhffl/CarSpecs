//
//  SearchViewController.swift
//  CarSpecs
//
//  Created by Felipe Lima on 15/09/23.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingViewContainer: UIView!
    @IBOutlet weak var realTableView: UITableView!
    let carRepository = CarRepository()
    var cars: [Car] = []
    var filtered: [Car] = []
    var currentPage = 1
    var isLoading = false

    override func viewWillAppear(_ animated: Bool) {
        loadingViewContainer.isHidden = true
        super.viewWillAppear(animated)
        title = "Search Cars"
        getCarsFromScratch()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let loadingView = LoadingView()
        loadingViewContainer.addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        realTableView.delegate = self
        realTableView.dataSource = self
        searchBar.returnKeyType = .search
        searchBar.delegate = self
        let xib = UINib(nibName: "CarGarageCell", bundle: .main)
        realTableView.register(xib, forCellReuseIdentifier: "IdentifierCarGarageCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filtered.count
    }

    fileprivate func getCarsFromScratch() {
        isLoading = true
        currentPage = 1
        filtered.removeAll()
        realTableView.reloadData()
        realTableView.layoutIfNeeded()
        getServerData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getCarsFromScratch()
    }

    func getServerData() {
        loadingViewContainer.isHidden = false
        isLoading = true
        carRepository.getCarsForSearch(carName: searchBar.text ?? "", pageNumber: currentPage) { [weak self] (carsSearch: [Car]) in
            self?.filtered += carsSearch
            DispatchQueue.main.async {
                self?.realTableView.reloadData()
                self?.loadingViewContainer.isHidden = true
                self?.isLoading = false
            }
        }
    }
    func tableView(_ realTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = realTableView.dequeueReusableCell(withIdentifier: "IdentifierCarGarageCell") as? CarGarageCell else {
            return UITableViewCell()
        }

        let car = filtered[indexPath.row]
        let item = CardItem(
            title: car.name,
            subtitle: car.price.currencyFR,
            imageName: car.imageName)
        cell.configure(item: item)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var id: Int = 0
        let currentCar = filtered[indexPath.row]
        id = currentCar.carId
        navigationController?.pushViewController(CarInfosViewController(carId: id), animated: true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // check if scrollview has reached the bottom
        let height = scrollView.frame.height
        let contentSizeHeight = scrollView.contentSize.height
        let offset = scrollView.contentOffset.y
        let reachedBottom = (offset > contentSizeHeight - height)
        if reachedBottom && !isLoading {
            currentPage += 1
            getServerData()
        }
    }
}
