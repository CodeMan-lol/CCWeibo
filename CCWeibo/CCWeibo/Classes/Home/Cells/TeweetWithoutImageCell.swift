//
//  TeweetWithoutImageCell.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/10.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit

class TeweetWithoutImageCell: UITableViewCell {

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var vipIconView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var verifiedIconView: UIImageView!
    
    
    
    @IBOutlet weak var retweetBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    
    var status: Status? {
        didSet {
            setupUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI() {
        nameLabel.text = status?.user?.name
        timeLabel.text = status?.created_at
        sourceLabel.text = "来自\(status!.source!)"
        contentLabel.text = status?.text
        // 头像设置
        avatarView.kf_setImageWithURL(status!.user!.avatarURL)
        avatarView.layer.borderWidth = 0.5
        avatarView.layer.borderColor = UIColor.lightGrayColor().CGColor
        avatarView.layer.cornerRadius = avatarView.bounds.size.width / 2
        avatarView.layer.masksToBounds = true
        // 认证图标设置
        guard let verifiedIcon = status?.user?.verifiedIcon else {
            verifiedIconView.hidden = true
            return
        }
        verifiedIconView.image = verifiedIcon
        
        // 选中背景设置
        let selectedView = UIView(frame: self.bounds)
        selectedView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.selectedBackgroundView = selectedView
        
    }

}
