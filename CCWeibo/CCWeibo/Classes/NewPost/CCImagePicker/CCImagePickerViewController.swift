//
//  ViewController.swift
//  CCImagePicker
//
//  Created by 徐才超 on 16/2/26.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit
import Photos
private let PickerCellReuseId = "PickerViewCellReUserId"
protocol CCImagePickerDelegate: class {
    func selectedImages(assets: [PHAsset])
}

class CCImagePickerViewController: UIViewController {
    weak var delegate: CCImagePickerDelegate?
    // 相簿组
    private var assetCollections = [PHAssetCollection]()
    // 相片组
    private var currentAssets: [PHAsset] = [PHAsset]()
    // 选中的asset
    var selectedAssets: [PHAsset] = [] {
        didSet {
            doneBtn.enabled = selectedAssets.count > 0
        }
    }
    
    @IBOutlet weak var titleBtn: TitleButton!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    @IBAction func done(sender: UIBarButtonItem) {
        delegate?.selectedImages(selectedAssets)
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (UIScreen.mainScreen().bounds.width - 20) / 4
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.registerClass(ImagePickerCell.self, forCellWithReuseIdentifier: PickerCellReuseId)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        let cons: [NSLayoutConstraint] = [
            collectionView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
            collectionView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor),
            collectionView.widthAnchor.constraintEqualToAnchor(view.widthAnchor),
            collectionView.heightAnchor.constraintEqualToAnchor(view.heightAnchor)
        ]
        NSLayoutConstraint.activateConstraints(cons)
        
        getCollectionList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
// MARK: - PhtotsKit
extension CCImagePickerViewController {
    private func getCollectionList(){
        // estimatedAssetCount > 0
        let fetchOptions = PHFetchOptions()
        let fetchPredicate = NSPredicate(format: "estimatedAssetCount > 0")
        fetchOptions.predicate = fetchPredicate
        let fetchCollectionResutl = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
        for i in 0..<fetchCollectionResutl.count {
            assetCollections.append(fetchCollectionResutl[i] as! PHAssetCollection)
        }
        let allPhotosResult = PHAssetCollection.fetchAssetCollectionsWithType(.SmartAlbum, subtype: .Any, options: nil)
        for i in 0..<allPhotosResult.count {
            if allPhotosResult[i].localizedTitle! == "All Photos" || allPhotosResult[i].localizedTitle! == "Camera Roll" {
                assetCollections.append(allPhotosResult[i] as! PHAssetCollection)
            }
        }
        filtePhotoBy(assetCollections.first!)
    }
    private func filtePhotoBy(collection: PHAssetCollection) {
        titleBtn.setTitle(collection.localizedTitle! + " ", forState: .Normal)
        titleBtn.sizeToFit()
        currentAssets.removeAll()
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.Image.rawValue)
        let fetchAssetResult = PHAsset.fetchAssetsInAssetCollection(collection, options: fetchOptions)
        for i in 0..<fetchAssetResult.count {
            currentAssets.append(fetchAssetResult[i] as! PHAsset)
        }
        collectionView.reloadData()
    }
}
private class ImagePickerCell: UICollectionViewCell {

    var asset: PHAsset? {
        didSet {
            PHImageManager.defaultManager().requestImageForAsset(asset!, targetSize: CGSize(width: 200, height: 200), contentMode: .AspectFill, options: nil, resultHandler: {
                [unowned self]
                (image, _) in
                self.imageView.image = image
            })
        }
    }
    var isDisable: Bool = false {
        didSet {
            disableMaskView.hidden = !isDisable
        }
    }
    var isSelected: Bool = false {
        didSet{
            checkView.hidden = !isSelected
        }
    }
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRectZero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    private lazy var disableMaskView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidden = true
        return view
    }()
    private lazy var checkView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "compose_guide_check_box_right"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.hidden = true
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(disableMaskView)
        contentView.addSubview(checkView)
        let cons: [NSLayoutConstraint] = [
            imageView.widthAnchor.constraintEqualToAnchor(contentView.widthAnchor),
            imageView.heightAnchor.constraintEqualToAnchor(contentView.heightAnchor),
            imageView.centerXAnchor.constraintEqualToAnchor(contentView.centerXAnchor),
            imageView.centerYAnchor.constraintEqualToAnchor(contentView.centerYAnchor),
            
            disableMaskView.widthAnchor.constraintEqualToAnchor(contentView.widthAnchor),
            disableMaskView.heightAnchor.constraintEqualToAnchor(contentView.heightAnchor),
            disableMaskView.centerXAnchor.constraintEqualToAnchor(contentView.centerXAnchor),
            disableMaskView.centerYAnchor.constraintEqualToAnchor(contentView.centerYAnchor),
            
            checkView.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor, constant: -1),
            checkView.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor, constant: -1),
            checkView.widthAnchor.constraintEqualToConstant(20),
            checkView.heightAnchor.constraintEqualToConstant(20)
        ]
        NSLayoutConstraint.activateConstraints(cons)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CCImagePickerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentAssets.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PickerCellReuseId, forIndexPath: indexPath) as! ImagePickerCell
        cell.asset = currentAssets[indexPath.row]
        cell.isSelected = selectedAssets.contains {
            asset -> Bool in
            return asset.localIdentifier == cell.asset!.localIdentifier
        }
        cell.isDisable = !cell.isSelected && selectedAssets.count == 9
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ImagePickerCell
        guard !cell.isDisable else { return }
        UIView.animateWithDuration(0.1, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: [], animations: {
            cell.transform = CGAffineTransformMakeScale(0.95, 0.95)
            }) { _ in
                cell.transform = CGAffineTransformIdentity
        }
        cell.isSelected = !cell.isSelected
        if cell.isSelected {
            selectedAssets.append(cell.asset!)
            if selectedAssets.count == 9 {
                collectionView.reloadData()
            }
        } else {
            let index = selectedAssets.indexOf {
                asset -> Bool in
                return asset.localIdentifier == cell.asset!.localIdentifier
            }
            selectedAssets.removeAtIndex(index!)
            if selectedAssets.count == 8 {
                collectionView.reloadData()
            }
        }
    }
    
}

extension CCImagePickerViewController: UIPopoverPresentationControllerDelegate, UIAdaptivePresentationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ChoosePhotoGroupPopover" {
            let ppc = segue.destinationViewController.popoverPresentationController!
            ppc.delegate = self
            segue.destinationViewController.preferredContentSize = CGSize(width: 300, height: assetCollections.count * 86)
            ppc.sourceView = self.view
            ppc.sourceRect = CGRectMake(view.bounds.width / 2, 60, 0, 0)
            let tableView = segue.destinationViewController as! GroupListTableViewController
            tableView.collections = assetCollections
            tableView.delegate = self
        }
    }
}
extension CCImagePickerViewController: GroupListTableViewDelegate {
    func didSelected(collection: PHAssetCollection) {
        filtePhotoBy(collection)
        
    }
}