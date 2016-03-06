//
//  CategoryPresentationAnimationController.swift
//  Moments
//
//  Created by Yuning Xue on 2016-03-06.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit


class CategoryPresentationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration: NSTimeInterval = 0.6
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView()!
        
        if let presentedView = transitionContext.viewForKey(UITransitionContextToViewKey) {
            
            let centre = presentedView.center
            presentedView.center = CGPointMake(centre.x, -presentedView.bounds.size.height)
            containerView.addSubview(presentedView)
            
            UIView.animateWithDuration(duration,
                delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 8.0, options: [],
                animations: {
                    presentedView.center = centre
                }, completion: {
                    _ in
                    transitionContext.completeTransition(true)
            })
        }
    }
    
}
