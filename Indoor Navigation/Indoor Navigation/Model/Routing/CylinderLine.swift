//
//  CylinderLine.swift
//  Indoor Navigation
//
//  Created by Serge Yuhnov on 17.06.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import Foundation
import ARKit

class   CylinderLine: SCNNode
{
    let material = SCNMaterial()
    
    init(
        v1: SCNVector3,
        v2: SCNVector3,
        radius: CGFloat,
        UIImageName: String )
    {
        super.init()
        
        let  height = v1.distance(receiver: v2)
        self.position = v1
        
        let nodeV2 = SCNNode()
        
        nodeV2.position = v2
        let zAlign = SCNNode()
        zAlign.eulerAngles.x = .pi/2
        zAlign.eulerAngles.z += Float(180.0).degreesToRadians
        let cyl = SCNPlane(width: radius*2, height: CGFloat(height))
        cyl.firstMaterial?.isDoubleSided = true
        cyl.firstMaterial?.emission.contents = UIColor.white
        cyl.firstMaterial?.emission.intensity = 1
        
        let scaleX = (Float(radius*3)  / 0.2).rounded()
        let scaleY = (Float(height) / 0.2).rounded()
        material.diffuse.contents = UIImage(named:UIImageName)
        material.emission.contents = UIColor.green
    
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(scaleX/3, scaleY/2, 0)
        material.diffuse.wrapS = .repeat
        material.diffuse.wrapT = .repeat
        cyl.materials = [material]
        
        let nodeCyl = SCNNode(geometry: cyl )
        nodeCyl.position.y = -height/2
        zAlign.addChildNode(nodeCyl)
        
        addChildNode(zAlign)
        constraints = [SCNLookAtConstraint(target: nodeV2)]
    }
    
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    weak var timer: Timer?
    
    func startFlashing() {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] _ in
            if  (self?.material.emission.contents as! UIColor) == UIColor.yellow {
                self?.material.emission.contents = UIColor.green
            } else {
                self?.material.emission.contents = UIColor.yellow
            }
        }
    }
    func stopFlashing() {
        timer?.invalidate()
    }
    deinit {
        stopFlashing()
    }
}

private extension SCNVector3{
    func distance(receiver:SCNVector3) -> Float{
        let xd = receiver.x - self.x
        let yd = receiver.y - self.y
        let zd = receiver.z - self.z
        let distance = Float(sqrt(xd * xd + yd * yd + zd * zd))
        
        if (distance < 0){
            return (distance * -1)
        } else {
            return (distance)
        }
    }
}
extension Double {
    var degreesToRadians: Double { return Double(self) * .pi/180}
}
extension Float {
    var degreesToRadians: Float { return Float(self) * .pi/180}
}
extension SCNNode {
    
    private func normalizeVector(_ iv: SCNVector3) -> SCNVector3 {
        let length = sqrt(iv.x * iv.x + iv.y * iv.y + iv.z * iv.z)
        if length == 0 {
            return SCNVector3(0.0, 0.0, 0.0)
        }
        
        return SCNVector3( iv.x / length, iv.y / length, iv.z / length)
        
    }
    
    
    func buildLineInTwoPointsWithRotation(from startPoint: SCNVector3,
                                          to endPoint: SCNVector3,
                                          radius: CGFloat,
                                          color: UIColor) -> SCNNode {
        let w = SCNVector3(x: endPoint.x-startPoint.x,
                           y: endPoint.y-startPoint.y,
                           z: endPoint.z-startPoint.z)
        let l = CGFloat(sqrt(w.x * w.x + w.y * w.y + w.z * w.z))
        
        if l == 0.0 {
            
            let sphere = SCNSphere(radius: radius)
            sphere.firstMaterial?.diffuse.contents = color
            self.geometry = sphere
            self.position = startPoint
            return self
            
        }
        
        let cyl = SCNCylinder(radius: radius, height: l)
        cyl.firstMaterial?.diffuse.contents = color
        
        self.geometry = cyl
        
        
        let ov = SCNVector3(0, l/2.0,0)
        
        let nv = SCNVector3((endPoint.x - startPoint.x)/2.0, (endPoint.y - startPoint.y)/2.0,
                            (endPoint.z-startPoint.z)/2.0)
        
        
        let av = SCNVector3( (ov.x + nv.x)/2.0, (ov.y+nv.y)/2.0, (ov.z+nv.z)/2.0)
        
        
        let av_normalized = normalizeVector(av)
        let q0 = Float(0.0)
        let q1 = Float(av_normalized.x)
        let q2 = Float(av_normalized.y)
        let q3 = Float(av_normalized.z)
        
        let r_m11 = q0 * q0 + q1 * q1 - q2 * q2 - q3 * q3
        let r_m12 = 2 * q1 * q2 + 2 * q0 * q3
        let r_m13 = 2 * q1 * q3 - 2 * q0 * q2
        let r_m21 = 2 * q1 * q2 - 2 * q0 * q3
        let r_m22 = q0 * q0 - q1 * q1 + q2 * q2 - q3 * q3
        let r_m23 = 2 * q2 * q3 + 2 * q0 * q1
        let r_m31 = 2 * q1 * q3 + 2 * q0 * q2
        let r_m32 = 2 * q2 * q3 - 2 * q0 * q1
        let r_m33 = q0 * q0 - q1 * q1 - q2 * q2 + q3 * q3
        
        self.transform.m11 = r_m11
        self.transform.m12 = r_m12
        self.transform.m13 = r_m13
        self.transform.m14 = 0.0
        
        self.transform.m21 = r_m21
        self.transform.m22 = r_m22
        self.transform.m23 = r_m23
        self.transform.m24 = 0.0
        
        self.transform.m31 = r_m31
        self.transform.m32 = r_m32
        self.transform.m33 = r_m33
        self.transform.m34 = 0.0
        
        self.transform.m41 = (startPoint.x + endPoint.x) / 2.0
        self.transform.m42 = (startPoint.y + endPoint.y) / 2.0
        self.transform.m43 = (startPoint.z + endPoint.z) / 2.0
        self.transform.m44 = 1.0
        return self
    }
    
}
extension Dictionary where Value: Equatable {
    func allKeys(forValue val: Value) -> [Key] {
        return self.filter { $1 == val }.map { $0.0 }
    }
}
