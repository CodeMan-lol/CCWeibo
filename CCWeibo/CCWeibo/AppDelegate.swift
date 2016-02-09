//
//  AppDelegate.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/2.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        // 根据登录状态以及是否有新版本选择相应的初始化VC
        if let _ = UserAccount.loadAccount() {
            let initVC = needShowNewFeature() ? mainSB.instantiateViewControllerWithIdentifier("NewFeatureViewController") : mainSB.instantiateViewControllerWithIdentifier("WelcomeViewController")
            window?.rootViewController = initVC
        } else {
            let initVC = needShowNewFeature() ? mainSB.instantiateViewControllerWithIdentifier("NewFeatureViewController") : mainSB.instantiateInitialViewController()
            window?.rootViewController = initVC
        }
        return true
    }
    /// 检查是否为新版本
    private func needShowNewFeature() -> Bool {
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        guard let sandboxVersion = NSUserDefaults.standardUserDefaults().objectForKey(ApplicationInfo.ApplicationVersionKey) as? String else {
            NSUserDefaults.standardUserDefaults().setObject(currentVersion, forKey: ApplicationInfo.ApplicationVersionKey)
            return true
        }
        if currentVersion.compare(sandboxVersion) == NSComparisonResult.OrderedDescending {
            NSUserDefaults.standardUserDefaults().setObject(currentVersion, forKey: ApplicationInfo.ApplicationVersionKey)
            return true
        }
        return false
    }


}

