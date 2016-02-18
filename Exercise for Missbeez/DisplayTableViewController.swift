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
    var imageWidth:CGFloat = 434.0

    
    var titlePassed : String?
    var imageNumber : Int = 0
    //Step 1 :To allow us to manage the table header we can't use the tableHeaderView property of UITableView because the table view manages the frame of its table header. We need to create and manage our own view. Add the following property right before items:
    var headerView: UIView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // loads the image that was choosen
        
        imageView.image = UIImage(named: String(imageNumber))
        setupNavigationBar()
        
        //step 2 : take ownership of the header view we've so nicely setup in the storyboard and then remove it from the table view.
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        // step 3 : add reference to the header view ,via headerView ,to the tableView to ensure it is still in the view hierarchy.
        tableView.addSubview(headerView)
        // step 4 : push the contents of the table view down by the height of the header  then set the contentOffset downward by the same amount so we start off with the header view completely visible
        tableView.contentInset = UIEdgeInsets(top: imageHeight, left: 0, bottom: 0, right: 0 )
        tableView.contentOffset = CGPoint(x: 0, y:  -imageHeight )
        updateHeaderView()

    }
    
    
    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -imageHeight, width:  imageWidth, height: imageHeight)
        // streach the image
        if tableView.contentOffset.y < -imageHeight  {
            headerRect.size.height = -tableView.contentOffset.y
            TitleText = ""
            setupNavigationBar()
        }
        // shrink the image
        if tableView.contentOffset.y > -imageHeight  && tableView.contentOffset.y < -imageHeight/2 {
            headerRect.size.height = -tableView.contentOffset.y
        }
        // keep the image shrinked at the top
        if tableView.contentOffset.y >  -imageHeight/2 {
            headerRect.size.height = imageHeight/2
            TitleText = titlePassed!
            setupNavigationBar()
        }
        headerRect.origin.y = tableView.contentOffset.y
        headerView.frame = headerRect
    }
    
    var TitleText : String = ""
    private func setupNavigationBar() {
        let label = UILabel(frame: CGRectMake(0, 0, 200, 30))
        label.font = UIFont.boldSystemFontOfSize(23.0)
        label.textColor = UIColor.darkGrayColor()
        label.textAlignment = .Center
        label.text = TitleText //"Treatment"
        navigationItem.titleView = label
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
        if indexPath.row == 0{
            cell.Title.text = titlePassed!
            cell.Title.textAlignment = .Center
            cell.Title.textColor = UIColor.darkGrayColor()
            cell.Title.font = UIFont.boldSystemFontOfSize(23.0)
        } else {
        cell.Title.text =  "This Row's number is \(indexPath.row)"
        }
        
        return cell
    }
    
    
    // MARK: - UIScrollView delegate
    
    
    // Update scrollOffset on tableview scroll
     func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
        print ("\(tableView.contentOffset.y)")
    }
   


}
