//
//  CompassHeading.swift
//  Indoor Navigation
//
//  Created by Maxim Sidorov & Dmitriy Zhbannikov on 10.04.2020.
//  Copyright © 2020 Maxim Sidorov & Dmitriy Zhbannikov. All rights reserved.
//

import Foundation
import Combine
import CoreLocation

class CompassHeading: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var objectWillChange = PassthroughSubject<Void, Never>()
    
    public var radians: Double {
        return degrees * Double.pi / 180.0
    }
    
    public var degrees: Double = .zero {
        didSet {
            objectWillChange.send()
        }
    }
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
        self.setup()
    }
    
    private let locationManager: CLLocationManager
    
    private func setup() {
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.headingAvailable() {
            self.locationManager.startUpdatingLocation()
            self.locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.degrees = newHeading.magneticHeading
    }
}
