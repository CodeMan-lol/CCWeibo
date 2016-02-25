//
//  UIImage+Scale.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/25.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit
extension UIImage {
    func createImageBy(scale: CGFloat) -> UIImage {
        
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        UIGraphicsBeginImageContext(newSize)
        self.drawInRect(CGRect(origin: CGPointZero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}