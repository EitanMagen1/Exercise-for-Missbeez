//
//  DisplayTableViewController.swift
//  Exercise for Missbeez
//
//  Created by Lauren Efron on 15/02/2016.
//  Copyright © 2016 Eitan_Magen. All rights reserved.
//

import UIKit


class DisplayTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate , UIScrollViewDelegate {

    // Create the UIImageView
    
    @IBOutlet weak var imageView: UIImageView!
    
    // Set the default height for the image on the top.
    var imageHeight:CGFloat = 300.0
    var imageWidth:CGFloat = 414.0

    
    var titlePassed : String?
    var imageNumber : Int = 0
    //Step 1 :To allow us to manage the table header we can't use the tableHeaderView property of UITableView because the table view manages the frame of its table header. We need to create and manage our own view. Add the following property right before items:
    var headerView: UIView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // loads the image that was choosen
        
        imageView.image = UIImage(named: String(imageNumber))
        //view the image
       // imageView.startAnimating()

        setupNavigationBar()
        
        //step 2 : take ownership of the header view we've so nicely setup in the storyboard and then remove it from the table view.
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        // step 3 : add reference to the header view ,via headerView ,to the tableView to ensure it is still in the view hierarchy.
        tableView.addSubview(headerView)
        // step 4 : push the contents of the table view down by the height of the header  then set the contentOffset downward by the same amount so we start off with the header view completely visible
        tableView.contentInset = UIEdgeInsets(top: imageHeight, left: 0, bottom: 0, right: 0 )
        tableView.contentOffset = CGPoint(x: 0, y:  -imageHeight)
        updateHeaderView()

    }
    
    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -imageHeight, width:  imageWidth, height: imageHeight)
        if tableView.contentOffset.y < -imageHeight  {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        if tableView.contentOffset.y > 0  {
            headerRect.origin.y = -tableView.contentOffset.y
            headerRect.size.height = tableView.contentOffset.y
        }
        headerView.frame = headerRect
    }
    
    private func setupNavigationBar() {
        let label = UILabel(frame: CGRectMake(0, 0, 200, 30))
        label.font = UIFont.boldSystemFontOfSize(21.0)
        label.textColor = UIColor.darkGrayColor()
        label.textAlignment = .Center
        label.text = "Treatment"
        navigationItem.titleView = label
        navigationController?.navigationItem.titleView?.alpha = 0.5
    }
    
    
    @IBOutlet weak var tableView: UITableView!

    
    // MARK: - Table view data source

     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier", forIndexPath: indexPath) as! DisplayTableViewCell
        
        cell.Title.text =  titlePassed! + " at row # \(indexPath.row)"
        return cell
    }
    
    
    // MARK: - UIScrollView delegate
    
    
    // Update scrollOffset on tableview scroll
     func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }
   


}
