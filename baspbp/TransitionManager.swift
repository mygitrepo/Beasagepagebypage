//
//  TransitionManager.swift
//  baspbp-final
//
//  Created by nikul on 8/10/16.
//  Copyright © 2016 isv. All rights reserved.
//

import UIKit
    
class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
    
    // For reverse transitioning to remember which controller we came from - from left to right
    fileprivate var presenting = true
    
    // MARK: UIViewControllerAnimatedTransitioning protocol methods
    
    // animate a change from one viewcontroller to another
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // get reference to our fromView, toView and the container view that we should perform the transition in
        let container = transitionContext.containerView
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        // set up from 2D transforms that we'll use in the animation
        let offScreenRight = CGAffineTransform(translationX: container.frame.width, y: 0)
        let offScreenLeft = CGAffineTransform(translationX: -container.frame.width, y: 0)
        
        // Prepare the toView for the animation
        if (self.presenting){
            toView.transform = offScreenRight
        } else {
            toView.transform = offScreenLeft
        }
        
        // start the toView to the right of the screen - this is just for one way transition
        //toView.transform = offScreenRight
        
        // add the both views to our view controller
        container.addSubview(toView)
        container.addSubview(fromView)
        
        // get the duration of the animation
        // DON'T just type '0.5s' -- the reason why won't make sense until the next post
        // but for now it's important to just follow this approach
        let duration = self.transitionDuration(using: transitionContext)
        
        // perform the animation!
        // for this example, just slid both fromView and toView to the left at the same time
        // meaning fromView is pushed off the screen and toView slides into view
        // we also use the block animation usingSpringWithDamping for a little bounce
        //UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [], animations: {
        UIView.animate(withDuration: duration, delay: 0.0, options: [], animations: {
            
            //fromView.transform = offScreenLeft - this for just one way transition
            
            // slide fromView off either the left or right edge of the screen
            // depending if we're presenting or dismissing this view
            if (self.presenting){
                fromView.transform = offScreenLeft
            } else {
                fromView.transform = offScreenRight
            }
            
            toView.transform = CGAffineTransform.identity
            
            }, completion: { finished in
                
                // tell our transitionContext object that we've finished animating
                transitionContext.completeTransition(true)
                
        })
    }
    
        // return how many seconds the transiton animation will take
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.5
        }
        
        // MARK: UIViewControllerTransitioningDelegate protocol methods
        
        // return the animataor when presenting a viewcontroller
        // remmeber that an animator (or animation controller) is any object that aheres to the UIViewControllerAnimatedTransitioning protocol
        func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            
            // For two way transition
            // these methods are the perfect place to set our `presenting` flag to either true or false - voila!
            self.presenting = true
            return self
        }
        
        // return the animator used when dismissing from a viewcontroller
        func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            // For two way transition
            // these methods are the perfect place to set our `presenting` flag to either true or false - voila!
            self.presenting = false
            return self
        }
        
}
