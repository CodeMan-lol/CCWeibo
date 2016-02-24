//
//  HomeTableViewController.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/2.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit
import Kingfisher
private let TimeLineReuseId = "TimeLineCell"
private let RetweetTimeLineReuseId = "RetweetTimeLineCell"
class HomeTableViewController: BaseTableViewController {
    private var statuses: [Status] = []
    // 选中图片以及图片集合
    var selectedImageCell: PictureCollectionViewCell?
    var selectedImageCollection: UICollectionView?
    
    @IBAction func leftBarItemClick(sender: UIButton) {
        print(#function)
    }
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
//  行高缓存，如用手动行高需要开启下一行代码
//    let rowCache = NSCache()
    @IBAction func rightBarItemClick(sender: UIButton) {
        performSegueWithIdentifier("ShowQRCodeScanView", sender: nil)

    }
    private lazy var newStatuesCountLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.orangeColor()
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(14)
        label.hidden = true
        return label
    }()
    func titleBtnClick(sender: TitleButton) {
        performSegueWithIdentifier("PopoverTitleTable", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isLogin {
            (view as! VisitorView).setupViews(true, iconName: "visitordiscover_feed_image_house", info: "关注一些人，回这里看看有什么惊喜")
        } else {
            setTitleBtn()
//          自动行高，如用手动行高，注释掉下一行代码
            tableView.rowHeight = UITableViewAutomaticDimension
            refreshControl = HomeRefreshControl(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 60))
            refreshControl?.addTarget(self, action: #selector(HomeTableViewController.refreshTimeLine), forControlEvents: .ValueChanged)
            
            self.navigationController?.navigationBar.insertSubview(self.newStatuesCountLabel, atIndex: 0)
            self.newStatuesCountLabel.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 30)

            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeTableViewController.changeTitleArrow), name: HomeNotifications.TitleViewWillHide, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeTableViewController.changeTitleArrow), name: HomeNotifications.TitleViewWillShow, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeTableViewController.didClickImage(_:)), name: HomeNotifications.DidSelectCollectionImage, object: nil)
            refreshControl?.beginRefreshing()
            refreshTimeLine()
        }
    }
    // 下拉刷新
    func refreshTimeLine() {
        let sinceId = statuses.first?.id
        Status.loadStatuses(sinceId, maxId: nil) {
            [unowned self]
            statuses in
            self.refreshControl?.endRefreshing()
            if statuses.count > 0 {
                self.statuses.insertContentsOf(statuses, at: 0)
                self.tableView.reloadData()
                // 出现提示文字
                self.showNewStatuesCountAnimate(statuses.count)
            }
            
        }
    }
    // 上拉加载更多
    func pullUptoLoadMore() {
        let maxId = statuses.last!.id - 1
        activityIndicatorView.startAnimating()
        Status.loadStatuses(nil, maxId: maxId) {
            [unowned self]
            statuses in
            if statuses.count > 0 {
                self.statuses.insertContentsOf(statuses, at: self.statuses.count)
                self.tableView.reloadData()
            }
            self.activityIndicatorView.stopAnimating()
        }
    }
    private func showNewStatuesCountAnimate(count: Int) {
        self.newStatuesCountLabel.text = "\(count)条新微博"
        UIView.animateWithDuration(1, animations: {
            self.newStatuesCountLabel.frame.origin.y += 44
            self.newStatuesCountLabel.hidden = false
            }, completion: { _ in
                UIView.animateWithDuration(1, delay: 1, options: [], animations: { 
                    self.newStatuesCountLabel.frame.origin.y -= 44
                    }, completion: { _ in
                        self.newStatuesCountLabel.hidden = true

                })
        })
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    func changeTitleArrow() {
        let titleBtn = navigationItem.titleView as! TitleButton
        titleBtn.selected = !titleBtn.selected
    }
    // MARK: - 点击图片查看大图
    func didClickImage(notification: NSNotification) {
        selectedImageCell = notification.userInfo?["selectedImageCell"] as? PictureCollectionViewCell
        selectedImageCollection = notification.userInfo?["selectedImageCollection"] as? UICollectionView
        performSegueWithIdentifier("HomeModalToImageBrowser", sender: notification.userInfo)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        KingfisherManager.sharedManager.cache.clearMemoryCache()
    }
    
    private func setTitleBtn() {
        let titleBtn = TitleButton()
        titleBtn.setTitle("\(UserInfo.loadUserInfo()!.screenName) ", forState: .Normal)
        titleBtn.setImage(UIImage(named: "navigationbar_arrow_down"), forState: .Normal)
        titleBtn.setImage(UIImage(named: "navigationbar_arrow_up"), forState: .Selected)
        titleBtn.addTarget(self, action: #selector(HomeTableViewController.titleBtnClick(_:)), forControlEvents: .TouchUpInside)
        titleBtn.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        navigationItem.titleView = titleBtn
        titleBtn.sizeToFit()
        
    }
    // MARK: - 转场相关
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segue = segue as? PopoverSegue {
            segue.preferredPopFrame = CGRect(x: UIScreen.mainScreen().bounds.midX - 100, y: 56, width: 200, height: 300)
            return
        }
        if let destinationVC =  segue.destinationViewController as? ImageBrowserViewController {
            destinationVC.imageURLs = sender!["imageURLs"] as? [NSURL]
            destinationVC.currentIndex = sender!["currentIndex"] as? Int
        }
    }

}
// MARK: - TableViewDelegate & TableViewDataSource
extension HomeTableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: TimeLineCell? = nil
        if let _ = statuses[indexPath.row].retweeted_status {
            cell = tableView.dequeueReusableCellWithIdentifier(RetweetTimeLineReuseId, forIndexPath: indexPath) as? RetweetTimeLineCell
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier(TimeLineReuseId, forIndexPath: indexPath) as? TimeLineCell
        }
        // 给定一个宽度，让cell先自行布局
        cell!.bounds.size.width = tableView.bounds.width
        cell!.layoutIfNeeded()
        cell!.status = statuses[indexPath.row]
        if indexPath.row == statuses.count - 1 {
            pullUptoLoadMore()
        }
        return cell!
    }
    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! TimeLineCell).cancelRetrieveTasks()
    }
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let picCount = statuses[indexPath.row].thumbnailURLs?[ApplicationInfo.PictureQualityMedium].count {
            switch picCount {
            case 2...4:
                return 400
            case 5...6:
                return 500
            case 7...9:
                return 600
            default:
                return 300
            }
        }
        return 200
    }
//  如需手动设置行高，开启以下代码，注释掉自动行高调整
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        let status = statuses[indexPath.row]
//        if let height = rowCache.objectForKey(status.id) as? CGFloat {
//            return height
//        }
//        let cell = tableView.dequeueReusableCellWithIdentifier(TimeLineReuseId) as! TimeLineCell
//        cell.bounds.size.width = tableView.bounds.size.width
//        let height = cell.rowHeightFor(status)
//        rowCache.setObject(height, forKey: status.id)
//        return height
//    }
    
}