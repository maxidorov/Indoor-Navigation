//
//  ViewController.swift
//  Indoor Navigation
//
//  Created by Maxim Sidorov & Dmitriy Zhbannikov & Sergey Yukhatskov on 10.04.2020.
//  Copyright © 2020 Maxim Sidorov & Dmitriy Zhbannikov & Sergey Yukhatskov. All rights reserved.
//

import UIKit
import ARKit
import GameplayKit

class ARLineViewController: UIViewController {
    
    let nodeWithText = SCNNode()
    let sceneView = ARSCNView()
    
    var pathNodes = [SCNNode(),SCNNode()]
    var tempYAxis = Float()
    let rootPathNode = SCNNode()
    let rootConnectingNode = SCNNode()
    let origin = SCNVector3Make(0, 0, 0)
    var stringPathMap = [String:[String]]()
    var cameraLocation = SCNVector3()
    var dictPlanes = [ARPlaneAnchor:Plane]()
    var tempNodeFlag = false
    var poiFlag = false
    let rootTempNode = SCNNode()
    var pathGraph = GKGraph()
    let rootNavigationNode = SCNNode()
    
    //идея Димы
    let rootPOINode = SCNNode()
    var poiNode = [String]()
    let startPosition = SCNVector3Make(-2, -1, 3)
    let finish = SCNVector3Make(-5,-1,3.0)
    let str_finish = "SCNVector3(x: -5.0, y: -1.0, z: 3.0)"
//    let str_finish = "SCNVector3(x: 0.3402511, y: -1.0, z: 2.1821897)"
//    let str_finish = "finish"
    var strNode = String()
    var dictOfNodes = [String:GKGraphNode2D]()
    var counter = 0
    var poiCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Find QR Code"
        navigationController?.navigationBar.tintColor = UIColor.black
        
        setupSceneView()
        startTracking()
    }
    
    private func startTracking() {
        print("WARNING")
        let configuration = ARImageTrackingConfiguration()
        if let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "ARPics", bundle: Bundle.main) {
            configuration.trackingImages = trackingImages
            configuration.maximumNumberOfTrackedImages = 1
        }
//        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,ARSCNDebugOptions.showWorldOrigin]
//        self.sceneView.autoenablesDefaultLighting = true
//        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
//        self.sceneView.scene.rootNode.addChildNode(rootPathNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        print("render 1")
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
        print("WARNING node")
        return nodeWithText
    }
    
    func createTextNode(string: String) -> SCNNode {
        print("WARNING 1")
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
        print("WARNING addText")
        let textNode = createTextNode(string: string)
        textNode.position = SCNVector3Zero
        
        parent.addChildNode(textNode)
    }
    
    @objc func tap(rec: UITapGestureRecognizer){
        nodeWithText.isHidden = true
        print("WARNING tap")
        let configuration = ARWorldTrackingConfiguration()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.autoenablesDefaultLighting = true
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        self.sceneView.scene.rootNode.addChildNode(rootPathNode)
        self.sceneView.scene.rootNode.addChildNode(rootConnectingNode)
        self.sceneView.scene.rootNode.addChildNode(rootTempNode)
        self.sceneView.scene.rootNode.addChildNode(rootNavigationNode)
        self.sceneView.scene.rootNode.addChildNode(rootPOINode)
        
        tempNodeFlag = true
//        pathNodes[0].position.y = pathNodes[1].position.y
        pathNodes[0].position.y = -1
        tempYAxis = pathNodes[0].position.y
//        addPathNodes(n1: pathNodes[0].position,n2: pathNodes[1].position)
//        addPathNodes(n1: startPosition, n2: finish)
        addPathNodes(n1: startPosition, n2:finish)
        tempNodeFlag = false
        counter = 0
//        addPathNodes(n1: startPosition, n2: SCNVector3(1,1,1))
        self.poiFlag = true
        poiCounter += 1
        tempFunc(destNode: str_finish)
//        x =  -1.3228489 y =  -1.3228489 z =  -1.016277
//        tempNodeFlag = true
//        if rec.state == .ended {
//            let location: CGPoint = rec.location(in: sceneView)
//            let hits = self.sceneView.hitTest(location, options: nil)
//            if !hits.isEmpty{
//                DispatchQueue.main.async {
//                    let mapViewController = MapViewController()
//                    mapViewController.modalPresentationStyle = .fullScreen
//                    self.sceneView.stop(self)
//                    self.present(mapViewController, animated: true, completion: nil)
//                }
//            }
//        }
    }
    
    func tempFunc(destNode:String) {
            
            for (key,_) in dictPlanes {
                let plane = key as ARAnchor
                self.sceneView.session.remove(anchor: plane)
            }
            dictPlanes = [ARPlaneAnchor:Plane]()
            self.sceneView.debugOptions.remove(
                [ARSCNDebugOptions.showFeaturePoints,ARSCNDebugOptions.showWorldOrigin])
    //                rootPathNode.removeFromParentNode()
            rootTempNode.removeFromParentNode()
                    rootConnectingNode.removeFromParentNode()
            
            var minDistanc = Float()
            minDistanc = 1000
            var nearestNode = SCNNode()
            
            rootPathNode.enumerateChildNodes { (child, _) in
                if !isEqual(n1: origin, n2: child.position) {
                    
                    let dist0 = distanceBetween(n1: cameraLocation, n2: child.position)
                    if minDistanc>dist0 {
                        
                        minDistanc = dist0
                        nearestNode = child
                    }
                }
            }
            stringPathMap["\(cameraLocation)"] = ["\(nearestNode.position)"]
            strNode = "\(cameraLocation)"
            
            retrieveFromDictAndNavigate(destNode:destNode)
        }
    
    func retrieveFromDictAndNavigate(destNode:String) {
            
            rootNavigationNode.enumerateChildNodes { (node, _) in
                node.removeFromParentNode()
            }
            for data in stringPathMap {
                let myVector = self.getVector2FromString(str: data.key)
                let myPos = self.getVector2FromString(str: data.value[0])
                print("point_pos: ", data.value[0])
                print("my_pos: ", data.key)
                dictOfNodes[data.key] = GKGraphNode2D(point: vector2(Float(myVector.x),Float(myVector.z)))
                pathGraph.add([dictOfNodes[data.key]!])
            }
        
            for data in stringPathMap {
                print("HERE")
                print(data)

                let keyNode = dictOfNodes[data.key]!

                for data2 in data.value {

                    keyNode.addConnections(to: [dictOfNodes["\(data2)"]!], bidirectional: true)
                }
            }
            let startKeyVectorString = strNode
            let destKeyVectorString = destNode
            print(dictOfNodes)
            let startNodeFromDict = dictOfNodes[startKeyVectorString]
            let destNodeFromDict = dictOfNodes[destKeyVectorString]
//            print(dictOfNodes)
//            exit(0)
            let wayPoint:[GKGraphNode2D] = pathGraph.findPath(from: startNodeFromDict!, to: destNodeFromDict!) as! [GKGraphNode2D]
            
            var x = wayPoint[0]
            var skipWaypointFlag = true
            for path in wayPoint {
                
                if skipWaypointFlag {
                    skipWaypointFlag = false
                    continue
                }
                let str = SCNVector3(x.position.x, tempYAxis, x.position.y)
                let dst = SCNVector3(path.position.x, tempYAxis, path.position.y)
                print("WARNING")
                let navigationNode = CylinderLine(v1: str, v2: dst, radius: 0.2, UIImageName:"Navi")
                navigationNode.startTimer()
                rootNavigationNode.addChildNode(navigationNode)
                x = path
            }
            pathGraph = GKGraph()
            stringPathMap.removeValue(forKey: strNode)
            
        }
    
    func getVector2FromString(str:String) -> vector_double3 {
        
        let xrange = str.index(str.startIndex, offsetBy: 10)...str.index(str.endIndex, offsetBy: -1)
        let str1 = str[xrange]
        
        var x:String = ""
        var y:String = ""
        var z:String = ""
        var counter = 1
        for i in str1 {
            //    print (i)
            if (i == "-" || i == "." || i == "0" || i == "1" || i == "2" || i == "3" || i == "4" || i == "5" || i == "6" || i == "7" || i == "8" || i == "9") {
                switch counter {
                case 1 : x = x + "\(i)"
                case 2 : y = y + "\(i)"
                case 3 : z = z + "\(i)"
                default : break
                }
            } else if (i == ",") {
                counter = counter + 1
            }
        }
        return vector3(Double(x)!,Double(y)!,Double(z)!)
    }
    
    func addPointOfInterestNode(hitTestResult:ARHitTestResult) {
       
        let transform = hitTestResult.worldTransform
        let thirdColumn = transform.columns.3
        
        let node = SCNNode(geometry:SCNCylinder(radius: 0.04, height: 1.7))
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        node.position = SCNVector3Make(finish.x, finish.y+0.85, finish.z)
        rootPOINode.addChildNode(node)
        
        let node2 = SCNNode(geometry:SCNBox(width: 0.25, height: 0.25, length: 0.25, chamferRadius: 0.01))
        switch poiCounter {
        case 1:
            node2.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "G")
        case 2:
            node2.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "C")
        default:
            node2.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "first")
        }
        node2.position = SCNVector3Make(finish.x, finish.y+1.5, finish.z)
        rootPOINode.addChildNode(node2)
        
        var minDistanc = Float()
        minDistanc = 1000
        var nearestNode = SCNNode()
        
        rootPathNode.enumerateChildNodes { (child, _) in
            if !isEqual(n1: origin, n2: child.position) {
                
                let dist0 = distanceBetween(n1: node.position, n2: child.position)
                if minDistanc>dist0 {
                    
                    minDistanc = dist0
                    nearestNode = child
                }
            }
        }
        stringPathMap["\(node.position)"] = ["\(nearestNode.position)"]
        poiNode.append("\(node.position)")
    }
    
}

extension ARLineViewController: ARSCNViewDelegate {
    private func setupSceneView() {
        print("WARNING setupSceneView")
        sceneView.frame = view.frame
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(rec:)))
        sceneView.addGestureRecognizer(tap)
        view.addSubview(sceneView)
    }
    
    func addPathNodes(n1:SCNVector3, n2:SCNVector3) {
        var node1Position = n1
        var node2Position = n2
        var isNode1exists = false
        var isNode2exists = false
//        rootPathNode.enumerateChildNodes({ (child, _) in
//
//            // To merge path node less than 0.5 meters
//            if !isEqual(n1: origin, n2: child.position) {
//
//                let dist0 = distanceBetween(n1: n1, n2: child.position)
//                let dist1 = distanceBetween(n1: n2, n2: child.position)
//                if(dist0 <= 0.5){
//                    node1Position = child.position
//                    isNode1exists = true
//                }
//                if(dist1 <= 0.5){
//                    node2Position = child.position
//                    isNode2exists = true
//                }
//            }
//        })
        print(node1Position)
        print(node2Position)
        addPathNodeWithConnectingNode(node1Position: node1Position, node2Positon: node2Position)
        mapNodesToStringDict(node1Positon: node1Position, node2Positon: node2Position, isNode1exists: isNode1exists, isNode2exists: isNode2exists)
        
        isNode1exists = false
        isNode2exists = false
    }
    
    func addPathNodeWithConnectingNode(node1Position:SCNVector3,node2Positon:SCNVector3) {
        
        let pathNode = SCNNode()
        let node = SCNNode(geometry: SCNSphere(radius: 0.05))
        let node2 = SCNNode(geometry: SCNSphere(radius: 0.05))
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        node2.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        node.position = node1Position
        node2.position = node2Positon
        pathNode.addChildNode(node)
        pathNode.addChildNode(node2)
        rootPathNode.addChildNode(pathNode)
        let connectingNode = SCNNode()
        rootConnectingNode.addChildNode(
            connectingNode.buildLineInTwoPointsWithRotation(
                from: node1Position,
                to: node2Positon,
                radius: 0.02,
                color: .cyan))
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        print("render 2")
        DispatchQueue.main.async {

            if let planeAnchor = anchor as? ARPlaneAnchor {
                let plane = self.dictPlanes[planeAnchor]
                plane?.updateWith(planeAnchor)
            }
            let hitTest = self.sceneView.hitTest(self.view.center, types: .existingPlaneUsingExtent)
            if self.tempNodeFlag && !hitTest.isEmpty {
                self.addTempNode(hitTestResult: hitTest.first!)
            }
            if self.poiFlag && !hitTest.isEmpty {
                self.addPointOfInterestNode(hitTestResult: hitTest.first!)
                self.poiFlag = false
            }
            guard let pointOfView = self.sceneView.pointOfView else { return }
            let transform = pointOfView.transform
            self.cameraLocation = SCNVector3(transform.m41, transform.m42, transform.m43)
        }
    }
    
    func addTempNode(hitTestResult:ARHitTestResult) {
        let node = SCNNode(geometry: SCNSphere(radius: 0.05))
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        let transform = hitTestResult.worldTransform
        let thirdColumn = transform.columns.3
        node.position = SCNVector3Make(thirdColumn.x, thirdColumn.y, thirdColumn.z)
        if counter == 0 {
            pathNodes[0] = node
            counter = 1
            self.sceneView.scene.rootNode.addChildNode(rootTempNode)
        } else {
            pathNodes[1] = node
            rootTempNode.addChildNode(node)
        }
    }
    
    func mapNodesToStringDict (node1Positon:SCNVector3,node2Positon:SCNVector3,
                               isNode1exists:Bool,isNode2exists:Bool ) {
        
        let position1String = "\(node1Positon)"
        let position2String = "\(node2Positon)"
        
        if isNode1exists {
            
            var arr = stringPathMap[position1String]
            arr?.append(position2String)
            stringPathMap[position1String] = arr
            
        } else { // Create new node
            stringPathMap[position1String] = [position2String]
        }
        if isNode2exists {
            
            var arr = stringPathMap[position2String]
            arr?.append(position1String)
            stringPathMap[position2String] = arr
            
        } else { // Create new node
            stringPathMap[position2String] = [position1String]
        }
    }
    
    func distanceBetween(n1:SCNVector3,n2:SCNVector3) -> Float {
        return ((n1.x-n2.x)*(n1.x-n2.x) + (n1.z-n2.z)*(n1.z-n2.z)).squareRoot()
    }
    
    func isEqual(n1:SCNVector3,n2:SCNVector3)-> Bool {
            if (n1.x == n2.x) && (n1.y == n2.y) && (n1.z == n2.z) {
                print("1 place pos: x = ", n1.x, "y = ", n1.x, "z = ", n1.z)
                print("12 place pos: x = ", n2.x, "y = ", n2.x, "z = ", n2.z)
                return true
            } else {
                print("2 place pos: x = ", n1.x, "y = ", n1.x, "z = ", n1.z)
                print("2 user place pos: x = ", n2.x, "y = ", n2.x, "z = ", n2.z)
                return false
            }
        }
    
    
}

extension SCNNode {
    
    private func normalizeVector(_ iv: SCNVector3) -> SCNVector3 {
        let length = sqrt(iv.x * iv.x + iv.y * iv.y + iv.z * iv.z)
        if length == 0 {
            return SCNVector3(0.0, 0.0, 0.0)
        }
        
        return SCNVector3( iv.x / length, iv.y / length, iv.z / length)
        
    }
    
}
