//
//  LocationsViewController.swift
//  Indoor Navigation
//
//  Created by Maxim Sidorov & Dmitriy Zhbannikov on 14.06.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

class LocationsViewController: UIViewController {
    
    static let cellID = "LocationCell"
    
    private var tableView = UITableView()
    private var locations = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Locations"
        
        setupLocations()
        setupTableView()
    }
    
    private func setupLocations() {
        locations = [
            Location(title: "Test location", subtitle: "Flat", image: UIImage(named: "map")),
            Location(title: "Pokrovka", subtitle: "Higher School of Economics", image: UIImage(named: "HSE")),
            Location(title: "Sberbank", subtitle: "Office space", image: UIImage(named: "Sberbank")),
            Location(title: "Aviapark", subtitle: "Shopping center", image: UIImage(named: "Aviapark"))
        ]
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: LocationsViewController.cellID)
    }
    
}

extension LocationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationsViewController.cellID, for: indexPath)
        guard let locationCell = cell as? LocationCell else { return cell }
        locationCell.location = locations[indexPath.row]
        return locationCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row == 0 else { return }
        let checkPointViewController = NavigationModeViewController()
        navigationController?.pushViewController(checkPointViewController, animated: true)
    }
}
