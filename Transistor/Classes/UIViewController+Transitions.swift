//
//  UIViewController+Transitions.swift
//  Pods
//
//  Created by Rasmus Kildevaeld on 04/06/2016.
//
//

import UIKit

public class TransistorSegue : UIStoryboardSegue {
    public var padding: UIEdgeInsets {
        set (value) {
            config.padding = value
        }
        get {
            return config.padding
        }
    }
    
    public var dimmed: Bool {
        set (value) {
            config.dimmed = value
        }
        get {
            return config.dimmed
        }
    }
    
    public var destinationFrame: CGRect? {
        set (value) {
            config.frame = value
        } get {
            return config.frame
        }
    }
    
    public var animator: BasePresentationAnimationController?
    
    var config = PresentationConfig()
    
    public override func perform () {
        
        sourceViewController.presentViewController(self.animator, viewController: destinationViewController, config: config, completion: nil)
        
        
    }
}


public class SlideUpSegue : TransistorSegue {
   
    public var height: CGFloat?
    
    public override func perform() {
        
    
        let animator = SlideUpAnimationController()

        var frame = sourceViewController.view.frame
        
        frame.size.height = frame.size.height * 0.44
        if height != nil {
            frame.size.height = height!
        }
        
        config.frame = frame;
        
        
        sourceViewController.presentViewController(animator, viewController: destinationViewController, config: config, completion: nil)
    }
}

extension UIViewController {
    struct Delegates {
        static var delegates: Dictionary<UIViewController, TransitionDelegate> = Dictionary<UIViewController, TransitionDelegate>()
        static func delegate (viewController:UIViewController) -> TransitionDelegate {
            if let del = self.delegates[viewController] {
                return del
            }
            
            let del = TransitionDelegate {
                self.remove(viewController)
            }
            self.delegates[viewController] = del
            
            return del
        }
        
        static func remove (viewController:UIViewController) {
            self.delegates.removeValueForKey(viewController)
        }
    }
    
    public static func getTransitionDelegate (viewController: UIViewController) -> TransitionDelegate {
        return Delegates.delegate(viewController)
    }
    
    public static func removeTransitionDelegate (viewController: UIViewController) {
        Delegates.remove(viewController)
    }
    
    public func presentViewController(viewController:UIViewController, completion:(() -> Void)?) {
        
        viewController.transitioningDelegate = Delegates.delegate(self)
        viewController.modalPresentationStyle = .Custom
        
        self.presentViewController(viewController, animated: true) { () -> Void in
            completion?()
        }
    }
    
    
    public func presentViewController<T: BasePresentationAnimationController>(animator:T?, viewController: UIViewController, config: PresentationConfig = PresentationConfig(), completion: (() -> Void)? = nil) {
        
        let delegate = Delegates.delegate(self)
        
        delegate.animator = animator ?? BasePresentationAnimationController()
        delegate.config = config
        
        viewController.transitioningDelegate = delegate
        viewController.modalPresentationStyle = .Custom
        
        self.presentViewController(viewController, animated: true) { () -> Void in
            completion?()
        }

        
        
    }
}
