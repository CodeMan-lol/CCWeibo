//
//  ImageBrowserViewController.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/15.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit
import Kingfisher
import MBProgressHUD
let imageBrowserCellReuseId = "ImageBrowserCell"
class ImageBrowserViewController: UIViewController {
    
    var imageURLs: [NSURL]?
    var currentIndex: Int? {
        didSet {
        snapToPage(currentIndex!)
        }
    }

    @IBOutlet weak var imageCollectionView: UICollectionView! {
        didSet {
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        }
    }
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func save(sender: UIButton) {
        let cell = imageCollectionView.visibleCells().last as! ImageBrowserCell
        UIImageWriteToSavedPhotosAlbum(cell.imageView.image!, self, "image:didFinishSavingWithError:contextInfo:", nil)
    }
    func image(image:UIImage, didFinishSavingWithError error:NSError?, contextInfo: AnyObject) {
        guard error == nil else {
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = .Text
            hud.color = UIColor.whiteColor()
            hud.labelText = "保存失败！"
            hud.labelColor = UIColor.blackColor()
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
        hud.labelText = "保存成功！"
        hud.hide(true, afterDelay: 3)
    }
    func snapToPage(pageNum: Int) {
        let indexPath = NSIndexPath(forItem: pageNum, inSection: 0)
        imageCollectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: .None, animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = imageCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = view.bounds.size
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "close", name: ImageBrowserNotifications.TapToClose, object: nil)
    }
    deinit {
        // 清理内存里的gif缓存
        for URL in imageURLs! {
            if URL.absoluteString.hasSuffix("gif") {
                KingfisherManager.sharedManager.cache.removeImageForKey(URL.absoluteString, fromDisk: false, completionHandler: nil)
            }
        }
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    override func viewDidAppear(animated: Bool) {
        snapToPage(currentIndex!)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
extension ImageBrowserViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs!.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(imageBrowserCellReuseId, forIndexPath: indexPath) as! ImageBrowserCell
        cell.imageURL = imageURLs?[indexPath.row]
        return cell
    }
    
}
extension ImageBrowserViewController: UICollectionViewDelegate {
//    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
//        currentIndex = indexPath.row
//    }
}




