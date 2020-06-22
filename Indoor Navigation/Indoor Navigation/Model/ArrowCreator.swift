//
//  ArrowCreator.swift
//  Indoor Navigation
//
//  Created by Maxim Sidorov on 22.06.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit
import ARKit

class ARKitHelper {
    static func createArrow(qrCodeImageSize: CGSize) -> SCNNode {
        let nodeWithText = SCNNode(geometry: SCNPlane(width: qrCodeImageSize.width, height: qrCodeImageSize.height))
        nodeWithText.geometry?.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.0)
        nodeWithText.eulerAngles.z = -.pi
        
        let nodeBackground = SCNPlane(width: qrCodeImageSize.width, height: qrCodeImageSize.height)
        nodeBackground.firstMaterial?.diffuse.contents = UIImage(named: "arrow")
        nodeBackground.cornerRadius = 0.005
        
        let nodeBackgroundElement = SCNNode(geometry: nodeBackground)
        nodeBackgroundElement.eulerAngles.x = -.pi / 2
        return nodeBackgroundElement
    }
}
