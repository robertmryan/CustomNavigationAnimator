//
//  CustomNavigationDelegate.swift
//  CustomPushNavigation
//
//  Created by Robert Ryan on 12/19/18.
//  Copyright © 2018 Robert Ryan. All rights reserved.
//

import UIKit

/// Custom navigation controller delegate for interactive push transitions

class CustomNavigationDelegate: NSObject, UINavigationControllerDelegate {
    
    var interactionController: UIPercentDrivenInteractiveTransition?
    var current: UIViewController?
    var pushDestination: (() -> UIViewController?)?
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomNavigationAnimator(transitionType: operation)
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        current = viewController
    }
}

extension CustomNavigationDelegate {
    func addPushInteractionController(to view: UIView) {
        let swipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handlePushGesture(_:)))
        swipe.edges = [.right]
        view.addGestureRecognizer(swipe)
    }
    
    @objc private func handlePushGesture(_ gesture: UIScreenEdgePanGestureRecognizer) {
        guard let pushDestination = pushDestination else { return }
        
        let position = gesture.translation(in: gesture.view)
        let percentComplete = min(-position.x / gesture.view!.bounds.width, 1.0)
        
        switch gesture.state {
        case .began:
            interactionController = UIPercentDrivenInteractiveTransition()
            guard let controller = pushDestination() else { fatalError("No push destination") }
            current?.navigationController?.pushViewController(controller, animated: true)
            
        case .changed:
            interactionController?.update(percentComplete)
            
        case .ended, .cancelled:
            let speed = gesture.velocity(in: gesture.view)
            if speed.x < 0 || (speed.x == 0 && percentComplete > 0.5) {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            interactionController = nil
            
        default:
            break
        }
    }
}

extension CustomNavigationDelegate {
    func addPopInteractionController(to view: UIView) {
        let swipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handlePopGesture(_:)))
        swipe.edges = [.left]
        view.addGestureRecognizer(swipe)
    }
    
    @objc private func handlePopGesture(_ gesture: UIScreenEdgePanGestureRecognizer) {
        let position = gesture.translation(in: gesture.view)
        let percentComplete = min(position.x / gesture.view!.bounds.width, 1)
        
        switch gesture.state {
        case .began:
            interactionController = UIPercentDrivenInteractiveTransition()
            current?.navigationController?.popViewController(animated: true)
            
        case .changed:
            interactionController?.update(percentComplete)
            
        case .ended, .cancelled:
            let speed = gesture.velocity(in: gesture.view)
            if speed.x > 0 || (speed.x == 0 && percentComplete > 0.5) {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            interactionController = nil
            
            
        default:
            break
        }
    }
}
