//
//  RouteBuilder.swift
//  Indoor Navigation
//
//  Created by Maxim Sidorov on 22.06.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import Foundation

class RouteHelper {
    
    enum Destination: CaseIterable {
        case kitchen
        case bedroom
        case hall
    }
    
    static func build(to destination: Destination) -> [RouteStep]{
        switch destination {
        case .kitchen:
            return [.right, .backward, .backward, .left]
        case .bedroom:
            return [.forward, .forward, .left, .left]
        case .hall:
            return [.forward, .left, .backward, .right]
        }
    }
}
