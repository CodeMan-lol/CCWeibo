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
    var created_at: String? {
        didSet {
        guard let createdAt = created_at where createdAt != "" else { return }
        created_at = NSDate.dateFromeWeiboDateStr(createdAt).weiboDescriptionDate()
        }
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
    var pic_urls: [[String: AnyObject]] = [] {
        didSet {
        if pic_urls.count > 0 {
            thumbnailURLs = []
            for dict in pic_urls {
                if let URLStr = dict["thumbnail_pic"] as? String {
                    thumbnailURLs!.append(NSURL(string: URLStr)!)
                }
            }
        }
        }
    }
    // 原创微博缩略图或者转发微博缩略图的url数组
    var thumbnailURLs: [NSURL]?
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
            cacheAllThumbnail(statuses, completion: completion)
        }
    }
    /// 缓存所有缩略图
    private class func cacheAllThumbnail(statuses: [Status], completion: (statuses: [Status])->()) {
        if statuses.count == 0 {
            completion(statuses: statuses)
        }
        let group = dispatch_group_create()
        for status in statuses {
            if let URLs = status.thumbnailURLs {
                for thumbnailURL in URLs {
                    dispatch_group_enter(group)
                    KingfisherManager.sharedManager.downloader.downloadImageWithURL(thumbnailURL, progressBlock: nil) {
                        (image, error, imageURL, originalData) in
                        guard error == nil else {
                            print("缓存图片出错! 图片地址为: \(imageURL?.absoluteString)")
                            dispatch_group_leave(group)
                            return
                        }
                        KingfisherManager.sharedManager.cache.storeImage(image!, forKey: imageURL!.absoluteString, toDisk: true) {
                            dispatch_group_leave(group)
                        }
                    }
                }
            }
        }
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            completion(statuses: statuses)
        }
    }
    
//    private class func testKingfisherGif() {
//        let URLs: [NSURL] = [NSURL(string: "http://ww3.sinaimg.cn/thumbnail/62037b5agw1f0vw2yxnqxg209v0587wm.gif")!]
//        for thumbnailURL in URLs {
//            KingfisherManager.sharedManager.downloader.downloadImageWithURL(thumbnailURL, progressBlock: nil) {
//                (image, error, imageURL, originalData) in
//                guard error == nil else {
//                    print("缓存图片出错! 图片地址为: \(imageURL?.absoluteString)")
//                    return
//                }
//            }
//        }
//    }
}
