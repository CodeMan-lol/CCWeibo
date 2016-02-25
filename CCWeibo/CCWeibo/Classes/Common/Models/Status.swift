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
import Kingfisher

class Status: NSObject {
    var created_at: String?
    var createTimeFoTimeLabel: String {
        guard let createdAt = created_at where createdAt != "" else { return "" }
        return NSDate.dateFromeWeiboDateStr(createdAt).weiboDescriptionDate()
    }
    var id: Int = 1
    var text: String?
    var source: String? {
        didSet {
        guard let str = source where str != "" else { return }
        let startIndex = str.characters.indexOf(">")
        let subStr = str.substringFromIndex(startIndex!.advancedBy(1))
        let endIndex = subStr.characters.indexOf("<")
        source = subStr.substringToIndex(endIndex!)
        }
    }
    var reposts_count = 0
    var comments_count = 0
    var pic_urls: [[String: AnyObject]] = [] {
        didSet {
        if pic_urls.count > 0 {
            thumbnailURLs = [[],[],[]]
            for dict in pic_urls {
                if let URLStr = dict["thumbnail_pic"] as? String {
                    // 大图
                    let bigURL = URLStr.stringByReplacingOccurrencesOfString("thumbnail", withString: "bmiddle")
                    // 原图
                    let originURL = URLStr.stringByReplacingOccurrencesOfString("thumbnail", withString: "large")
                    thumbnailURLs![0].append(NSURL(string: URLStr)!)
                    thumbnailURLs![1].append(NSURL(string: bigURL)!)
                    thumbnailURLs![2].append(NSURL(string: originURL)!)
                }
            }
        }
        }
    }
    // 原创微博缩略图或者转发微博图集的url数组，0:缩略图，1:大图，2:原图
    var thumbnailURLs: [[NSURL]]?
    var user: User?
    var retweeted_status: Status? {
        didSet {
        if let URLs = retweeted_status?.thumbnailURLs {
            thumbnailURLs = URLs
        }
        }
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forKey key: String) {
        if key == "user" {
            user = User(dict: value as! [String: AnyObject])
            return
        }
        if key == "retweeted_status" {
            retweeted_status = Status(dict: value as! [String: AnyObject])
            return
        }
        super.setValue(value, forKey: key)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    /// 加载最近的微博数据
    class func loadStatuses(sinceId: Int?, maxId: Int?, completion: (statuses: [Status])->()) {
        Alamofire.request(WBRouter.FetchNewWeibo(accessToken: UserAccount.loadAccount()!.accessToken, sinceId: sinceId, maxId: maxId)).responseJSON { response in
            guard response.result.error == nil, let data = response.result.value else {
                print(response.result)
                completion(statuses: [])
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
