//
//  Pegasus.swift
//  Pegasus
//
//  Created by Lasha Efremidze on 5/12/17.
//  Copyright © 2017 efremidze. All rights reserved.
//

import UIKit

public protocol PegasusAnimationProtocol {
    func transition(using transitionContext: UIViewControllerContextTransitioning, container: UIView, viewControllers: (from: UIViewController, to: UIViewController), views: (from: UIView, to: UIView), isPresenting: Bool, duration: TimeInterval, completion: @escaping () -> ())
    var interactionController: UIPercentDrivenInteractiveTransition? { get set }
}

open class PegasusAnimation: NSObject, PegasusAnimationProtocol {
    open func transition(using transitionContext: UIViewControllerContextTransitioning, container: UIView, viewControllers: (from: UIViewController, to: UIViewController), views: (from: UIView, to: UIView), isPresenting: Bool, duration: TimeInterval, completion: @escaping () -> ()) { completion() }
    open var interactionController: UIPercentDrivenInteractiveTransition?
}

final public class Pegasus: NSObject {
    
    fileprivate let transitionAnimation: PegasusAnimationProtocol
    fileprivate(set) public var isPresenting = false
    public var duration: TimeInterval = 0.3
    
    public init(transitionAnimation: PegasusAnimationProtocol) {
        self.transitionAnimation = transitionAnimation
    }
    
}

// MARK: - UIViewControllerAnimatedTransitioning
extension Pegasus: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let viewControllers: (from: UIViewController, to: UIViewController) = (transitionContext.viewController(forKey: .from)!, transitionContext.viewController(forKey: .to)!)
        let views: (from: UIView, to: UIView) = (transitionContext.view(forKey: .from) ?? viewControllers.from.view, transitionContext.view(forKey: .to) ?? viewControllers.to.view)
        transitionAnimation.transition(using: transitionContext, container: container, viewControllers: viewControllers, views: views, isPresenting: isPresenting, duration: duration) {
            let cancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!cancelled)
            
            if !cancelled && !UIApplication.shared.keyWindow!.subviews.contains(views.to) {
                UIApplication.shared.keyWindow!.addSubview(views.to)
            }
        }
    }
    
}

// MARK: - UIViewControllerTransitioningDelegate
extension Pegasus: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        isPresenting = true
        return transitionAnimation.interactionController
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        isPresenting = false
        return transitionAnimation.interactionController
    }
    
}

// MARK: - UINavigationControllerDelegate
extension Pegasus: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return transitionAnimation.interactionController
    }
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = (operation == .push)
        return self
    }
    
}
