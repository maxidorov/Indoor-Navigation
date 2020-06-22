//
//  RouteManager.swift
//  Indoor Navigation
//
//  Created by Maxim Sidorov on 22.06.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import Foundation

class RouteManager {
    
    enum Mode {
        case finding
        case routing
    }
    
    var mode = Mode.finding
    var route: [RouteStep] = []
    var destination: String? = nil
}
