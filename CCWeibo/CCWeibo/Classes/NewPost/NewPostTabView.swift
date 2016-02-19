//
//  NewPostTabView.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/18.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit
import SnapKit

class NewPostTabView: UIView, ScrollTabViewDelegate {
    // 滚动页码， 在监听中设置UI
    private var pageNum: Int = 0 {
        didSet {
        let scrollWidth = UIScreen.mainScreen().bounds.width
        let rectOrigin = CGRect(x: CGFloat(pageNum) * scrollWidth, y: 0, width: scrollWidth, height: self.newPostScrollView.frame.height)
        self.newPostScrollView.scrollRectToVisible(rectOrigin, animated: true)
        UIView.animateWithDuration(0.3) {
            self.returnCloseBar.alpha = self.pageNum == 0 ? 0 : 1
        }
        }
    }
    // 动画属性，控制是展现还是消失
    var isReprensing: Bool = true {
        didSet {
        animateItems()
        }
    }

    @IBOutlet weak var closeBtn: UIImageView!
    @IBOutlet weak var returnCloseBar: UIView!
    @IBAction func tapToClose(sender: UITapGestureRecognizer) {
        self.isReprensing = false
        UIView.animateWithDuration(0.5) {
            self.closeBtn.transform = CGAffineTransformIdentity
            self.alpha = 0
        }
    }
    @IBAction func returnBarCloseClick(sender: UIButton) {
        self.isReprensing = false
        UIView.animateWithDuration(0.5, animations: {
            self.alpha = 0
            }) { _ in
            self.pageNum = 0
        }
    }
    @IBAction func returnToFirstPage(sender: UIButton) {
        pageNum = 0
    }
    @IBOutlet weak var newPostScrollView: UIScrollView!
    @IBOutlet weak var newPostTabBar: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }
    //核心设置代码
    func setupXib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "NewPostTabView", bundle: bundle)
        let view: UIView = nib.instantiateWithOwner(self, options: nil).first as! UIView
        view.frame = bounds
        addSubview(view)
        setupUI()
    }
    private func setupUI() {
        returnCloseBar.alpha = 0
        newPostScrollView.contentSize = CGSize(width: UIScreen.mainScreen().bounds.width * 2, height: newPostScrollView.frame.height)
        let btnWidth = UIScreen.mainScreen().bounds.width/3
        let btnHeight = newPostScrollView.frame.height * 0.5
        let rectOrigin = CGRect(x: 0, y: 0, width: btnWidth, height: btnHeight)
        let textBtnView = ScrollTabView(frame:rectOrigin , imageName: "tabbar_compose_idea", labelText: "文字")
        textBtnView.delegate = self
        let photoBtnView = ScrollTabView(frame: CGRectOffset(rectOrigin, btnWidth, 0), imageName: "tabbar_compose_photo", labelText: "相片／视频")
        photoBtnView.delegate = self
        let hotBtnView = ScrollTabView(frame:CGRectOffset(rectOrigin, btnWidth*2, 0) , imageName: "tabbar_compose_idea", labelText: "头条文章")
        hotBtnView.delegate = self
        let locBtnView = ScrollTabView(frame:CGRectOffset(rectOrigin, 0, btnHeight) , imageName: "tabbar_compose_lbs", labelText: "签到")
        locBtnView.delegate = self
        let rateBtnView = ScrollTabView(frame:CGRectOffset(rectOrigin, btnWidth, btnHeight) , imageName: "tabbar_compose_review", labelText: "点评")
        rateBtnView.delegate = self
        let moreBtnView = ScrollTabView(frame:CGRectOffset(rectOrigin, btnWidth*2, btnHeight) , imageName: "tabbar_compose_more", labelText: "更多")
        moreBtnView.delegate = self
        let friendsBtnView = ScrollTabView(frame:CGRectOffset(rectOrigin, btnWidth*3, 0) , imageName: "tabbar_compose_friend", labelText: "好友圈")
        friendsBtnView.delegate = self
        let cameraBtnView = ScrollTabView(frame:CGRectOffset(rectOrigin, btnWidth*4, 0) , imageName: "tabbar_compose_wbcamera", labelText: "微博相机")
        cameraBtnView.delegate = self
        let musicBtnView = ScrollTabView(frame:CGRectOffset(rectOrigin, btnWidth*5, 0) , imageName: "tabbar_compose_idea", labelText: "音乐")
        musicBtnView.delegate = self
        let moneyBtnView = ScrollTabView(frame:CGRectOffset(rectOrigin, btnWidth*3, btnHeight) , imageName: "tabbar_compose_envelope", labelText: "红包")
        moneyBtnView.delegate = self
        let bookBtnView = ScrollTabView(frame:CGRectOffset(rectOrigin, btnWidth*4, btnHeight) , imageName: "tabbar_compose_book", labelText: "书籍")
        bookBtnView.delegate = self
        
        newPostScrollView.addSubview(textBtnView)
        textBtnView.moveBottomOffScreen()
        newPostScrollView.addSubview(photoBtnView)
        photoBtnView.moveBottomOffScreen()
        newPostScrollView.addSubview(hotBtnView)
        hotBtnView.moveBottomOffScreen()
        newPostScrollView.addSubview(locBtnView)
        locBtnView.moveBottomOffScreen()
        newPostScrollView.addSubview(rateBtnView)
        rateBtnView.moveBottomOffScreen()
        newPostScrollView.addSubview(moreBtnView)
        moreBtnView.moveBottomOffScreen()
        newPostScrollView.addSubview(friendsBtnView)
        friendsBtnView.moveBottomOffScreen()
        newPostScrollView.addSubview(cameraBtnView)
        cameraBtnView.moveBottomOffScreen()
        newPostScrollView.addSubview(musicBtnView)
        musicBtnView.moveBottomOffScreen()
        newPostScrollView.addSubview(moneyBtnView)
        moneyBtnView.moveBottomOffScreen()
        newPostScrollView.addSubview(bookBtnView)
        bookBtnView.moveBottomOffScreen()
    }
    func didClick(sender: ScrollTabView) {
        switch sender.infoLabel.text! {
        case "更多":
            pageNum = 1
        case "文字": break
        default: break
        }
        
    }
    func animateItems() {
        let itemCount = newPostScrollView.subviews.count
        let viewArr = (pageNum == 0 ? newPostScrollView.subviews : newPostScrollView.subviews.reverse()).map {
            $0 as! ScrollTabView
        }
        for (index, view) in viewArr.enumerate() {
            UIView.animateWithDuration(0.5, delay: 0.4/Double(itemCount) * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: [], animations: {
                self.isReprensing ? view.moveUpToOrigin() : view.moveBottomOffScreen()
            }, completion: nil)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }
    
}
class ScrollTabView: UIView {
    weak var delegate: ScrollTabViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    convenience init(frame: CGRect, imageName: String, labelText: String) {
        self.init(frame: frame)
        imageView.image = UIImage(named: imageName)
        infoLabel.text = labelText
        infoLabel.sizeToFit()

    }
    private func setupUI() {
        self.addSubview(imageView)
        self.addSubview(infoLabel)
        let tap = UITapGestureRecognizer(target: self, action: "didClick")
        self.addGestureRecognizer(tap)
        imageView.snp_makeConstraints { (make) in
            make.top.equalTo(self.snp_top).offset(10)
            make.centerX.equalTo(self.snp_centerX)
            make.width.equalTo(71)
            make.height.equalTo(71)
        }
        infoLabel.snp_makeConstraints { (make) in
            make.top.equalTo(imageView.snp_bottom).offset(8)
            make.centerX.equalTo(imageView.snp_centerX)
        }
    }
    
    private lazy var imageView: UIImageView = UIImageView()
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(14)
        return label
    }()
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        imageView.transform = CGAffineTransformIdentity
        super.touchesEnded(touches, withEvent: event)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        imageView.transform = CGAffineTransformMakeScale(1.1, 1.1)
        super.touchesBegan(touches, withEvent: event)
    }
    func didClick() {
        if self.infoLabel.text! != "更多" {
            UIView.animateWithDuration(0.3, animations: {
                self.transform = CGAffineTransformMakeScale(2, 2)
                self.alpha = 0.1
            }) { _ in
                self.transform = CGAffineTransformIdentity
                self.alpha = 1
                self.imageView.transform = CGAffineTransformIdentity
            }
        }
        delegate?.didClick(self)
    }
    func moveBottomOffScreen() {
        self.center.y += UIScreen.mainScreen().bounds.height
        self.alpha = 0
    }
    func moveUpToOrigin() {
        self.center.y -= UIScreen.mainScreen().bounds.height
        self.alpha = 1
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
protocol ScrollTabViewDelegate: class {
    func didClick(sender: ScrollTabView)
}