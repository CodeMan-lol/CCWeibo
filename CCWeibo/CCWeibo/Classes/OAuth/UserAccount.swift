//
//  UserAccount.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/7.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import Foundation
class UserAccount: NSObject, NSCoding {
    var accessToken: String = ""
    var expiresIn: Double = 0.0 {
        didSet {
            expriseIn_Date = NSDate(timeIntervalSinceNow: expiresIn)
        }
    }
    var uid: String = ""
    var expriseIn_Date: NSDate = NSDate()
    private static let filePath: String = {
        return "account.plist".cachesDir()
    }()
    private static var currentAccount: UserAccount?
    
    
    override init() {
        
    }
    
    /**
     静态方法：归档用户帐号
     
     - parameter account: 需要归档的帐号对象
     */
    class func saveAccount(account: UserAccount) {
        NSKeyedArchiver.archiveRootObject(account, toFile: filePath)
        currentAccount = account
    }
    
    /**
     静态方法：读取已有的用户帐号
     
     - returns: 返回的用户帐号对象，当用户token过期或者还未登录过时返回nil
     */
    class func loadAccount() -> UserAccount? {
        guard currentAccount == nil else { return currentAccount }
        if let existAccount = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? UserAccount {
            // 判断是否还未过期
            if !(existAccount.expriseIn_Date.compare(NSDate()) == NSComparisonResult.OrderedAscending) {
                currentAccount = existAccount
                return currentAccount
            }
        }
        return nil
    }
    
    
    // MARK: - NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(accessToken, forKey: "accessToken")
        aCoder.encodeObject(expiresIn, forKey: "expiresIn")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expriseIn_Date, forKey: "expreseIn_Date")
    }
    required init?(coder aDecoder: NSCoder) {
        accessToken = aDecoder.decodeObjectForKey("accessToken") as! String
        expiresIn = aDecoder.decodeObjectForKey("expiresIn") as! Double
        uid = aDecoder.decodeObjectForKey("uid") as! String
        expriseIn_Date = aDecoder.decodeObjectForKey("expreseIn_Date") as! NSDate
    }

}
