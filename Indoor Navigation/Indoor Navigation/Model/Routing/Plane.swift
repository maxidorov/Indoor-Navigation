//
//  Plane.swift
//  Indoor Navigation
//
//  Created by Serge Yuhnov on 17.06.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit
import ARKit

class Plane: SCNNode {
    
    var planeGemoetry: SCNBox?
    var anchor: ARPlaneAnchor?
    
    init(anchor: ARPlaneAnchor) {
        super.init()
        let width = CGFloat(anchor.extent.x)
        let length = CGFloat(anchor.extent.z)
        let planeHeight = 0.01 as CGFloat
        
        self.planeGemoetry = SCNBox(width: width, height: planeHeight, length: length, chamferRadius: 0)
        
        let material = SCNMaterial()
        
        let transparentMaterial = SCNMaterial()
        transparentMaterial.diffuse.contents = UIColor.white.withAlphaComponent(0.0)
        
        self.planeGemoetry?.materials = [transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial, material, transparentMaterial]
        
        let planeNode = SCNNode(geometry: self.planeGemoetry)
        
        planeNode.position = SCNVector3(0, -planeHeight/2.0 , 0)
        
        self.addChildNode(planeNode)
        
        setTextureScale()
    }
    
    func updateWith(_ anchor: ARPlaneAnchor) {
        self.planeGemoetry?.width = CGFloat(anchor.extent.x)
        self.planeGemoetry?.length = CGFloat(anchor.extent.z)
        
        self.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        
        setTextureScale()
    }
    
    func setTextureScale() {
        let width = self.planeGemoetry?.width
        let length = self.planeGemoetry?.length
        
        let material = self.planeGemoetry?.materials[4]
        material?.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(width!), Float(length!), 1);
        material?.diffuse.wrapS = .repeat
        material?.diffuse.wrapT = .repeat
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


