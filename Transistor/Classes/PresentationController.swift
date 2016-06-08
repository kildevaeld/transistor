//
//  PresentationController.swift
//  Pods
//
//  Created by Rasmus Kildevaeld on 04/06/2016.
//
//

import UIKit

public struct PresentationConfig {
    var padding: UIEdgeInsets = UIEdgeInsetsZero
    var frame: CGRect? = nil
    var dimmed: Bool = true
}

class BasePresentationController: UIPresentationController {
    let doneFn: (() -> Void)
    var config: PresentationConfig
    
    init(presentedViewController: UIViewController, presentingViewController: UIViewController, config: PresentationConfig, done: () -> Void ) {
        self.config = config
        self.doneFn = done
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        // We don't want the presented view to fill the whole container view, so inset it's frame
        var frame = self.config.frame ?? self.containerView!.bounds
        
        if self.config.padding != UIEdgeInsetsZero {
            frame = UIEdgeInsetsInsetRect(frame, self.config.padding)
        }
        
        
        return frame
    }
    
    override func dismissalTransitionDidEnd(completed: Bool) {
        // If the dismissal completed, remove the dimming view
        if completed {
            self.doneFn()
            
        }
    }
    
    
}

class PresentationController: BasePresentationController {
    
    lazy var touchGesture : UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        return tap
    }()
    var _dimingView: UIView?
    var dimmingView: UIView {
        get {
            if _dimingView == nil {
                let view = UIView(frame: self.containerView!.bounds)
                view.backgroundColor = UIColor(white: 0.0, alpha: 0.8)
                view.alpha = 0
                _dimingView = view
            }
            return _dimingView!
        }
        set (view) {
            _dimingView = view
        }
    }
    
    override func presentationTransitionWillBegin() {
        // Add the dimming view and the presented view to the heirarchy
        self.touchGesture.addTarget(self, action: #selector(PresentationController.onBackgroundTouch(_:)))
        self.dimmingView.addGestureRecognizer(self.touchGesture)
        
        self.dimmingView.frame = self.containerView!.bounds
        self.containerView!.addSubview(self.dimmingView)
        self.containerView!.addSubview(self.presentedView()!)
        
        // Fade in the dimming view alongside the transition
        if let transitionCoordinator = self.presentingViewController.transitionCoordinator() {
            transitionCoordinator.animateAlongsideTransition({(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.dimmingView.alpha  = 1.0
                }, completion:nil)
        }
    }
    
    override func presentationTransitionDidEnd(completed: Bool)  {
        // If the presentation didn't complete, remove the dimming view
        if !completed {
            self.dimmingView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin()  {
        // Fade out the dimming view alongside the transition
        if let transitionCoordinator = self.presentingViewController.transitionCoordinator() {
            transitionCoordinator.animateAlongsideTransition({(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.dimmingView.alpha  = 0.0
                }, completion:nil)
        }
    }
    
    override func dismissalTransitionDidEnd(completed: Bool) {
        // If the dismissal completed, remove the dimming view
        if completed {
            //self.doneFn?()
            self.dimmingView.removeFromSuperview()
        }
    }
    
        
    
    // ---- UIContentContainer protocol methods
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator transitionCoordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: transitionCoordinator)
        
        transitionCoordinator.animateAlongsideTransition({(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.dimmingView.frame = self.containerView!.bounds
            }, completion:nil)
    }
    
    func onBackgroundTouch(sender: UIView) {
        self.presentingViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}