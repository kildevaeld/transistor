

import UIKit

public class TransitionDelegate : NSObject, UIViewControllerTransitioningDelegate {
    
    var animator: BasePresentationAnimationController
    var config: PresentationConfig = PresentationConfig()
    
    var doneFn : (() -> Void)?
    init (animator:BasePresentationAnimationController? = nil, fn: () -> Void) {
        self.doneFn = fn
        self.animator = animator ?? BasePresentationAnimationController()
    }
    
    public func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        
       
        
        var fn = self.doneFn
        if fn == nil {
            fn = {
                
            }
        }
        if self.config.dimmed {
            return PresentationController(presentedViewController: presented, presentingViewController: presenting, config:config,  done: fn!)
        } else {
            return BasePresentationController(presentedViewController: presented, presentingViewController: presenting, config: config, done: fn!)
        }
        
        
        
    }
    
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animator.isPresenting = true
        //if presented == self {
        return self.animator
        //}
        /*else {
         return nil
         }*/
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        //if dismissed == self {
        self.animator.isPresenting = false
        return self.animator
        //}
        //else {
        //   return nil
        //}
    }
}