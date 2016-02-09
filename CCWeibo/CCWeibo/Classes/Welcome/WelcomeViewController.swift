//
//  WelcomeViewController.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/9.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit
import Kingfisher

class WelcomeViewController: UIViewController {

    @IBOutlet weak var iconTopCons: NSLayoutConstraint!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        iconImageView.layer.cornerRadius = iconImageView.bounds.width / 2
        iconImageView.alpha = 0
        welcomeLabel.alpha = 0
        if let iconURLStr = UserInfo.loadUserInfo()?.avatarLarge {
            iconImageView.kf_setImageWithURL(NSURL(string: iconURLStr)!)
        }
    }

    override func viewDidAppear(animated: Bool) {
        iconTopCons.constant += view.bounds.height
        view.layoutIfNeeded()
        UIView.animateWithDuration(2, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 5, options: [], animations: {
            self.iconImageView.alpha = 1
            self.iconTopCons.constant -= self.view.bounds.height
            
            self.view.layoutIfNeeded()
        }) { _ in
            UIView.animateWithDuration(1, animations: { 
                self.welcomeLabel.alpha = 1
                }, completion: { _ in
                    self.performSegueWithIdentifier("WelcomeModalToMain", sender: self)
            })
        }
    }

}
