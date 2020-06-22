//
//  ARKitHelper.swift
//  Indoor Navigation
//
//  Created by Maxim Sidorov on 22.06.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit
import ARKit

class ARKitHelper {
    static func addImage(named imageName: String, size: CGSize) -> SCNNode {
        let nodeImage = SCNPlane(width: size.width, height: size.height)
        nodeImage.firstMaterial?.diffuse.contents = UIImage(named: imageName)
        nodeImage.cornerRadius = 0.005
        
        let arrowNode = SCNNode(geometry: nodeImage)
        arrowNode.eulerAngles.x = -.pi / 2
        
        return arrowNode
    }
}
