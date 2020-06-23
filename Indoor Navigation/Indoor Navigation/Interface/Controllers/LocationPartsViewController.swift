//
//  LocationPartsViewController.swift
//  Indoor Navigation
//
//  Created by Maxim Sidorov on 22.06.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit
import ARKit

class LocationPartsViewController: UIViewController {
    
    let locationParts = ["Kitchen", "Bedroom", "Hall"]
    
    let tableView = UITableView()
    static let cellID = "cellID"
    
    var sceneView: ARSCNView!
    var configuration: ARImageTrackingConfiguration!
    var routeManager: RouteManager!
    
    override func viewDidLoad() {
        title = "Choose destination point"
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: LocationPartsViewController.cellID)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension LocationPartsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationParts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationPartsViewController.cellID, for: indexPath)
        cell.textLabel?.text = locationParts[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        routeManager.destination = locationParts[indexPath.row]
        routeManager.mode = .routing
        switch indexPath.row {
        case 0: routeManager.route = RouteHelper.buildRoute(to: .kitchen)
        case 1: routeManager.route = RouteHelper.buildRoute(to: .bedroom)
        case 2: routeManager.route = RouteHelper.buildRoute(to: .hall)
        default: break
        }
        sceneView.session.pause()
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        dismiss(animated: true, completion: nil)
    }
}
