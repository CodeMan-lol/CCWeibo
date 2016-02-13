//
//  HomeRefreshControl.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/13.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit

class HomeRefreshControl: UIRefreshControl {

    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    private lazy var circleLayer: CAShapeLayer = {
       let layer = CAShapeLayer()
        layer.lineCap = kCALineCapRound
        layer.lineCap = kCALineCapRound
        layer.strokeColor = UIColor.orangeColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        layer.strokeStart = 0.0
        layer.strokeEnd = 0.0
        layer.lineWidth = 5
        return layer
    }()
    private var progress: CGFloat = 0.0 {
        didSet {
        circleLayer.strokeEnd = progress
        if progress == 1 {
            if !refreshing {
                infoLabel.text = "释放刷新..."
            }
        } else {
            infoLabel.text = "下拉刷新..."
        }
        }
    }
    private var animating: Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }
    // 核心设置代码
    private func setupXib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "HomeRefreshControl", bundle: bundle)
        let view: UIView = nib.instantiateWithOwner(self, options: nil).first as! UIView
        view.frame = bounds
        circleView.layer.addSublayer(circleLayer)
        circleLayer.path = UIBezierPath(ovalInRect: CGRectInset(circleView.bounds, 18, 18)).CGPath
        addSubview(view)
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New, context: nil)
    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if refreshing && !animating {
            startAnimate()
            return
        }
        if keyPath == "frame" && frame.origin.y < 0 && !refreshing {
            progress = min(1, -frame.origin.y / frame.height)
        }
    }
    // 刷新状态动画
    private func startAnimate() {
        //旋转
        let startPointStroken = CABasicAnimation(keyPath: "strokeStart")
        startPointStroken.fromValue = -1
        startPointStroken.toValue = 1
        
        let endPointStroken = CABasicAnimation(keyPath: "strokeEnd")
        endPointStroken.fromValue = 0
        endPointStroken.toValue = 1
        
        let strokeAnimateGroup = CAAnimationGroup()
        strokeAnimateGroup.duration = 1.2
        strokeAnimateGroup.repeatCount = HUGE
        strokeAnimateGroup.animations = [startPointStroken, endPointStroken]
        circleLayer.addAnimation(strokeAnimateGroup, forKey: nil)
        infoLabel.text = "正在刷新..."
        
        animating = true
    }
    private func endAnimate() {
        progress = 0.0
        animating = false
        circleLayer.removeAllAnimations()
    }
    override func beginRefreshing() {
        super.beginRefreshing()
        startAnimate()
    }
    override func endRefreshing() {
        super.endRefreshing()
        endAnimate()
    }
    deinit {
        removeObserver(self, forKeyPath: "frame")
    }
}
