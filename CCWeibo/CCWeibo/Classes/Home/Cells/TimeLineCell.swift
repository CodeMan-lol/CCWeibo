//
//  TeweetWithoutImageCell.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/10.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit
import Kingfisher

class TimeLineCell: UITableViewCell {

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var vipIconView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var verifiedIconView: UIImageView!
    @IBOutlet weak var picturesCollectionView: UICollectionView! {
        didSet {
        picturesCollectionView.delegate = self
        picturesCollectionView.dataSource = self
        }
    }
    @IBOutlet weak var repostBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var footerBar: UIImageView!
    @IBOutlet weak var picListHeightCons: NSLayoutConstraint!
    @IBOutlet weak var picListBottomCons: NSLayoutConstraint!
    
    private var retrieveImageTasks: [RetrieveImageTask] = []
    
    func cancelRetrieveTasks() {
        for task in retrieveImageTasks {
            task.cancel()
        }
        retrieveImageTasks.removeAll()
        KingfisherManager.sharedManager.cache.clearDiskCache()
    }
    
    // 图片列表中图片之间的间隙
    let thumbnailMargin: CGFloat = 8
    
    
    var status: Status? {
        didSet {
        if status != nil {
            setupUI()
        }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    /// 设置单元格
    func setupUI() {
        nameLabel.text = status?.user?.name
        timeLabel.text = status?.createTimeFoTimeLabel
        sourceLabel.text = "来自 \(status!.source!)"
        contentLabel.text = status?.text
        // 头像设置
        avatarView.kf_setImageWithURL(status!.user!.avatarURL)
        avatarView.layer.borderWidth = 0.5
        avatarView.layer.borderColor = UIColor.lightGrayColor().CGColor
        avatarView.layer.cornerRadius = avatarView.bounds.size.width / 2
        avatarView.layer.masksToBounds = true
        // 认证图标设置
        verifiedIconView.image = status?.user?.verifiedIcon
        // 会员图标设置
        vipIconView.image = status?.user?.mbrankIcon
        nameLabel.textColor = vipIconView.image == nil ? UIColor.darkGrayColor() : UIColor.orangeColor()
        if status!.comments_count > 0 {
            commentBtn.setTitle(" \(status!.comments_count)", forState: .Normal)
        } else {
            commentBtn.setTitle(" 评论", forState: .Normal)
        }
        if status!.reposts_count > 0 {
            repostBtn.setTitle(" \(status!.reposts_count)", forState: .Normal)
        } else {
            repostBtn.setTitle(" 转发", forState: .Normal)

        }
        if let itemSize = resizePictureCollectionView() {
            self.layoutIfNeeded()
            let layout = (picturesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout)
            layout.itemSize = itemSize
            layout.minimumLineSpacing = thumbnailMargin
            layout.minimumInteritemSpacing = thumbnailMargin
            
        }
        picturesCollectionView.reloadData()
        // 选中背景设置
        let selectedView = UIView(frame: self.bounds)
        selectedView.backgroundColor = UIColor(white: 0.98, alpha: 1)
        self.selectedBackgroundView = selectedView
        
    }
    /**
     调整图片列表的尺寸
     
     - returns: 列表中每张图片的尺寸
     */
    private func resizePictureCollectionView() -> CGSize? {
        var thumbnailWidth: CGFloat = 150
        var thumbnailHeight: CGFloat {
            return thumbnailWidth
        }
        guard let picURLs = status?.thumbnailURLs?[ApplicationInfo.PictureQualityMedium] else {
            picListHeightCons.constant = 0
            picListBottomCons.constant = 0
            return nil
        }
        let picCount = picURLs.count
        switch picCount {
        case 1:
            thumbnailWidth = picturesCollectionView.bounds.width
            picListHeightCons.constant = 150
            picListBottomCons.constant = 8
            return CGSize(width: thumbnailWidth, height: 150)
        case 2:
            thumbnailWidth = (picturesCollectionView.bounds.width - thumbnailMargin) / 2
            picListHeightCons.constant = thumbnailHeight

        case 4:
            thumbnailWidth = (picturesCollectionView.bounds.width - thumbnailMargin) / 2
            picListHeightCons.constant = CGFloat(thumbnailHeight) * 2 + CGFloat(thumbnailMargin)

        default:
            let rowNum = (picCount - 1) / 3 + 1
            thumbnailWidth = (picturesCollectionView.bounds.width - thumbnailMargin * 2) / 3
            picListHeightCons.constant = thumbnailHeight * CGFloat(rowNum) + thumbnailMargin * CGFloat(rowNum-1)

        }
        picListBottomCons.constant = 8
        return CGSize(width: thumbnailWidth, height: thumbnailHeight)
    }
    /// 手动设置行高的方法
    func rowHeightFor(status: Status) -> CGFloat {
        self.status = status
        self.layoutIfNeeded()
        return footerBar.frame.maxY
    }
    

    
    
}
// MARK: - 图片集合 DateSouce和Delegate
extension TimeLineCell: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.thumbnailURLs?[ApplicationInfo.PictureQualityMedium].count ?? 0
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PictureCollectionViewCell", forIndexPath: indexPath) as! PictureCollectionViewCell
        var imageURL = self.status!.thumbnailURLs![ApplicationInfo.PictureQualityMedium][indexPath.row]
        if imageURL.absoluteString.hasSuffix(".gif") {
            imageURL = self.status!.thumbnailURLs![ApplicationInfo.PictureQualityLow][indexPath.row]
            cell.gifLabel.hidden = false
        } else {
            cell.gifLabel.hidden = true
        }
        let task = cell.setImage(imageURL)
        retrieveImageTasks.append(task)
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as! PictureCollectionViewCell        
        let userInfo = [
            "imageURLs": (status?.thumbnailURLs![ApplicationInfo.PictureQualityMedium])!,
            "currentIndex": indexPath.row,
            "selectedImageCell": selectedCell,
            "selectedImageCollection": collectionView
        ]
        let imageURL = self.status!.thumbnailURLs![ApplicationInfo.PictureQualityMedium][indexPath.row]
        KingfisherManager.sharedManager.retrieveImageWithURL(imageURL, optionsInfo: nil, progressBlock: { (receivedSize, totalSize) in
            selectedCell.imageView.kf_indicator?.startAnimating()
            }) { (image, error, cacheType, imageURL) in
                let notification = NSNotification(name: HomeNotifications.DidSelectCollectionImage, object: nil, userInfo: userInfo)
                selectedCell.imageView.kf_indicator?.stopAnimating()
                selectedCell.imageView.kf_indicator?.hidden = true
                NSNotificationCenter.defaultCenter().postNotification(notification)
        }
    }
}

// MARK: - 图片集合单元格
class PictureCollectionViewCell: UICollectionViewCell {
    private var gifLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.orangeColor()
        label.textColor = UIColor.whiteColor()
        label.text = "GIF"
        label.sizeToFit()
        label.frame.origin = CGPointZero
        label.font = UIFont.systemFontOfSize(12)
        label.textAlignment = .Center
        label.hidden = true
        return label
    }()
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
        imageView.addSubview(gifLabel)
        }
    }
    
    func setImage(imageURL: NSURL) -> RetrieveImageTask {
        imageView.kf_showIndicatorWhenLoading = true
        return imageView.kf_setImageWithURL(imageURL)
    }
}


