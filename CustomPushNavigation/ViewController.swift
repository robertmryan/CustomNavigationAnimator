//
//  ViewController.swift
//  CustomPushNavigation
//
//  Created by Robert Ryan on 12/19/18.
//  Copyright © 2018 Robert Ryan. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    let navigationDelegate = CustomNavigationDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = navigationDelegate
        navigationDelegate.addPushInteractionController(to: view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationDelegate.pushDestination = { [weak self] in
            self?.storyboard?.instantiateViewController(withIdentifier: "Second")
        }
    }
}
