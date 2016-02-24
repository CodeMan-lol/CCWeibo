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
        // 目标vc为tabvc
        let mainVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! MainTabBarController
        
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! ImageBrowserViewController
        // 获取目标tableviewVC
        let toVC = (mainVC.selectedViewController as! UINavigationController).topViewController as! HomeTableViewController
        let container = transitionContext.containerView()
        // 源imageview
        let fromImageView = (fromVC.imageCollectionView.visibleCells().last as! ImageBrowserCell).imageView
        // 配置目标tableviewVC
        let toIndex = fromVC.imageCollectionView.indexPathForCell(fromVC.imageCollectionView.visibleCells().last!)!
        let toCell = toVC.selectedImageCollection?.cellForItemAtIndexPath(toIndex) as! PictureCollectionViewCell
        toVC.selectedImageCell = toCell
        toVC.selectedImageCell!.imageView.hidden = true
        // 利用新建imageview来进行遮罩
        let snapshotImage = toVC.selectedImageCell!.imageView.image
        let snapshotView = UIImageView(image: snapshotImage)
        snapshotView.contentMode = .ScaleAspectFill
        snapshotView.clipsToBounds = true
        snapshotView.frame = container!.convertRect(fromImageView.frame, fromView: fromImageView.superview!)

        fromImageView.hidden = true
        
        mainVC.view.frame = transitionContext.finalFrameForViewController(mainVC)
        mainVC.view.layoutIfNeeded()
        
        container!.insertSubview(mainVC.view, belowSubview: fromVC.view)
        container!.addSubview(snapshotView)
        
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [], animations: {
            () -> Void in
            snapshotView.frame = container!.convertRect(toCell.imageView.frame, fromView: toCell)
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
