//
//  MagicMoveSegue.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/16.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit

class MagicMoveSegue: UIStoryboardSegue {
    override func perform() {
        destinationViewController.transitioningDelegate = self
        super.perform()
    }
}
extension MagicMoveSegue: UIViewControllerTransitioningDelegate {

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        NSNotificationCenter.defaultCenter().postNotificationName(HomeNotifications.TitleViewWillShow, object: self)
        return MagicMoveTransion()
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MagicMovePopTransion()
    }
}