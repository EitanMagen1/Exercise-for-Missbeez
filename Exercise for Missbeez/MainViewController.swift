//
//  MainViewController.swift
//  Exercise for Missbeez
//
//  Created by Lauren Efron on 14/02/2016.
//  Copyright © 2016 Eitan_Magen. All rights reserved.
//

import UIKit

let cellIdentifier = "cellIdentifier"

class MainViewController: UITableViewController    {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
      
    }

    private func setupNavigationBar() {
        let label = UILabel(frame: CGRectMake(0, 0, 200, 30))
        label.font = UIFont.boldSystemFontOfSize(21.0)
        label.textColor = UIColor.darkGrayColor()
        label.textAlignment = .Center
        label.text = "Services"
        
        navigationItem.titleView = label
    }
   
    let itemDescription = ["Manicure","Pedicure","Hair treatment","Specials"]
    
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
        
        return cell

    }
    var DisplayNewVCtitle : String = ""
    var NumberOfLineChoosen : Int = 0
    
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
            vc.TitlePassed = DisplayNewVCtitle
            vc.ImageNumber = NumberOfLineChoosen
        }
    }
}

