//
//  BaseTableViewController.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/3.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    lazy var isLogin: Bool = {
        guard let account = UserAccount.loadAccount() else { return false }
        return true
    }()

    override func loadView() {
        isLogin ? super.loadView() : loadVisitorView()
    }
    
    private func loadVisitorView() {
        let visitorView = VisitorView(frame: UIScreen.mainScreen().bounds)
        view = visitorView
        visitorView.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .Plain, target: self, action: "registerBtnDidClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .Plain, target: self, action: "loginBtnDidClick")
        let titleLabel = UILabel()
        titleLabel.text = tabBarController!.tabBar.items![tabBarController!.selectedIndex].title!
        navigationItem.titleView = titleLabel
        titleLabel.sizeToFit()

    }
}
extension BaseTableViewController: VisitorViewDelegate {
    func loginBtnDidClick() {
        let oAuthSB = UIStoryboard(name: "OAuth", bundle: nil)
        let oAuthVC = oAuthSB.instantiateInitialViewController()
        self.presentViewController(oAuthVC!, animated: true, completion: nil)
    }
    func registerBtnDidClick() {
        print(__FUNCTION__)
    }
}