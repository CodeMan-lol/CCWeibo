//
//  UILabel+Extension.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/12.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit


extension UILabel {
    
    /// 快速创建一个UILabel
    class func createLabel(color: UIColor, fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.textColor = color
        label.font = UIFont.systemFontOfSize(fontSize)
        return label
    }
}
