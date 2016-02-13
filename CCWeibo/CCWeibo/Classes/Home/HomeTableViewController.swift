//
//  HomeTableViewController.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/2.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit
private let TimeLineReuseId = "TimeLineCell"
private let RetweetTimeLineReuseId = "RetweetTimeLineCell"
class HomeTableViewController: BaseTableViewController {
    private var statuses: [Status] = []
    @IBAction func leftBarItemClick(sender: UIButton) {
        print(__FUNCTION__)
    }
//  行高缓存，如用手动行高需要开启下一行代码
//    let rowCache = NSCache()
    @IBAction func rightBarItemClick(sender: UIButton) {
        performSegueWithIdentifier("ShowQRCodeScanView", sender: nil)

    }

    func titleBtnClick(sender: TitleButton) {
        performSegueWithIdentifier("PopoverTitleTable", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isLogin {
            (view as! VisitorView).setupViews(true, iconName: "visitordiscover_feed_image_house", info: "关注一些人，回这里看看有什么惊喜")
        } else {
            setTitleBtn()
            tableView.estimatedRowHeight = 200
//          自动行高，如用手动行高，注释掉下一行代码
            tableView.rowHeight = UITableViewAutomaticDimension
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeTitleArrow", name: HomeNotifications.TitleViewWillHide, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeTitleArrow", name: HomeNotifications.TitleViewWillShow, object: nil)
            Status.loadStatuses{
                statuses in
                self.statuses = statuses
                self.tableView.reloadData()
            }
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func changeTitleArrow() {
        let titleBtn = navigationItem.titleView as! TitleButton
        titleBtn.selected = !titleBtn.selected
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setTitleBtn() {
        let titleBtn = TitleButton()
        titleBtn.setTitle("\(UserInfo.loadUserInfo()!.screenName) ", forState: .Normal)
        titleBtn.setImage(UIImage(named: "navigationbar_arrow_down"), forState: .Normal)
        titleBtn.setImage(UIImage(named: "navigationbar_arrow_up"), forState: .Selected)
        titleBtn.addTarget(self, action: "titleBtnClick:", forControlEvents: .TouchUpInside)
        titleBtn.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        navigationItem.titleView = titleBtn
        titleBtn.sizeToFit()
        
    }
    // MARK: - 转场相关
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segue = segue as? PopoverSegue {
            segue.preferredPopFrame = CGRect(x: UIScreen.mainScreen().bounds.midX - 100, y: 56, width: 200, height: 300)            
        }
    }

    
    

}
// TableViewDelegate & TableViewDataSource
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
        cell!.status = statuses[indexPath.row]
        return cell!
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