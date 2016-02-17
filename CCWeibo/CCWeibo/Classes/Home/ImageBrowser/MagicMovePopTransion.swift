//
//  MagicMovePopTransion.swift
//  MagicMove
//
//  Created by BourneWeng on 15/7/13.
//  Copyright (c) 2015年 Bourne. All rights reserved.
//

import UIKit

class MagicMovePopTransion: NSObject, UIViewControllerAnimatedTransitioning {
   
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.6
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let mainVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! MainTabBarController
        
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! ImageBrowserViewController
        let toVC = (mainVC.selectedViewController as! UINavigationController).topViewController as! HomeTableViewController
        let container = transitionContext.containerView()
        
        let fromImageView = (fromVC.imageCollectionView.visibleCells().last as! ImageBrowserCell).imageView
        
        let snapshotView = fromImageView.snapshotViewAfterScreenUpdates(false)
        snapshotView.frame = container!.convertRect(fromImageView.frame, fromView: fromImageView.superview!)
        fromImageView.hidden = true
        
        mainVC.view.frame = transitionContext.finalFrameForViewController(mainVC)
        mainVC.view.layoutIfNeeded()
        toVC.selectedImageCell!.imageView.hidden = true
        
        container!.insertSubview(mainVC.view, belowSubview: fromVC.view)
        container!.addSubview(snapshotView)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [], animations: {
            () -> Void in
            snapshotView.frame = container!.convertRect(toVC.selectedImageCell!.imageView.frame, fromView: toVC.selectedImageCell)
            fromVC.view.alpha = 0
            }) {
                (finish: Bool) -> Void in
                toVC.selectedImageCell!.imageView.hidden = false
                snapshotView.removeFromSuperview()
                fromImageView.hidden = false
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}
