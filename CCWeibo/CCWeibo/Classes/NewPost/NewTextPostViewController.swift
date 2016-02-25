//
//  NewTextPostViewController.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/21.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class NewTextPostViewController: UIViewController {

    // MARK: - 发送新微博
    @IBAction func postNewWeibo(sender: UIBarButtonItem) {
        Alamofire.request(WBRouter.PostNewTextWeibo(accessToken: UserAccount.loadAccount()!.accessToken, status: textView.weiboText)).responseJSON { response in
            guard response.result.error == nil else {
                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                hud.labelText = "发送出错! 请重试"
                hud.color = UIColor.whiteColor()
                hud.hide(true, afterDelay: 3)
                return
            }
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = .CustomView
            hud.color = UIColor.whiteColor()
            hud.labelColor = UIColor.blackColor()
            let image = UIImage(named: "Checkmark")
            let imageView = UIImageView(image: image)
            hud.customView = imageView
            hud.square = true
            hud.labelText = "发布成功！"
            DelayUtil.delay(1.5) {
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    @IBAction func close(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var postBtn: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView! {
        didSet {
        textView.delegate = self
        }
    }
    @IBOutlet weak var placeholderLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewController(emoticonsKB)
        textView.inputView = emoticonsKB.view
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        textView.resignFirstResponder()
    }
    private lazy var emoticonsKB: EmoticonsKBViewController = EmoticonsKBViewController {
        [unowned self]
        (emoticonInfo: EmoticonInfo) in
        if let code = emoticonInfo.code {
            let range = self.textView.selectedTextRange!
            self.textView.replaceRange(range, withText: code.emojiText())
            return
        }
        if let png = emoticonInfo.png {
            self.textView.insertEmoticon(emoticonInfo, emoticonSize: 18)
            return
        }
        if let isDeleteBtn = emoticonInfo.isDeleteBtn where isDeleteBtn {
            self.textView.deleteBackward()
            return
        }
    }
    

}
extension NewTextPostViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        postBtn.enabled = textView.text != ""
        placeholderLabel.hidden = textView.text != ""
    }
}