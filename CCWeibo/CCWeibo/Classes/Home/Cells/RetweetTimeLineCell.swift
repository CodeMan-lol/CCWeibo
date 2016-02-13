//
//  RetweetTimeLineCell.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/13.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit

class RetweetTimeLineCell: TimeLineCell {

    
    @IBOutlet weak var retweetContentLabel: UILabel!
    @IBAction func retweetContentClick(sender: UIButton) {
    }
    
    override func setupUI() {
        super.setupUI()
        let retweetStatus = status?.retweeted_status
        retweetContentLabel.text = "@\(retweetStatus!.user!.name!):\(retweetStatus!.text!)"
    }

}
