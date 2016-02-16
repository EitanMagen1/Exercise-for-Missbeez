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

    var TitlePassed : String = ""
    var ImageNumber : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Set the contentInset to make room for the image.
        self.tableView.contentInset = UIEdgeInsets(top: imageHeight, left: 0, bottom: 0, right: 0)

        // Change the contentMode for the ImageView.
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        // Add the imageView to the TableView and send it to the back.
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
        
        imageView.image = UIImage(named: String(ImageNumber))
        setupNavigationBar()

    }
    private func setupNavigationBar() {
        let label = UILabel(frame: CGRectMake(0, 0, 200, 30))
        label.font = UIFont.boldSystemFontOfSize(21.0)
        label.textColor = UIColor.darkGrayColor()
        label.textAlignment = .Center
        label.text = "Treatment"
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
        
        cell.Title.text =  TitlePassed
        return cell
    }
   
       // Set the factor for the parallaxEffect. This is overwritable.
    var parallaxFactor:CGFloat = 2
    
    // Set the default height for the image on the top.
    var imageHeight:CGFloat = 300 {
        didSet {
            moveImage()
        }
    }
    
    // Initialize the scrollOffset varaible.
    var scrollOffset:CGFloat = 0 {
        didSet {
            moveImage()
        }
    }
    

    override func viewDidLayoutSubviews() {
        
        // Update the image position after layout changes.
        moveImage()
    }
    
    // Define method for image location changes.
    func moveImage() {
        let imageOffset = (scrollOffset >= 0) ? scrollOffset / parallaxFactor : 0
        let imageHeight = (scrollOffset >= 0) ? self.imageHeight : self.imageHeight - scrollOffset
        imageView.frame = CGRect(x: 0, y: -imageHeight + imageOffset, width: view.bounds.width, height: imageHeight)
    }
    
    
    // MARK: - UIScrollView delegate
    
    
    // Update scrollOffset on tableview scroll
     func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollOffset = tableView.contentOffset.y + imageHeight
    }
    



}
