//
//  MainTabBarController.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/2.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    var newPostView: NewPostTabView?

    override func viewDidLoad() {
        super.viewDidLoad()
        newPostView = NewPostTabView(frame: view.bounds)
        newPostView!.alpha = 0
        view.addSubview(newPostView!)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "newTextPost", name: NewPostNotifications.NewPostTextItemDidClick, object: nil)
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addComposeBtn()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private lazy var composeBtn: UIButton = {
        var btn = UIButton()
        // 前景图
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: .Normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: .Highlighted)
        // 背景图
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: .Normal)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: .Highlighted)
        btn.addTarget(self, action: "sendNewPost:", forControlEvents: .TouchUpInside)
        return btn
        
    }()
    // MARK: - 添加加号按钮
    private func addComposeBtn() {
        let width = UIScreen.mainScreen().bounds.size.width / CGFloat(childViewControllers.count)
        composeBtn.translatesAutoresizingMaskIntoConstraints = false
        tabBar.addSubview(composeBtn)
        let centerXConstraint = composeBtn.centerXAnchor.constraintEqualToAnchor(tabBar.centerXAnchor)
        let centerYConstraint = composeBtn.centerYAnchor.constraintEqualToAnchor(tabBar.centerYAnchor)
        let widthConstraint = composeBtn.widthAnchor.constraintEqualToConstant(width)
        let heightConstraint = composeBtn.heightAnchor.constraintEqualToConstant(49)
        NSLayoutConstraint.activateConstraints([centerXConstraint, centerYConstraint, widthConstraint, heightConstraint])
        view.layoutIfNeeded()
    }
    // MARK: - 展现发送新微博的选择视图
    func sendNewPost(sender: UIButton) {
        newPostView?.isReprensing = true
    }
    // MARK: - 模态展示新文字微博VC
    func newTextPost() {
        performSegueWithIdentifier("NewTextPostSegue", sender: nil)
    }

}
