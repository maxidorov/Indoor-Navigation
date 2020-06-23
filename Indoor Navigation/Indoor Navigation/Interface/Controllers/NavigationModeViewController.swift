//
//  NavigationModeViewController.swift
//  Indoor Navigation
//
//  Created by Maxim Sidorov on 22.06.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit


class NavigationModeViewController: UIViewController {
    
    let modes = ["Map", "QR Codes", "AR"];
    
    let tableView = UITableView()
    static let cellID = "cellID"
    
    override func viewDidLoad() {
        title = "Choose navigation mode"
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NavigationModeViewController.cellID)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension NavigationModeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NavigationModeViewController.cellID, for: indexPath)
        cell.textLabel?.text = modes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var nextViewController: UIViewController!
        switch indexPath.row {
        case 0:
            nextViewController = CheckPointViewController()
        case 1:
            nextViewController = ArrowsViewController()
        case 2:
            nextViewController = ARLineViewController()
        default:
            return
        }
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}
