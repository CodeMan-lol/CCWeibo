//
//  String+FilePath.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/7.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import Foundation
extension String {
    func cachesDir() -> String {
        let cachesPath = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).first! as NSString
        let filePath = cachesPath.stringByAppendingPathComponent((self as NSString).lastPathComponent) as String
        return filePath
    }
    func docsDir() -> String {
        let docsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as NSString
        let filePath = docsPath.stringByAppendingPathComponent((self as NSString).lastPathComponent) as String
        return filePath
    }
    func tmpDir() -> String {
        let tmpPath = NSTemporaryDirectory() as NSString
        let filePath = tmpPath.stringByAppendingPathComponent((self as NSString).lastPathComponent) as String
        return filePath
    }
}