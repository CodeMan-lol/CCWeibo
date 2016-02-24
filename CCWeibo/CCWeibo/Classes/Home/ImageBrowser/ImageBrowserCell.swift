//
//  ImageCollectionViewCell.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/15.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit

class ImageBrowserCell: UICollectionViewCell {
    var imageURL: NSURL? {
        didSet {
        reset()
        if imageView.superview == nil {
            imageScrollView.addSubview(imageView)
        }
        imageView.kf_setImageWithURL(imageURL!, placeholderImage: nil, optionsInfo: nil) {
            (image, error, cacheType, imageURL) in
            self.imageView.frame.size = image!.size
            self.layoutImageView()
        }
        }
    }
    func close() {
        NSNotificationCenter.defaultCenter().postNotificationName(ImageBrowserNotifications.TapToClose, object: nil)
    }
    private func layoutImageView() {
        let aspectRatio = imageView.bounds.width / imageView.bounds.height
        let width = UIScreen.mainScreen().bounds.width
        let height = width / aspectRatio
        imageView.frame = CGRect(origin: CGPointZero, size: CGSize(width: width, height: height))
        if height > UIScreen.mainScreen().bounds.height {
            imageScrollView.contentSize = imageView.frame.size
        } else {
            var insetV = (UIScreen.mainScreen().bounds.height - height) * 0.5
            var insetH = (UIScreen.mainScreen().bounds.width - width) * 0.5
            insetV = insetV<0 ? 0 : insetV
            insetH = insetH<0 ? 0 : insetH
            imageScrollView.contentInset = UIEdgeInsets(top: insetV, left: insetH, bottom: insetV, right: 0)
        }
    }
    @IBOutlet weak var imageScrollView: UIScrollView! {
        didSet {
        imageScrollView.delegate = self
        imageScrollView.maximumZoomScale = 2
        imageScrollView.minimumZoomScale = 1
        let tap = UITapGestureRecognizer(target: self, action: #selector(ImageBrowserCell.close))
        imageScrollView.addGestureRecognizer(tap)
        }
    }
    lazy var imageView: UIImageView = UIImageView()

    private func reset() {
        imageScrollView.contentInset = UIEdgeInsetsZero
        imageScrollView.contentSize = CGSizeZero
        imageScrollView.contentOffset = CGPointZero
        
        imageView.transform = CGAffineTransformIdentity
    }

    
}

extension ImageBrowserCell: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    func scrollViewDidZoom(scrollView: UIScrollView) {
        let height = imageView.frame.height
        let width = imageView.frame.width
        var insetV = (UIScreen.mainScreen().bounds.height - height) * 0.5
        var insetH = (UIScreen.mainScreen().bounds.width - width) * 0.5
        insetV = insetV<0 ? 0 : insetV
        insetH = insetH<0 ? 0 : insetH
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 20, options: [], animations: {
            self.imageScrollView.contentInset = UIEdgeInsets(top: insetV, left: insetH, bottom: insetV, right: 0)
            }, completion: nil)
    }
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        let height = view!.frame.height
        let width = view!.frame.width
        var insetV = (UIScreen.mainScreen().bounds.height - height) * 0.5
        var insetH = (UIScreen.mainScreen().bounds.width - width) * 0.5
        insetV = insetV<0 ? 0 : insetV
        insetH = insetH<0 ? 0 : insetH
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 20, options: [], animations: {
                self.imageScrollView.contentInset = UIEdgeInsets(top: insetV, left: insetH, bottom: insetV, right: 0)
            }, completion: nil)

    }
}