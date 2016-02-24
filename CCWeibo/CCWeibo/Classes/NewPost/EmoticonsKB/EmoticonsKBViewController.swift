//
//  EmoticonsKBViewController.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/23.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit
private let emoticonCellReuseId = "emoticonCellReuseId"
class EmoticonsKBViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        let cons: [NSLayoutConstraint] = [
            toolBar.widthAnchor.constraintEqualToAnchor(view.widthAnchor),
            toolBar.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
            toolBar.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor),
            
            collectionView.widthAnchor.constraintEqualToAnchor(view.widthAnchor),
            collectionView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
            collectionView.bottomAnchor.constraintEqualToAnchor(toolBar.topAnchor),
            collectionView.topAnchor.constraintEqualToAnchor(view.topAnchor)
        ]
        NSLayoutConstraint.activateConstraints(cons)
        
    }
    override func viewDidLayoutSubviews() {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let width = collectionView.bounds.width / 7
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .Horizontal
        let inset = (collectionView.bounds.height - width * 3) * 0.5
        collectionView.contentInset = UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
    }
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.registerClass(EmoticonCell.self, forCellWithReuseIdentifier: emoticonCellReuseId)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.pagingEnabled = true
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        return collectionView
    }()
    private lazy var toolBar: UIToolbar = {
        let bar = UIToolbar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.tintColor = UIColor.darkGrayColor()
        var items = [UIBarButtonItem]()
        let firstItem = UIBarButtonItem(title: "最近", style: .Plain, target: self, action: #selector(EmoticonsKBViewController.emoticonDidSelected(_:)))
        firstItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFontOfSize(14)],forState:.Normal)
        items.append(firstItem)
        items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        for group in self.emoticonGroups {
            let itemName = group.group_name_cn
            let barItem = UIBarButtonItem(title: itemName, style: .Plain, target: self, action: #selector(EmoticonsKBViewController.emoticonDidSelected(_:)))
            barItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFontOfSize(14)],forState:.Normal)
            items.append(barItem)
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        bar.items = items
        return bar
    }()
    func emoticonDidSelected(sender: UIBarButtonItem) {
        
    }
    private lazy var emoticonGroups: [EmoticonGroupInfo] = "emoticons.plist".emoticonGroups()
}
private class EmoticonCell: UICollectionViewCell {
    private lazy var emoticonBtn: UIButton = UIButton()
    var id: String?
    var emoticon: EmoticonInfo? {
        didSet {
            if let code = emoticon!.code {
                // emoji 表情
                emoticonBtn.setTitle(code.emojiText(), forState: .Normal)
                emoticonBtn.setImage(nil, forState: .Normal)
            } else {
                emoticonBtn.setTitle(nil, forState: .Normal)
                if let isDeleteBtn = emoticon!.isDeleteBtn {
                    if isDeleteBtn {
                        // 删除按钮
                        emoticonBtn.setImage(UIImage(named: "compose_emotion_delete_highlighted"), forState: .Normal)
                    } else {
                        // 空白格子
                        emoticonBtn.setImage(nil, forState: .Normal)
                    }
                    
                } else {
                    // 新浪表情
                    emoticonBtn.setImage("\(id!)/\(emoticon!.png!)".sinaEmoticon(), forState: .Normal)
                }
                
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    private func setupUI() {
        contentView.addSubview(emoticonBtn)
        emoticonBtn.translatesAutoresizingMaskIntoConstraints = false
        emoticonBtn.backgroundColor = UIColor.groupTableViewBackgroundColor()
        let cons: [NSLayoutConstraint] = [
            emoticonBtn.widthAnchor.constraintEqualToAnchor(contentView.widthAnchor, multiplier: 0.8),
            emoticonBtn.heightAnchor.constraintEqualToAnchor(contentView.heightAnchor, multiplier: 0.8),
            emoticonBtn.centerXAnchor.constraintEqualToAnchor(contentView.centerXAnchor),
            emoticonBtn.centerYAnchor.constraintEqualToAnchor(contentView.centerYAnchor)
        ]
        NSLayoutConstraint.activateConstraints(cons)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension EmoticonsKBViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return emoticonGroups.count
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emoticonGroups[section].emoticons!.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(emoticonCellReuseId, forIndexPath: indexPath) as! EmoticonCell
        cell.id = emoticonGroups[indexPath.section].id!
        cell.emoticon = (emoticonGroups[indexPath.section].emoticons!)[indexPath.row]
        return cell
    }
}
