//
//  ImageBrowserViewController.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/15.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit
let imageBrowserCellReuseId = "ImageBrowserCell"
class ImageBrowserViewController: UIViewController {
    
    var imageURLs: [NSURL]?
    var currentIndex: Int?

    @IBOutlet weak var imageCollectionView: UICollectionView! {
        didSet {
        imageCollectionView.dataSource = self
        }
    }
    @IBAction func close(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = imageCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = view.bounds.size
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension ImageBrowserViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs!.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(imageBrowserCellReuseId, forIndexPath: indexPath) as! ImageBrowserCell
        cell.imageURL = imageURLs?[indexPath.row]
        return cell
    }
    
}




