//
//  BaseTableViewController.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/3.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    var isLogin: Bool = true

    override func loadView() {
        isLogin ? super.loadView() : loadVisitorView()
    }
    
    private func loadVisitorView() {
        let visitorView = VisitorView(frame: UIScreen.mainScreen().bounds)
        view = visitorView
        visitorView.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .Plain, target: self, action: "registerBtnDidClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .Plain, target: self, action: "loginBtnDidClick")
    }
}
extension BaseTableViewController: VisitorViewDelegate {
    func loginBtnDidClick() {
        print(__FUNCTION__)
    }
    func registerBtnDidClick() {
        print(__FUNCTION__)
    }
}