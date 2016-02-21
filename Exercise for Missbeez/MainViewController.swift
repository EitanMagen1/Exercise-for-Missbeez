//
//  MainViewController.swift
//  Exercise for Missbeez
//
//  Created by Lauren Efron on 14/02/2016.
//  Copyright © 2016 Eitan_Magen. All rights reserved.
//

import UIKit

let cellIdentifier = "cellIdentifier"
var DisplayNewVCtitle : String = ""
var NumberOfLineChoosen : Int = 0
let itemDescription = ["Manicure","Pedicure","Hair treatment","Specials"]
// setting up the refresh view size which will be located above the screen
private let refreshViewHeight: CGFloat = 200

func delayBySeconds(seconds: Double, delayedCode: ()->()) {
    let targetTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * seconds))
    dispatch_after(targetTime, dispatch_get_main_queue()) {
        delayedCode()
    }
}


class MainViewController: UITableViewController   {
//setting up the refresh property
    var refreshView: RefreshView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize the refresh view
        refreshView = RefreshView(frame: CGRect(x: 0, y: -refreshViewHeight, width: CGRectGetWidth(view.bounds), height: refreshViewHeight), scrollView: tableView)
        // will allow to code the auto layout
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        //set delegate to call when the user request a refresh
        refreshView.delegate = self
        
        // add the refresh view as a sub view indexed 0 which means under the table view
        view.insertSubview(refreshView, atIndex: 0)
        
        setupNavigationBar()
    }
    
    // copy the scrooling done in this view controller to the refresh view
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        refreshView.scrollViewDidScroll(scrollView)
    }
    
    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        refreshView.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    
    private func setupNavigationBar() {
        let label = UILabel(frame: CGRectMake(0, 0, 200, 30))
        label.font = UIFont.boldSystemFontOfSize(21.0)
        label.textColor = UIColor.darkGrayColor()
        label.textAlignment = .Center
        label.text = "Services"
        navigationItem.titleView = label
    }
   
    
    // MARK: - Table View Delegate and Data Source
    
    override func tableView(tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return (self.tableView.frame.height - 64 )/4
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MainTableViewCell
        cell.photoImageView.image = imageAtIndex(indexPath.row) 
        cell.pictureDescription.textColor = UIColor.whiteColor()
        cell.pictureDescription.text = itemDescription[indexPath.row]
        cell.pictureDescription.font = UIFont.systemFontOfSize(20.0)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        DisplayNewVCtitle = itemDescription[indexPath.row]
        NumberOfLineChoosen = indexPath.row
        self.performSegueWithIdentifier("ShowSecondView", sender: nil);
    }
    
    func imageAtIndex(index: Int) -> UIImage? {
        return UIImage(named: String(index))
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowSecondView" {
            let vc : DisplayTableViewController = segue.destinationViewController as! DisplayTableViewController
            vc.titlePassed = DisplayNewVCtitle
            vc.imageNumber = NumberOfLineChoosen
        }
    }
}

extension MainViewController: RefreshViewDelegate {
    func refreshViewDidRefresh(refreshView: RefreshView) {
        // place any refresh contant here!
        delayBySeconds(3) {
            self.refreshView.endRefreshing()
        }
    }
}

