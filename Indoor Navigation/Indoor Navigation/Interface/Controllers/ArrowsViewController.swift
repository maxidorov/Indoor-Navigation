//
//  ArrowsViewController.swift
//  Indoor Navigation
//
//  Created by Maxim Sidorov on 22.06.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit
import ARKit

class ArrowsViewController: UIViewController {
    
    let sceneView = ARSCNView()
    let configuration = ARImageTrackingConfiguration()
    let routeManager = RouteManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSceneView()
        startTracking()
    }
    
    private func startTracking() {
        if let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "ARPics", bundle: Bundle.main) {
            configuration.trackingImages = trackingImages
            // MARK: 1 or more?
            configuration.maximumNumberOfTrackedImages = 1
        }
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let imageAnchor = anchor as? ARImageAnchor else { return nil }
        
        switch routeManager.mode {
        case .finding:
            DispatchQueue.main.async {
                let locationPartsViewController = LocationPartsViewController()
                locationPartsViewController.sceneView = self.sceneView
                locationPartsViewController.configuration = self.configuration
                locationPartsViewController.routeManager = self.routeManager
                self.present(locationPartsViewController, animated: true, completion: nil)
            }
            
        case .routing:
            print(routeManager.destination ?? "nil desctination")
            
            let imageName = imageAnchor.name ?? "nil name"
            
            print(imageName)
            
            let qrCodeImageSize = imageAnchor.referenceImage.physicalSize
            let arrowNode = SCNNode(geometry: SCNPlane(width: qrCodeImageSize.width, height: qrCodeImageSize.height))
            arrowNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.0)
            arrowNode.eulerAngles.z = -.pi
            let arrowImageNode = ARKitHelper.addImage(named: "arrow", size: qrCodeImageSize)
            
            for i in 0..<QRCodes.imageNames.count {
                if imageName == QRCodes.imageNames[i] {
                    arrowImageNode.eulerAngles.y = routeManager.route[i].toAngle()
                }
            }
            
            /*
            
            switch imageName {
            case QRCodes.imageNames[0]:
                arrowImageNode.eulerAngles.y = routeManager.route[0].toAngle()
//                arrowImageNode.eulerAngles.y = -.pi / 2 // вправо
            case QRCodes.imageNames[1]:
                arrowImageNode.eulerAngles.y = routeManager.route[1].toAngle()
//                arrowImageNode.eulerAngles.y = .pi / 2 // влево
            case QRCodes.imageNames[2]:
                arrowImageNode.eulerAngles.y = routeManager.route[2].toAngle()
//                arrowImageNode.eulerAngles.y = -.pi // назад
            case QRCodes.imageNames[3]:
                arrowImageNode.eulerAngles.y = routeManager.route[3].toAngle()
            default:
                break
            }
 
 */
            
//            arrowImageNode.eulerAngles.y = -.pi / 2 // вправо
            //        nodeBackgroundElement.eulerAngles.y = .pi / 2 // влево
            //        nodeBackgroundElement.eulerAngles.y = .pi // назад
            
            arrowNode.addChildNode(arrowImageNode)
            
            return arrowNode
        }
        return nil
    }
}

extension ArrowsViewController: ARSCNViewDelegate {
    private func setupSceneView() {
        sceneView.frame = view.frame
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        view.addSubview(sceneView)
    }
}
