//
//  MagicMoveTransion.swift
//  MagicMove
//
//  Created by BourneWeng on 15/7/13.
//  Copyright (c) 2015年 Bourne. All rights reserved.
//

import UIKit

class MagicMoveTransion: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let mainVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! MainTabBarController
        
        let fromVC = (mainVC.selectedViewController as! UINavigationController).topViewController as! HomeTableViewController
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! ImageBrowserViewController
        let container = transitionContext.containerView()
        
        let snapshotView = fromVC.selectedImageCell!.imageView.snapshotViewAfterScreenUpdates(false)
        snapshotView.frame = container!.convertRect(fromVC.selectedImageCell!.imageView.frame, fromView: fromVC.selectedImageCell!)
        fromVC.selectedImageCell!.imageView.hidden = true
        fromVC.selectedImageCell!.imageView.contentMode = .ScaleAspectFill
        
        toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
        toVC.view.alpha = 0
        
        container!.addSubview(toVC.view)
        container!.addSubview(snapshotView)
        

        toVC.view.layoutIfNeeded()
        let toCell = toVC.imageCollectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as! ImageBrowserCell
        toCell.imageURL = toVC.imageURLs![0]
        toCell.layoutIfNeeded()
        toCell.imageView.hidden = true
        let toFrame = toCell.convertRect(toCell.imageView.frame, fromView: toCell.imageScrollView)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: 300, initialSpringVelocity: 30, options: [], animations: {
            snapshotView.frame = toFrame
            toVC.view.alpha = 1
        }) { (finished: Bool) in
            fromVC.selectedImageCell!.imageView.hidden = false
            toCell.imageView.hidden = false
            snapshotView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
