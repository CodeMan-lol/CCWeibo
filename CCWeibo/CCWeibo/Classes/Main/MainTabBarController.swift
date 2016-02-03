//
//  MainTabBarController.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/2.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        //前景图
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: .Normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: .Highlighted)
        //背景图
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: .Normal)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: .Highlighted)
        return btn
        
    }()
    //MARK: - 添加加号按钮
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
