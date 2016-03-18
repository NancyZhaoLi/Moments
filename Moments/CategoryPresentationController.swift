//
//  CategoryPresentationController.swift
//  Moments
//
//  Created by Yuning Xue on 2016-03-06.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit


class CategoryPresentationController: UIPresentationController {
    
    let dimmingView = UIView()
    
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
    }
    
    override func presentationTransitionWillBegin() {
        
        if let containerView = containerView {
            
            dimmingView.frame = containerView.bounds
            dimmingView.alpha = 0.0

            containerView.insertSubview(dimmingView, atIndex: 0)
        }
        
        if let transitionCoord = presentedViewController.transitionCoordinator() {
            transitionCoord.animateAlongsideTransition({
                context in
                self.dimmingView.alpha = 1.0
                }, completion: nil)

        }

    }
    
    override func dismissalTransitionWillBegin() {
        
        if let transitionCoord = presentedViewController.transitionCoordinator() {
            transitionCoord.animateAlongsideTransition({
                context in
                self.dimmingView.alpha = 0.0
                }, completion: {
                    context in
                    self.dimmingView.removeFromSuperview()
            })

        }
        
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        
        if let containerView = containerView {
            
            return containerView.bounds.insetBy(dx: 20, dy: 20)
        }
        return CGRect()
    }
    
    override func containerViewWillLayoutSubviews() {
        
        if let containerView = containerView {
            
            dimmingView.frame = containerView.bounds
            
            if let presentedView = presentedView() {
                
                presentedView.frame = frameOfPresentedViewInContainerView()
            }
        }
        
    }

}

