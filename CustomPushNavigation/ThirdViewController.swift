//
//  ThirdViewController.swift
//  CustomPushNavigation
//
//  Created by Robert Ryan on 12/19/18.
//  Copyright © 2018 Robert Ryan. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    
    var navigationDelegate: CustomNavigationDelegate { return navigationController!.delegate as! CustomNavigationDelegate }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationDelegate.addPopInteractionController(to: view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationDelegate.pushDestination = nil
    }
    
}
