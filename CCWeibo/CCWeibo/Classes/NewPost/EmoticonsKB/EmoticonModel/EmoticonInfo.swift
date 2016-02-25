//
//  EmoticonInfo.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/23.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit

class EmoticonInfo: NSObject {
    var id: String?
    var chs: String?
    var cht: String?
    var gif: String?
    var png: String?
    var type: String?
    var code: String?
    // 为nil则表示不是空白或者删除按钮
    var isDeleteBtn: Bool?
    
    init(isDeleteBtn: Bool) {
        self.isDeleteBtn = isDeleteBtn
    }
    init(dict: [String: AnyObject], id: String) {
        super.init()
        self.id = id
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
