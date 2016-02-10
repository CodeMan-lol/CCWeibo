//
//  Status.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/10.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Status: NSObject {
    var created_at: String?
    var id: Int = 1
    var text: String?
    var source: String?
    var pic_urls: [[String: AnyObject]]?
    var user: User?
    
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forKey key: String) {
        if key == "user" {
            user = User(dict: value as! [String: AnyObject])
            return
        }
        super.setValue(value, forKey: key)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    class func loadStatuses(completion: (statuses: [Status])->()) {
        Alamofire.request(WBRouter.FetchNewWeibo(accessToken: UserAccount.loadAccount()!.accessToken, count: nil, page: nil)).responseJSON { response in
            guard response.result.error == nil, let data = response.result.value else {
                
                return
            }
            let json = JSON(data)["statuses"]
            var statuses = [Status]()
            for (_,subJson):(String, JSON) in json {
                let statusDict = subJson.dictionaryObject!
                let status = Status(dict: statusDict)
                statuses.append(status)
            }
            completion(statuses: statuses)
        }
    }
}
