//
//  WBRouter.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/6.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import Foundation
import Alamofire

enum WBRouter: URLRequestConvertible {
    static let baseURLString = "https://api.weibo.com/"
    /// oauth2/access_token: OAuth2的access_token接口
    case FetchAccessToken(code: String)
    /// statuses/friends_timeline: 获取当前登录用户及其所关注（授权）用户的最新微博
    case FetchNewWeibo(accessToken: String, count: Int?, page: Int?)
    /// 2/users/show.json: 根据用户ID获取用户信息
    case FetchUserInfo(accessToken: String, uid: String)
    
    
    
    
    // MARK: URLRequestConvertible
    var URLRequest: NSMutableURLRequest {
        let result: (path: String, parameters: [String: AnyObject], method: String) = {
            switch self {
            case .FetchAccessToken(let code):
                return ("oauth2/access_token", ["client_id":WBKeys.AppKey, "client_secret":WBKeys.AppSecret, "grant_type":WBKeys.GrantType, "code":code, "redirect_uri":WBKeys.RedirectURI], "POST")
            case .FetchNewWeibo(let accessToken, var count, var page):
                if count == nil {
                    count = 20
                }
                if page == nil {
                    page = 1
                }
                return ("statuses/friends_timeline", ["access_token": accessToken, "count": count!, "page": page!], "POST")
            case .FetchUserInfo(let accessToken, let uid):
                return ("2/users/show.json", ["access_token": accessToken, "uid": uid], "GET")
            }
            
        }()
        
        let URL = NSURL(string: WBRouter.baseURLString)!
        let URLRequest = NSURLRequest(URL: URL.URLByAppendingPathComponent(result.path))
        let encoding = Alamofire.ParameterEncoding.URL
        let request = encoding.encode(URLRequest, parameters: result.parameters).0
        request.HTTPMethod = result.method
        return request
    }
}
