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
        return 0.6
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let mainVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! MainTabBarController
        
        let fromVC = (mainVC.selectedViewController as! UINavigationController).topViewController as! HomeTableViewController
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! ImageBrowserViewController
        let container = transitionContext.containerView()
        
        let snapshotView = UIImageView(image: fromVC.selectedImageCell?.imageView.image)
        snapshotView.contentMode = .ScaleAspectFill
        snapshotView.clipsToBounds = true
        snapshotView.frame = container!.convertRect(fromVC.selectedImageCell!.imageView.frame, fromView: fromVC.selectedImageCell!)
        fromVC.selectedImageCell!.imageView.hidden = true
        
        toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
        toVC.view.alpha = 0
        
        container!.addSubview(toVC.view)
        container!.addSubview(snapshotView)
        
        // 不强制更新布局的话不会有cell出来
        toVC.view.layoutIfNeeded()
        
        // 此处因为collectionView还只有一个复用的cell，因此要实例化的indexpath为 (0, 0)
        let toCell = toVC.imageCollectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as! ImageBrowserCell
        toCell.imageURL = toVC.imageURLs![toVC.currentIndex!]
        toCell.imageView.hidden = true
        // 目标VC的cell里的图片的frame
        let toFrame = toCell.convertRect(toCell.imageView.frame, fromView: toCell.imageScrollView)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [], animations: {
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
