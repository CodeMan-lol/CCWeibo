//
//  GroupListCell.swift
//  CCImagePicker
//
//  Created by 徐才超 on 16/2/26.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit
import Photos
class GroupListCell: UITableViewCell {
    var collection: PHAssetCollection? {
        didSet{
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.Image.rawValue)
            let fetchAssetResult = PHAsset.fetchAssetsInAssetCollection(collection!, options: fetchOptions)
            let asset = fetchAssetResult[0] as! PHAsset
            PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSize(width: 100,height: 100), contentMode: .AspectFill, options: nil) {
                [unowned self]
                (image, _) in
                self.thumnailView.image = image
            }
            nameLabel.text = collection!.localizedTitle!
            countLabel.text = "\(fetchAssetResult.count)"
            
        }
    }
    @IBOutlet weak var thumnailView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
