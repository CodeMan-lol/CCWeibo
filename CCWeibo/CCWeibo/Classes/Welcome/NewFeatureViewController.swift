//
//  NewFeatureViewController.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/7.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit

let newFeatureImageCount = 4
let reuseIdentifier = "NewFeatureImageCell"
class NewFeatureViewController: UICollectionViewController {
    func startBtnClick() {
        performSegueWithIdentifier("NewFeatureModalToMain", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newFeatureImageCount
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NewFeatureCell
        cell.imageIndex = indexPath.row
        if indexPath.row == newFeatureImageCount - 1 {
            startBtn.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(startBtn)
            startBtn.sizeToFit()
            let centerXCons = startBtn.centerXAnchor.constraintEqualToAnchor(cell.centerXAnchor)
            let bottomCons = startBtn.bottomAnchor.constraintEqualToAnchor(cell.bottomAnchor, constant: -160)
            NSLayoutConstraint.activateConstraints([centerXCons, bottomCons])
            view.setNeedsLayout()
        }
        return cell
    }
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let currentCell = collectionView.visibleCells().first as! NewFeatureCell
        if collectionView.indexPathForCell(currentCell)!.row == newFeatureImageCount - 1 {
            startBtn.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.2, 0.2)
            UIView.animateWithDuration(2, delay: 0, usingSpringWithDamping: 30, initialSpringVelocity: 10, options: [], animations: {
                self.startBtn.transform = CGAffineTransformIdentity
                self.startBtn.hidden = false
                }, completion: nil)
        } else {
            // 绕道解决莫名其妙第二页会出现按钮的bug
            startBtn.hidden = true
        }
    }
    private lazy var startBtn: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "new_feature_button"), forState: .Normal)
        btn.setBackgroundImage(UIImage(named: "new_feature_button_highlighted"), forState: .Highlighted)
        btn.addTarget(self, action: "startBtnClick", forControlEvents: .TouchUpInside)
        btn.hidden = true
        return btn
    }()
    

}

class NewFeatureCell: UICollectionViewCell {
    
    @IBOutlet weak var newFeatureImageView: UIImageView!
    var imageIndex: Int? {
        didSet {
            guard imageIndex != nil else { return }
            newFeatureImageView.image = UIImage(named: "new_feature_\(imageIndex!+1)")
        }
    }
    
}
/// 横向平铺布局
class FullLayout: UICollectionViewLayout {
    var arrOfLayoutInfo: [UICollectionViewLayoutAttributes] = []

    override func prepareLayout() {
        
        let totalNumOfItems = collectionView?.numberOfItemsInSection(0)
        let itemWidth: CGFloat = UIScreen.mainScreen().bounds.width
        let itemHeight: CGFloat = UIScreen.mainScreen().bounds.height
        for i in 0...totalNumOfItems!-1 {
            let indexPath: NSIndexPath = NSIndexPath(forItem: i, inSection: 0)
            let x = CGFloat(i) * itemWidth
            let y: CGFloat = 0
            let layoutInfo = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            layoutInfo.frame = CGRectMake(x, y, itemWidth, itemHeight)
            arrOfLayoutInfo.append(layoutInfo)
        }

    }
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: CGFloat(newFeatureImageCount) * UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
    }
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return arrOfLayoutInfo.filter {
            return CGRectIntersectsRect($0.frame, rect)
        }

    }
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return arrOfLayoutInfo[indexPath.row]
    }
}