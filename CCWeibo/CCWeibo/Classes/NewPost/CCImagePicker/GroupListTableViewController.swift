//
//  GroupListTableViewController.swift
//  CCImagePicker
//
//  Created by 徐才超 on 16/2/26.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit
import Photos
private let GroupListCellReuseId = "GroupListCellReuseId"
protocol GroupListTableViewDelegate: class {
    func didSelected(group: PHAssetCollection)
}
class GroupListTableViewController: UITableViewController {
    var collections = [PHAssetCollection]()
    weak var delegate: GroupListTableViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return collections.count
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 86
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.didSelected((tableView.cellForRowAtIndexPath(indexPath) as! GroupListCell).collection!)
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(GroupListCellReuseId, forIndexPath: indexPath) as! GroupListCell
        cell.frame.size.width = tableView.bounds.width
        cell.layoutIfNeeded()
        cell.collection = collections[indexPath.row]
        return cell
    }


}
