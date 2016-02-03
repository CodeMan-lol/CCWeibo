//
//  VisitorView.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/3.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit

protocol VisitorViewDelegate: class {
    func loginBtnDidClick()
    func registerBtnDidClick()
}

class VisitorView: UIView {

    @IBOutlet weak var circleView: UIImageView!
    @IBOutlet weak var homeIconView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var btnStackView: UIStackView!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBAction func registerClick(sender: UIButton) {
        delegate?.registerBtnDidClick()
    }
    
    @IBAction func loginClick(sender: UIButton) {
        delegate?.loginBtnDidClick()
    }
    weak var delegate: VisitorViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "VisitorView", bundle: bundle)
        let view: UIView = nib.instantiateWithOwner(self, options: nil).first as! UIView
        view.frame = bounds
        addSubview(view)
    }
    
    func setupViews(isHome: Bool, iconName: String, info: String) {
        circleView.hidden = !isHome
        if isHome {
            btnStackView.removeArrangedSubview(registerBtn)
            loginBtn.setTitleColor(UIColor.orangeColor(), forState: .Normal)
            loginBtn.setTitle("去关注", forState: .Normal)
            animateCircleView()
        } else {
            btnStackView.insertArrangedSubview(loginBtn, atIndex: 1)
            loginBtn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            loginBtn.setTitle("登录", forState: .Normal)
        }
        homeIconView.image = UIImage(named: iconName)
        infoLabel.text = info
    }
    
    private func animateCircleView() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = M_PI * 2
        rotateAnimation.duration = 10
        rotateAnimation.repeatCount = HUGE
        rotateAnimation.removedOnCompletion = false
        circleView.layer.addAnimation(rotateAnimation, forKey: nil)
    }

}
