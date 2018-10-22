//
//  AnotherCustomSegue.swift
//  Flipsy
//
//  Created by Dot on 27/01/2017.
//  Copyright © 2017 Dot. All rights reserved.
//

import UIKit

class SlideFromRightSegue: UIStoryboardSegue {
    
    override func perform() {
        let destination = self.destination
        destination.modalPresentationStyle = .custom
        destination.transitioningDelegate = self
        super.perform()
    }
}

extension SlideFromRightSegue: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return nil
    }
    
}

extension SlideFromRightSegue: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using context: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    func animateTransition(using context: UIViewControllerContextTransitioning) {

        let containerView = context.containerView
        
        if let destinationView = context.view(forKey: .to) {
            
            containerView.addSubview(destinationView)
            destinationView.transform = CGAffineTransform(translationX: destinationView.frame.size.width, y: 0)
            
            UIView.animate(withDuration: 0.25,
                           delay: 0.0,
                           options: UIViewAnimationOptions.curveEaseInOut,
                           animations: {
                            destinationView.transform = CGAffineTransform.identity
            }, completion: { finished in
                context.completeTransition(true)
            })
            
        } else if let sourceView = context.view(forKey: .from) {
            
            UIView.animate(withDuration: 0.25, animations: {
               sourceView.transform = CGAffineTransform(translationX: sourceView.frame.size.width, y: 0)
            }, completion: { _ in
                context.completeTransition(true)
            })
            
        }

    }
}
