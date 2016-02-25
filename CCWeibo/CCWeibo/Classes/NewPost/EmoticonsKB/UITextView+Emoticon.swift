//
//  UITextView+Emoticon.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/25.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit
extension UITextView {
    func insertEmoticon(emoticon: EmoticonInfo, emoticonSize: CGFloat) {
        let attributedText = NSMutableAttributedString(attributedString: self.attributedText)
        let range  = self.selectedRange
        // 创建图文属性文本
        let imageText = EmoticonAttachment.createEmoticonAttachmentString(emoticon, size: emoticonSize)
        // 在光标处插入图文属性文本
        attributedText.replaceCharactersInRange(range, withAttributedString: imageText)
        // 还原输入图文属性文本之前属性文本的大小尺寸
        attributedText.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(14)], range: NSRange(location: range.location, length: 1))
        // 替换原有的属性文本
        self.attributedText = attributedText
        // 移动光标
        self.selectedRange = NSRange(location: range.location+1, length: 0)
    }
    
    var weiboText: String {
        var weiboText = ""
        self.attributedText.enumerateAttributesInRange(NSRange(location: 0, length: self.attributedText.length), options: []) { (dict, range, _) in
            if let attachment = dict["NSAttachment"] as? EmoticonAttachment {
                weiboText += attachment.chs!
            } else {
                print(range)
                weiboText += (self.text as NSString).substringWithRange(range)
            }
        }
        return weiboText
    }
}