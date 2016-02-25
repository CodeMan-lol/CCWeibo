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
    private lazy var placeholderLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.lightGrayColor()
        label.text = "分享新鲜事..."
        label.font = UIFont.systemFontOfSize(14)
        label.sizeToFit()
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewController(emoticonsKB)
//        textView.inputView = emoticonsKB.view
        textView.addSubview(placeholderLabel)
        let cons: [NSLayoutConstraint] = [
            placeholderLabel.leadingAnchor.constraintEqualToAnchor(textView.leadingAnchor, constant: 8),
            placeholderLabel.topAnchor.constraintEqualToAnchor(textView.topAnchor, constant: 8)
        ]
        NSLayoutConstraint.activateConstraints(cons)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewTextPostViewController.keyboardFrameChanged(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    func keyboardFrameChanged(notification: NSNotification) {
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let endFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        toolBarBottomCons.constant = view.bounds.height - endFrame.minY
        // 防止工具条跳跃抖动
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! Int
        UIView.animateWithDuration(duration) {
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve)!)
            self.view.layoutIfNeeded()
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        textView.resignFirstResponder()
    }
    @IBAction func toggleKeyboard(sender: UIButton) {
        textView.resignFirstResponder()
        if textView.inputView == nil {
            textView.inputView = emoticonsKB.view
            sender.setImage(UIImage(named: "compose_keyboardbutton_background"), forState: .Normal)
            sender.setImage(UIImage(named: "compose_keyboardbutton_background_highlighted"), forState: .Highlighted)
        } else {
            textView.inputView = nil
            sender.setImage(UIImage(named: "compose_emoticonbutton_background"), forState: .Normal)
            sender.setImage(UIImage(named: "compose_emoticonbutton_background_highlighted"), forState: .Highlighted)
        }
        textView.becomeFirstResponder()
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
            self.textView.insertEmoticon(emoticonInfo)
            
            return
        }
        if let isDeleteBtn = emoticonInfo.isDeleteBtn where isDeleteBtn {
            self.textView.deleteBackward()
            return
        }
    }
    

}
// iOS 9 下textview滚动报 UIWindow endDisablingInterfaceAutorotationAnimated:] called on xxxx ignoring 警告的解决方法
extension NewTextPostViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}
extension NewTextPostViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        postBtn.enabled = textView.text != ""
        placeholderLabel.hidden = textView.text != ""
    }
}