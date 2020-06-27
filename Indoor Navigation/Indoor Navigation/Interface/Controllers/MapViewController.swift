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
    var arr : [Double] = []
    let queue = DispatchQueue(label: "work-queue")
    let pedometer = CMPedometer()
    var dates  = Date()
    var initRotation = 3.1
    var s = "1"
    var x = 0.0
    var y = 0.0
    var last = 0.0
    let meter: CGFloat = 30.0 //30
    let compassHeading = CompassHeading()
    var scrollView: UIScrollView!
    let restartButton = UIButton()
    
    
    var roomView = UIView()
    var manView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setScrollView()
        setRoomBackground()
        setPositionIndicator()
        setRestartButton()
        restart()
        updateManPosition()
        startPedometer()
    }
    
    @objc func restartButtonAction() {
        restart()
        startPedometer()
    }
    func setScrollView() {
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 120, width: screenWidth, height: screenHeight))
        self.scrollView.contentSize = CGSize(width: 2000, height: 2000)
        view.addSubview(self.scrollView)
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 0.5
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        
    }
    func setRestartButton() {
        restartButton.addTarget(self, action: #selector(restartButtonAction), for: .touchUpInside)
        restartButton.frame.size = CGSize(width: 40.0, height: 40.0)
        restartButton.center.x = view.center.x + 200
        restartButton.center.y = view.center.y + 180
        restartButton.backgroundColor = .red
        restartButton.setTitle("R", for: .normal)
        scrollView.addSubview(restartButton)
    }
    
    func setRoomBackground() {
        roomView = UIImageView(image: UIImage(named: "map"))
        roomView.frame.size = CGSize(width: 32.5 * meter, height: 23 * meter)
        roomView.center.x = view.center.x + 200
        roomView.center.y = view.center.y
        scrollView.addSubview(roomView)
    }
    
    func setPositionIndicator() {
        let manSize: CGFloat = 20
        manView.backgroundColor = .red
        manView.frame.size = CGSize(width: manSize, height: manSize)
        manView.layer.masksToBounds = true
        manView.layer.cornerRadius =  manSize/2
        roomView.addSubview(manView)
        
    }
    func setD(x :CGFloat, y : CGFloat) {
        DispatchQueue.main.async {
            var dView = UIView()
            let dSize: CGFloat = 5
            dView.backgroundColor = .blue
            dView.frame.size = CGSize(width: dSize, height: dSize)
            dView.layer.masksToBounds = true
            dView.layer.cornerRadius =  dSize/2
            dView.center.x = x
            dView.center.y = y
            self.roomView.addSubview(dView)
        }
    }
    
    func updateManPosition() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1) {
                self.manView.center.x = CGFloat(self.x) * self.meter
                self.manView.center.y = CGFloat(self.y) * self.meter
            }
        }
        
    }
    
    
    func test() {
        while true {
            usleep(10000)
            let a = self.compassHeading.radians - self.initRotation
            self.arr.append(a);
        }
    }
    
    func restart() {
        
        queue.async {
            self.test()
        }
        x = 7
        y = 8
        last = 0.0
        updateManPosition()
        dates = Date()
        initRotation = compassHeading.radians + 0.8
        pedometer.stopUpdates()
        
    }
    
    func startPedometer() {
        if CMPedometer.isDistanceAvailable() {
            pedometer.startUpdates(from: dates) { (data, error) in
                let l = (Double((data?.distance)!) - self.last)
                let step = l / Double(self.arr.count)
                self.last += l
                var cnt = 0
                let arrC = self.arr
                self.arr = []
                print(arrC)
                for a in arrC {
                    cnt += 1
                    self.x = self.x + step * cos(a)
                    self.y = self.y + step * sin(a)
                    if cnt % 40 == 0 {
                        self.setD(x : CGFloat(self.x) * self.meter , y : CGFloat(self.y) * self.meter)
                    }
                }
                print(self.arr.count)
                self.updateManPosition()
                print(self.last)
            }
        }
    }
}
