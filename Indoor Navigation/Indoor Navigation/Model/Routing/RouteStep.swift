//
//  RouteStep.swift
//  Indoor Navigation
//
//  Created by Maxim Sidorov on 22.06.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import Foundation

enum RouteStep {
    case forward, backward, left, right
    case finish
}

extension RouteStep {
    func toAngle() -> Float {
        switch self {
        case .forward:
            return 0
        case .left:
            return .pi / 2
        case .right:
            return -.pi / 2
        case .backward:
            return -.pi
        case .finish:
            return 0
        }
    }
}
