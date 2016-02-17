//
//  OAuthViewController.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/6.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class OAuthViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBAction func close(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        let OAuthURLStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WBKeys.AppKey)&redirect_uri=\(WBKeys.RedirectURI)"
        let OAuthURL = NSURL(string: OAuthURLStr)!
        let OAuthRequest = NSURLRequest(URL: OAuthURL)
        webView.loadRequest(OAuthRequest)
    }
    
    /**
     获取AccessToken并保存
     
     - parameter code: 用户授权登录之后的授权码
     */
    private func loadAccessToken(code: String) {
        Alamofire.request(WBRouter.FetchAccessToken(code: code)).responseJSON {
            response in
            guard response.result.error == nil, let data = response.result.value else {
                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                hud.labelText = "网络出错! 请重试"
                hud.color = UIColor.whiteColor()
                DelayUtil.delay(3) {
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                return
            }
            let json = JSON(data)
            let userAccount = UserAccount()
            userAccount.accessToken = json["access_token"].stringValue
            userAccount.expiresIn = json["expires_in"].doubleValue
            userAccount.uid = json["uid"].stringValue
            UserAccount.saveAccount(userAccount)
            self.loadUserInfo(userAccount) {
                self.performSegueWithIdentifier("OAuthModalToWelcome", sender: self)
            }
        }
    }
    /**
     获取登录的用户信息
     
     - parameter userAccount: 用户帐号相关类的对象
     */
    private func loadUserInfo(userAccount: UserAccount, completion: ()->()) {
        Alamofire.request(WBRouter.FetchUserInfo(accessToken: userAccount.accessToken, uid: userAccount.uid)).responseJSON {
            response in
            guard response.result.error == nil, let data = response.result.value else {
                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                hud.labelText = "网络出错! 请重试"
                hud.color = UIColor.whiteColor()
                DelayUtil.delay(3) {
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                return
            }
            let json = JSON(data)
            let userInfo = UserInfo(screenName: json["screen_name"].stringValue, avatarLarge: json["avatar_large"].stringValue)
            UserInfo.saveUserInfo(userInfo)
            completion()
        }
    }

}

extension OAuthViewController: UIWebViewDelegate {
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let URLStr = request.URL!.absoluteString
        if !URLStr.hasPrefix(WBKeys.RedirectURI) {
            return true
        } else {
            let codeStr = "code="
            let queryStr = request.URL!.query!
            if !queryStr.hasPrefix(codeStr) {
                print("授权失败")
                dismissViewControllerAnimated(true, completion: nil)
            } else {
                let code = String(queryStr.characters.split("=")[1])
                loadAccessToken(code)
            }
        }
        return false
    }
    func webViewDidStartLoad(webView: UIWebView) {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "正在加载..."
        hud.color = UIColor.whiteColor()
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
}
