//
//  PopoverPresentationController.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/4.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit

class PopoverPresentationController: UIPresentationController {
    var preferredPopFrame: CGRect = CGRectZero
    override func containerViewWillLayoutSubviews() {
        // 1.修改弹出视图的大小
        if preferredPopFrame == CGRectZero {
            preferredPopFrame = CGRect(x: containerView!.bounds.midX - 100, y: 56, width: 200, height: 200)
        }
        presentedView()?.frame = preferredPopFrame
        // 2.在容器视图上添加一个蒙版, 插入到展现视图的下面
        containerView?.insertSubview(coverView, atIndex: 0)
    }
    // MARK: - 懒加载 蒙板
    private lazy var coverView: UIView = {
        // 1.创建view
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        view.frame = UIScreen.mainScreen().bounds
        
        // 2.添加监听
        let tap = UITapGestureRecognizer(target: self, action: "close")
        view.addGestureRecognizer(tap)
        return view
    }()
    
    func close() {
        // presentedViewController拿到当前弹出的控制器
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }

}
