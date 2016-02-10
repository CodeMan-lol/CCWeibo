//
//  User.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/10.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit

class User: NSObject {
    var id: Int = 1
    var name: String?
    var avatar_large: String?
    var verified: Bool = false
    /// 认证类型: -1没有认证，0认证用户，2、3、5企业认证，220微博达人
    var verified_type: Int = 1
    
    
    /// 展示内容
    var avatarURL: NSURL {
        return NSURL(string: avatar_large!)!
    }
    var verifiedIcon: UIImage? {
        switch verified_type {
        case 0: return UIImage(named: "avatar_vip")
        case 2,3,5: return UIImage(named: "avatar_enterprise_vip")
        case 220: return UIImage(named: "avatar_grassroot")
        default: return nil
        }
    }
    
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
