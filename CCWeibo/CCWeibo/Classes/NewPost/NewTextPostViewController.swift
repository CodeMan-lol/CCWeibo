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
import Photos

private let ImageAttachmentCellReuseId = "ImageAttachmentCell"
class NewTextPostViewController: UIViewController {

    // MARK: - 发送新微博
    /**
     发送新微博
     只完成了文字微博
     图片微博部分完成了图片选择，但是不使用官方sdk的话仅支持一张图片上传，实现与文字微博类似，所以没有写
     - parameter sender: 发送按钮
     */
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
    // 分享图片的数组
    private var assets: [PHAsset] = [] {
        didSet {
            imgAttachmentCollectionView.hidden = assets.count == 0
            placeholderLabel.text = assets.count == 0 ? "分享新鲜事..." : "分享图片"
        }
    }
    private var longPressGesture: UILongPressGestureRecognizer!
    // 展示图片的collectionView
    private lazy var imgAttachmentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.mainScreen().bounds.width - 32) * 0.33
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.registerClass(ImageAttachmentCollectionViewCell.self, forCellWithReuseIdentifier: ImageAttachmentCellReuseId)
        collectionView.hidden = true
        collectionView.backgroundColor = UIColor.clearColor()

        return collectionView
    }()
    private var imgAttachmentTopCons: NSLayoutConstraint?
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
        setupUI()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewTextPostViewController.keyboardFrameChanged(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    private func setupUI() {
        addChildViewController(emoticonsKB)
        textView.addSubview(placeholderLabel)
        textView.addSubview(imgAttachmentCollectionView)
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(NewTextPostViewController.handleLongGesture(_:)))
        imgAttachmentCollectionView.addGestureRecognizer(longPressGesture)
        imgAttachmentCollectionView.delegate = self
        imgAttachmentCollectionView.dataSource = self
        imgAttachmentTopCons = imgAttachmentCollectionView.topAnchor.constraintEqualToAnchor(textView.topAnchor, constant: 100)
        let cons: [NSLayoutConstraint] = [
            placeholderLabel.leadingAnchor.constraintEqualToAnchor(textView.leadingAnchor, constant: 8),
            placeholderLabel.topAnchor.constraintEqualToAnchor(textView.topAnchor, constant: 8),
            
            imgAttachmentCollectionView.widthAnchor.constraintEqualToAnchor(textView.widthAnchor),
            imgAttachmentCollectionView.centerXAnchor.constraintEqualToAnchor(textView.centerXAnchor),
            imgAttachmentCollectionView.heightAnchor.constraintEqualToAnchor(imgAttachmentCollectionView.widthAnchor),
            imgAttachmentTopCons!
        ]
        NSLayoutConstraint.activateConstraints(cons)
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
    
    // MARK: - 转场相关
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "NewPostModalToImagePicker" {
            let imagePickerVC = (((segue.destinationViewController) as! UINavigationController).visibleViewController) as! CCImagePickerViewController
            imagePickerVC.delegate = self
            imagePickerVC.selectedAssets = assets
        }
    }

}
// iOS 9下 textview 滚动报 UIWindow endDisablingInterfaceAutorotationAnimated:] called on xxxx ignoring 警告的解决方法
extension NewTextPostViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}
extension NewTextPostViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        postBtn.enabled = textView.text != ""
        placeholderLabel.hidden = textView.text != ""
        imgAttachmentTopCons?.constant = max(100, textView.contentSize.height)
        if imgAttachmentTopCons!.constant > textView.frame.height - 64 - 44 - imgAttachmentCollectionView.bounds.height {
            textView.contentInset.bottom = imgAttachmentCollectionView.bounds.height + 44
        }
        textView.layoutIfNeeded()
    }
}
// MARK: - ImagePicker Delegate
extension NewTextPostViewController: CCImagePickerDelegate {
    func selectedImages(assets: [PHAsset]) {
        self.assets = assets
        imgAttachmentCollectionView.reloadData()
    }
}
extension NewTextPostViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ImageAttachmentCellReuseId, forIndexPath: indexPath) as! ImageAttachmentCollectionViewCell
        let asset = assets[indexPath.row]
        let options = PHImageRequestOptions()
        options.synchronous = true
        PHImageManager.defaultManager().requestImageDataForAsset(asset, options: options) {
            (data, _, _, _) in
            let image = UIImage(data: data!)?.createImageBy(0.4)
            cell.bgImage = image
        }
        cell.delegate = self
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let sourceAsset = assets[sourceIndexPath.row]
        assets.removeAtIndex(sourceIndexPath.row)
        assets.insert(sourceAsset, atIndex: destinationIndexPath.row)
    }
}
// MARK: - 图片附件拖拽
extension NewTextPostViewController {
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
        case UIGestureRecognizerState.Began:
            guard let selectedIndexPath = self.imgAttachmentCollectionView.indexPathForItemAtPoint(gesture.locationInView(self.imgAttachmentCollectionView)) else {
                break
            }
            imgAttachmentCollectionView.beginInteractiveMovementForItemAtIndexPath(selectedIndexPath)
        case UIGestureRecognizerState.Changed:
            imgAttachmentCollectionView.updateInteractiveMovementTargetPosition(gesture.locationInView(gesture.view!))
        case UIGestureRecognizerState.Ended:
            imgAttachmentCollectionView.endInteractiveMovement()
        default:
            imgAttachmentCollectionView.cancelInteractiveMovement()
        }
    }
}
extension NewTextPostViewController: ImageAttachmentDelegate {
    func attachmentClose(cell: ImageAttachmentCollectionViewCell) {
        let indexPath = imgAttachmentCollectionView.indexPathForCell(cell)!
        assets.removeAtIndex(indexPath.row)
        imgAttachmentCollectionView.deleteItemsAtIndexPaths([indexPath])
    }
}
