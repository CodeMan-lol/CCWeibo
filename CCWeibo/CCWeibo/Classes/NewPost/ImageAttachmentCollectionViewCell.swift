//
//  ImageAttachmentCollectionViewCell.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/28.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit
protocol ImageAttachmentDelegate: class {
    func attachmentClose(cell: ImageAttachmentCollectionViewCell)
}
class ImageAttachmentCollectionViewCell: UICollectionViewCell {
    weak var delegate: ImageAttachmentDelegate?
    var bgImage: UIImage? {
        didSet {
            bgImageView.image = bgImage
        }
    }
    private lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setBackgroundImage(UIImage(named: "compose_photo_close"), forState: .Normal)
        btn.addTarget(self, action: #selector(ImageAttachmentCollectionViewCell.attachmentClose), forControlEvents: .TouchUpInside)
        return btn
    }()
    private lazy var bgImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRectZero)
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    private func setupUI() {
        addSubview(bgImageView)
        addSubview(closeBtn)
        
        let cons: [NSLayoutConstraint] = [
            bgImageView.widthAnchor.constraintEqualToAnchor(contentView.widthAnchor),
            bgImageView.heightAnchor.constraintEqualToAnchor(contentView.heightAnchor),
            bgImageView.centerXAnchor.constraintEqualToAnchor(contentView.centerXAnchor),
            bgImageView.centerYAnchor.constraintEqualToAnchor(contentView.centerYAnchor),
            
            closeBtn.topAnchor.constraintEqualToAnchor(contentView.topAnchor, constant: -8),
            closeBtn.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor, constant: 8),
            closeBtn.widthAnchor.constraintLessThanOrEqualToConstant(24),
            closeBtn.heightAnchor.constraintLessThanOrEqualToConstant(24)
        ]
        
        NSLayoutConstraint.activateConstraints(cons)
    }
    func attachmentClose() {
        delegate?.attachmentClose(self)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
