//
//  PopoverSegue.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/4.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit

class PopoverSegue: UIStoryboardSegue {
    /// 预定义 **pop** 弹窗的大小
    var preferredPopFrame: CGRect?
    override func perform() {
        destinationViewController.transitioningDelegate = self
        destinationViewController.modalPresentationStyle = .Custom
        super.perform()
    }

}

extension PopoverSegue: UIViewControllerTransitioningDelegate {

    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        let ppc = PopoverPresentationController(presentedViewController: presented, presentingViewController: presenting)
        if let preferredPopFrame = preferredPopFrame {
            ppc.preferredPopFrame = preferredPopFrame
        }
        return ppc
    }
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        NSNotificationCenter.defaultCenter().postNotificationName(HomeNotifications.TitleViewWillShow, object: self)
        return SlideDownAnimator()
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        NSNotificationCenter.defaultCenter().postNotificationName(HomeNotifications.TitleViewWillHide, object: self)
        return SlideUpAnimator()
    }
}

// MARK: - 下拉动画
private class SlideDownAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration: NSTimeInterval = 0.5
    @objc func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    @objc func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        toView.transform = CGAffineTransformMakeScale(1, 0)
        toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        containerView.addSubview(toView)
        UIView.animateWithDuration(duration, animations: {
            toView.transform = CGAffineTransformIdentity
        }) { _ in
            transitionContext.completeTransition(true)
        }
    }
}

// MARK: - 回缩动画
private class SlideUpAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration: NSTimeInterval = 0.2
    @objc func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    @objc func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!

        fromView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        UIView.animateWithDuration(duration, animations: {
            //由于CGFloat的不准确性，y不能直接写0
            fromView.transform = CGAffineTransformMakeScale(1, 0.000001)
        }) { _ in
            transitionContext.completeTransition(true)
        }
    }
}