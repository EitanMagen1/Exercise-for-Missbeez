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

    var TitlePassed : String?
    var ImageNumber : Int?
    //Step 1 :To allow us to manage the table header we can't use the tableHeaderView property of UITableView because the table view manages the frame of its table header. We need to create and manage our own view. Add the following property right before items:
    var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // loads the image that was choosen
        
        imageView.image = UIImage(named: String(ImageNumber))
        //view the image
        imageView.startAnimating()

        setupNavigationBar()
        
        //step 2 : take ownership of the header view we've so nicely setup in the storyboard and then remove it from the table view.
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        // step 3 : add reference to the header view ,via headerView ,to the tableView to ensure it is still in the view hierarchy.
        tableView.addSubview(headerView)
        // step 4 : push the contents of the table view down by the height of the header  then set the contentOffset downward by the same amount so we start off with the header view completely visible
        tableView.contentInset = UIEdgeInsets(top: imageHeight, left: 0, bottom: 0, right: 0 )
    
        tableView.contentOffset = CGPoint(x: 0, y: -imageHeight)
        updateHeaderView()

    }
    
    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -imageHeight, width: tableView.bounds.width, height: tableView.bounds.height)
        if tableView.contentOffset.y < imageHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
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
        
        cell.Title.text =  TitlePassed
        return cell
    }
   
    
    // Set the factor for the parallaxEffect. This is overwritable.
   // var parallaxFactor:CGFloat = 2
    
    // Set the default height for the image on the top.
   // let TableHeaderHight : CGFloat = 300.0

    var imageHeight:CGFloat = 300.0 // {
      //  didSet {
           // moveImage()
     //   }
   // }
    
    // Initialize the scrollOffset varaible.
 //   var scrollOffset:CGFloat = 0 {
  //      didSet {
           // moveImage()
//        }
 //   }
    

    override func viewDidLayoutSubviews() {
        
        // Update the image position after layout changes.
      //  moveImage()
    }
    
    // Define method for image location changes.
  //  func moveImage() {
  //      let imageOffset = (scrollOffset >= 0) ? scrollOffset / parallaxFactor : 0
   //     let imageHeight = (scrollOffset >= 0) ? self.imageHeight : self.imageHeight - scrollOffset
   //     imageView.frame = CGRect(x: 0, y: -imageHeight + imageOffset, width: view.bounds.width, height: imageHeight)
   // }
    
    
    // MARK: - UIScrollView delegate
    
    
    // Update scrollOffset on tableview scroll
     func scrollViewDidScroll(scrollView: UIScrollView) {
     //   scrollOffset = tableView.contentOffset.y + imageHeight
        updateHeaderView()
    }
    



}
