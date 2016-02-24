//
//  EmoticonGroupInfo.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/23.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit

class EmoticonGroupInfo: NSObject {
    var id: String?
    var version: Int = 0
    var group_name_cn: String?
    var group_name_tw: String?
    var group_name_en: String?
    var display_only: Int = 0
    var group_type: Int = 0
    var emoticons: [EmoticonInfo]?
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forKey key: String) {
        if key == "emoticons" {
            emoticons = [EmoticonInfo]()
            for (index,dict) in (value as! [[String: AnyObject]]).enumerate() {
                emoticons?.append(EmoticonInfo(dict: dict))
                // 每页最后一个为删除按钮
                if (index+1) % 20 == 0 {
                    emoticons?.append(EmoticonInfo(isDeleteBtn: true))
                }
            }
            let lastPageCount = emoticons!.count % 21
            // 补充空白按钮
            if lastPageCount != 0 {
                let emptyBtnCount = 21 - lastPageCount - 1
                for _ in 0..<emptyBtnCount {
                    emoticons?.append(EmoticonInfo(isDeleteBtn: false))
                }
                emoticons?.append(EmoticonInfo(isDeleteBtn: true))
            }
        } else {
            super.setValue(value, forKey: key)
        }
    }
}
