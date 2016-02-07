//
//  UserInfo.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/7.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import Foundation
class UserInfo: NSObject, NSCoding {
    /// 用户昵称
    var screenName: String
    /// 用户头像地址（大图），180×180像素
    var avatarLarge: String
    
    private static var currentUserInfo: UserInfo?
    
    private static let filePath: String = {
        return "userinfo.plist".cachesDir()
    }()
    
    init(screenName: String, avatarLarge: String) {
        self.screenName = screenName
        self.avatarLarge = avatarLarge
    }
    
    class func saveUserInfo(info: UserInfo) {
        NSKeyedArchiver.archiveRootObject(info, toFile: filePath)
        currentUserInfo = info
    }
    
    class func loadUserInfo() -> UserInfo? {
        guard currentUserInfo == nil else {
            return currentUserInfo
        }
        return NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? UserInfo
    }
    
    // MARK: - NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(screenName, forKey: "screenName")
        aCoder.encodeObject(avatarLarge, forKey: "avatarLarge")
    }
    required init?(coder aDecoder: NSCoder) {
        screenName = aDecoder.decodeObjectForKey("screenName") as! String
        avatarLarge = aDecoder.decodeObjectForKey("avatarLarge") as! String
    }
}