/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
// protocol that lets the delegate know the user wants to refresh the data
protocol RefreshViewDelegate: class {
    func refreshViewDidRefresh(refreshView: RefreshView)
}
// the hieght of the pull to refresh sceen
private let sceneHeight: CGFloat = 120

class RefreshView: UIView {
    private unowned var scrollView: UIScrollView
    
    // property to keep track of the persentage wise we pulled down
    var progressPercentage: CGFloat = 0
    weak var delegate: RefreshViewDelegate?
    // indicates if we are refreshing right now or not
    var isRefreshing = false
    
    // holds the refresh items objects we created
    var refreshItems = [RefreshItem]()
    
    required init?(coder aDecoder: NSCoder) {
        scrollView = UIScrollView()
        assert(false, "use init(frame:scrollView:)")
        super.init(coder: aDecoder)
    }
    //set initializer
    init(frame: CGRect, scrollView: UIScrollView) {
        self.scrollView = scrollView
        super.init(frame: frame)
        clipsToBounds = true
        // scroll is 0 so set the background color to 0.2 dark gray
        updateBackgroundColor()
        setupRefreshItems()
    }
    // helper method to load the objects
    func setupRefreshItems() {
        
        // create the images from the assets library
        let groundImageView = UIImageView(image: UIImage(named: "ground"))
        let buildingsImageView = UIImageView(image: UIImage(named: "buildings"))
        let sunImageView = UIImageView(image: UIImage(named: "sun"))
        let catImageView = UIImageView(image: UIImage(named: "girl1"))
        let capeBackImageView = UIImageView(image: UIImage(named: "house2"))
        let capeFrontImageView = UIImageView(image: UIImage(named: "serviceGirl1"))
        
        refreshItems = [
            // view : setting the image , centerEND : X: centered horizontaly , Y: get the height of the bounds of the current view which is the refresh view and go up by half of the size to reach the middle , parralex ration will determane the speed of movement of the view
            // we want the building to end up above the ground there for we go up by the height of the ground CGRectGetHeight(groundImageView.bounds)
            RefreshItem(view: buildingsImageView,
                centerEnd: CGPoint(x: CGRectGetMidX(bounds),
                    y: CGRectGetHeight(bounds) - CGRectGetHeight(groundImageView.bounds) - CGRectGetHeight(buildingsImageView.bounds) / 2),
                parallaxRatio: 1.5, sceneHeight: sceneHeight),
            RefreshItem(view: sunImageView,
                centerEnd: CGPoint(x: CGRectGetWidth(bounds) * 0.1,
                    y: CGRectGetHeight(bounds) - CGRectGetHeight(groundImageView.bounds) - CGRectGetHeight(sunImageView.bounds)),
                parallaxRatio: 3, sceneHeight: sceneHeight),
            RefreshItem(view: groundImageView,
                centerEnd: CGPoint(x: CGRectGetMidX(bounds),
                    y: CGRectGetHeight(bounds) - CGRectGetHeight(groundImageView.bounds)/2),
                parallaxRatio: 0.5, sceneHeight: sceneHeight),
            RefreshItem(view: capeBackImageView, centerEnd: CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetHeight(bounds) - CGRectGetHeight(groundImageView.bounds)/2 - CGRectGetHeight(capeBackImageView.bounds)/2), parallaxRatio: -1, sceneHeight: sceneHeight),
            RefreshItem(view: catImageView, centerEnd: CGPoint(x: CGRectGetMidX(bounds)-10, y: CGRectGetHeight(bounds) - CGRectGetHeight(groundImageView.bounds)/2 - CGRectGetHeight(catImageView.bounds)/2), parallaxRatio: 1, sceneHeight: sceneHeight),
            RefreshItem(view: capeFrontImageView, centerEnd: CGPoint(x: CGRectGetMidX(bounds)+10, y: CGRectGetHeight(bounds) - CGRectGetHeight(groundImageView.bounds)/2 - CGRectGetHeight(capeFrontImageView.bounds)/2), parallaxRatio: -1, sceneHeight: sceneHeight),
        ]
        // building the image as layers of subviews , the order matters , we start with the building , sun , ground , cape , cat , capefront
        for refreshItem in refreshItems {
            addSubview(refreshItem.view)
        }
    }
    // changes the bakground image color from dark gray 0.2 to light gray 0.9 as the progress grows
    func updateBackgroundColor() {
        let value = progressPercentage * 0.7 + 0.2
        backgroundColor = UIColor(red: value, green: value, blue: value, alpha: 1.0)
    }
    // helper method to update the position of all of the images as we scroll
    func updateRefreshItemPositions() {
        for refreshItem in refreshItems {
            refreshItem.updateViewPositionForPercentage(progressPercentage)
        }
    }
    
    func beginRefreshing() {
        //set flag
        isRefreshing = true
        
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.scrollView.contentInset.top += sceneHeight
            }, completion: { (_) -> Void in
        })
    }
    // undo the change of contact inset
    func endRefreshing() {
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.scrollView.contentInset.top -= sceneHeight
            }, completion: { (_) -> Void in
                self.isRefreshing = false
        })
    }
    
}

extension RefreshView: UIScrollViewDelegate {
    // when the user lifts his finger this method will be called
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // are we already refreshing? no! and the progress presentage is 100%
        if !isRefreshing && progressPercentage == 1 {
            // beginfrereshing calculates the contentInset.top and we will pass it to the memory y location
            beginRefreshing()
            // changing the y value for the target
            targetContentOffset.memory.y = -scrollView.contentInset.top
            delegate?.refreshViewDidRefresh(self)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if isRefreshing {
            return
        }
        
        let refreshViewVisibleHeight = max(0, -(scrollView.contentOffset.y + scrollView.contentInset.top))
        //calculate the scroll percentage from 0 to 1 , the output is min 0 max 1
        progressPercentage = min(1, refreshViewVisibleHeight / sceneHeight)
        
        updateBackgroundColor()
        //update the center location each time a scroll has benn called
        updateRefreshItemPositions()
    }
}
