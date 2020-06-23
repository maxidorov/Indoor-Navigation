//
//  ViewController.swift
//  Indoor Navigation
//
//  Created by Maxim Sidorov & Dmitriy Zhbannikov on 10.04.2020.
//  Copyright © 2020 Maxim Sidorov & Dmitriy Zhbannikov. All rights reserved.
//

import UIKit
import ARKit

class CheckPointViewController: UIViewController {
    
    let nodeWithText = SCNNode()
    let sceneView = ARSCNView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Find QR Code"
        navigationController?.navigationBar.tintColor = UIColor.black
        
        setupSceneView()
        startTracking()
    }
    
    private func startTracking() {
        let configuration = ARImageTrackingConfiguration()
        if let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "ARPics", bundle: Bundle.main) {
            configuration.trackingImages = trackingImages
            configuration.maximumNumberOfTrackedImages = 1
        }
        sceneView.session.run(configuration)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        if let imageAnchor = anchor as? ARImageAnchor {
            let qrCodeImageSize = imageAnchor.referenceImage.physicalSize
            
            let nodeBackground = SCNPlane(width: qrCodeImageSize.width, height: qrCodeImageSize.height)
            nodeBackground.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.8)
            nodeBackground.cornerRadius = 0.005
            
            let nodeBackgroundElement = SCNNode(geometry: nodeBackground)
            nodeBackgroundElement.eulerAngles.x = -.pi / 2
            nodeWithText.addChildNode(nodeBackgroundElement)
            
            let nodeText = SCNText(string: "Start\nnavigation", extrusionDepth: 1)
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.black
            nodeText.materials = [material]
            
            let nodeTextElement = SCNNode()
            nodeTextElement.position = SCNVector3(-12, 0, 5)
            nodeTextElement.scale = SCNVector3(0.4, 0.4, 0.4)
            nodeTextElement.geometry = nodeText
            nodeTextElement.eulerAngles.x = -.pi / 2
            
            nodeWithText.addChildNode(nodeTextElement)
        }
        return nodeWithText
    }
    
    func createTextNode(string: String) -> SCNNode {
        let nodeText = SCNText(string: string, extrusionDepth: 0.1)
        nodeText.font = UIFont.systemFont(ofSize: 1.0)
        nodeText.flatness = 0.01
        nodeText.firstMaterial?.diffuse.contents = UIColor.white
        
        let nodeTextElement = SCNNode(geometry: nodeText)
        let nodeTextFontSize = Float(0.04)
        nodeTextElement.scale = SCNVector3(nodeTextFontSize, nodeTextFontSize, nodeTextFontSize)
        
        return nodeTextElement
    }
    
    func addText(string: String, parent: SCNNode) {
        let textNode = createTextNode(string: string)
        textNode.position = SCNVector3Zero
        
        parent.addChildNode(textNode)
    }
    
    @objc func tap(rec: UITapGestureRecognizer){
        if rec.state == .ended {
            let location: CGPoint = rec.location(in: sceneView)
            let hits = self.sceneView.hitTest(location, options: nil)
            if !hits.isEmpty{
                DispatchQueue.main.async {
                    let mapViewController = MapViewController()
                    mapViewController.modalPresentationStyle = .fullScreen
                    self.sceneView.stop(self)
                    self.navigationController?.pushViewController(mapViewController, animated: true)
                }
            }
        }
    }
}

extension CheckPointViewController: ARSCNViewDelegate {
    private func setupSceneView() {
        sceneView.frame = view.frame
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(rec:)))
        sceneView.addGestureRecognizer(tap)
        view.addSubview(sceneView)
    }
}
