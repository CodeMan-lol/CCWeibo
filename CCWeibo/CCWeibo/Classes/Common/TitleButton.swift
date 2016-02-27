//
//  TitleButton.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/4.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit

@IBDesignable
class TitleButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.bounds.size.width
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
