//
//  CustomNavigationAnimator.swift
//  CustomPushNavigation
//
//  Created by Robert Ryan on 12/19/18.
//  Copyright © 2018 Robert Ryan. All rights reserved.
//

import UIKit

class CustomNavigationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let transitionType: UINavigationController.Operation
    
    init(transitionType: UINavigationController.Operation) {
        self.transitionType = transitionType
        super.init()
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let inView   = transitionContext.containerView
        let toView   = transitionContext.view(forKey: .to)!
        let fromView = transitionContext.view(forKey: .from)!
        
        var frame = inView.bounds
        
        switch transitionType {
        case .push:
            frame.origin.x = frame.size.width
            toView.frame = frame
            
            inView.addSubview(toView)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toView.frame = inView.bounds
            }, completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
            
        case .pop:
            toView.frame = frame
            inView.insertSubview(toView, belowSubview: fromView)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                frame.origin.x = frame.size.width
                fromView.frame = frame
            }, completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
            
        case .none:
            break
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
}
