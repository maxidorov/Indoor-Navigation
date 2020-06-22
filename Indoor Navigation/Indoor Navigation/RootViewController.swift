//
//  File.swift
//  Indoor Navigation
//
//  Created by Maxim Sidorov & Dmitriy Zhbannikov on 10.04.2020.
//  Copyright © 2020 Maxim Sidorov & Dmitriy Zhbannikov. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    var current: UIViewController
    
    init() {
        
        let locationsViewController = UINavigationController(rootViewController: LocationsViewController())
        self.current = locationsViewController
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParent: self)
    }
}
