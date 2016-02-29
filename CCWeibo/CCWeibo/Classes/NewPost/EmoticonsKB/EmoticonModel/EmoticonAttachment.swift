//
//  EmoticonAttachment.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/24.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit

class EmoticonAttachment: NSTextAttachment {
    var chs: String?
    class func createEmoticonAttachmentString(emoticon: EmoticonInfo, size: CGFloat) -> NSAttributedString? {
        // 图片附件

        if let image = "\(emoticon.id!)/\(emoticon.png!)".sinaEmoticon() {
            let attachment = EmoticonAttachment()
            attachment.chs = emoticon.chs
            attachment.image = image
            attachment.bounds = CGRect(x: 0, y: -3, width: 18, height: 18)
            // 创建图文属性文本
            let imageText = NSAttributedString(attachment: attachment)
            return imageText
        }
        return nil
    }
}
