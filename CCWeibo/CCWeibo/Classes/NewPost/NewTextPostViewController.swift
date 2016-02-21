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

    @IBAction func postNewWeibo(sender: UIBarButtonItem) {
        Alamofire.request(WBRouter.PostNewTextWeibo(accessToken: UserAccount.loadAccount()!.accessToken, status: textView.text)).responseJSON { response in
            guard response.result.error == nil, let data = response.result.value else {
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

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        textView.resignFirstResponder()
    }


}
extension NewTextPostViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        postBtn.enabled = textView.text != ""
        placeholderLabel.hidden = textView.text != ""
    }
}