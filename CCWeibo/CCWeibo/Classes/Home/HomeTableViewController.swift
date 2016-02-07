//
//  HomeTableViewController.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/2.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {

    @IBAction func leftBarItemClick(sender: UIButton) {
        print(__FUNCTION__)
    }
    
    @IBAction func rightBarItemClick(sender: UIButton) {
        performSegueWithIdentifier("ShowQRCodeScanView", sender: nil)

    }
    @IBAction func titleBtnClick(sender: TitleButton) {        
        performSegueWithIdentifier("PopoverTitleTable", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isLogin {
            (view as! VisitorView).setupViews(true, iconName: "visitordiscover_feed_image_house", info: "关注一些人，回这里看看有什么惊喜")

        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeTitleArrow", name: HomeNotifications.TitleViewWillHide, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeTitleArrow", name: HomeNotifications.TitleViewWillShow, object: nil)
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
    
    // MARK: - 转场相关
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segue = segue as? PopoverSegue {
            segue.preferredPopFrame = CGRect(x: UIScreen.mainScreen().bounds.midX - 100, y: 56, width: 200, height: 300)            
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}