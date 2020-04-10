//
//  MapViewController.swift
//  Indoor Navigation
//
//  Created by Maxim Sidorov & Dmitriy Zhbannikov on 10.04.2020.
//  Copyright © 2020 Maxim Sidorov & Dmitriy Zhbannikov. All rights reserved.
//

import UIKit
import CoreMotion

class MapViewController: UIViewController {
    
    let pedometer = CMPedometer()
    var dates  = Date()
    var initRotation = 3.1
    var s = "1"
    var x = 0.0
    var y = 0.0
    var last = 0.0
    let meter: CGFloat = 30.0
    let compassHeading = CompassHeading()
    
    var roomView = UIView()
    var manView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setRoomBackground()
        setPositionIndicator()
        setRestartButton()
        updateManPosition()
        restart()
        startPedometer()
    }
    
    @objc func restartButtonAction() {
        restart()
        startPedometer()
    }
    func setRestartButton() {
        let restartButton = UIButton()
        restartButton.addTarget(self, action: #selector(restartButtonAction), for: .touchUpInside)
        restartButton.frame.size = CGSize(width: 40.0, height: 40.0)
        restartButton.center.x = view.center.x
        restartButton.center.y = view.center.y + 180
        restartButton.backgroundColor = .red
        restartButton.setTitle("R", for: .normal)
        view.addSubview(restartButton)
    }
    
    func setRoomBackground() {
        roomView = UIImageView(image: UIImage(named: "map"))
        roomView.frame.size = CGSize(width: 9.5 * meter, height: 7.5 * meter)
        roomView.center.x = view.center.x
        roomView.center.y = view.center.y
        view.addSubview(roomView)
    }
    
    func setPositionIndicator() {
        let manSize: CGFloat = 20
        manView.backgroundColor = .red
        manView.frame.size = CGSize(width: manSize, height: manSize)
        manView.layer.masksToBounds = true
        manView.layer.cornerRadius =  manSize/2
        roomView.addSubview(manView)
        
    }
    
    func updateManPosition() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1) {
                self.manView.center.x = CGFloat(self.x) * self.meter / 2
                self.manView.center.y = CGFloat(self.y) * self.meter / 2
            }
        }
    }
    
    func restart() {
        x = 0
        y = 0
        last = 0.0
        updateManPosition()
        dates = Date()
        initRotation = compassHeading.radians
        pedometer.stopUpdates()
    }
    
    func startPedometer() {
        if CMPedometer.isDistanceAvailable() {
            pedometer.startUpdates(from: dates) { (data, error) in
                let l = (Double((data?.distance)!) - self.last)
                let a = self.compassHeading.radians - self.initRotation
                self.x = self.x + l * cos(a)
                self.y = self.y + l * sin(a)
                self.last = l
                self.updateManPosition()
            }
        }
    }
}
