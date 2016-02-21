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

class RefreshItem {
    // prepare for animation , determine the start and the end off the images
  private var centerStart: CGPoint
  private var centerEnd: CGPoint
  unowned var view: UIView

    // locate the images in the right place acording to the parallax ration , the cat will be at 1 it moves in the same speed as scrolling, the cape at -1 it moves in the negative direction same speed of scrolling etc
  init(view: UIView, centerEnd: CGPoint, parallaxRatio: CGFloat, sceneHeight: CGFloat) {
    self.view = view
    self.centerEnd = centerEnd
    centerStart = CGPoint(x: centerEnd.x,
      y: centerEnd.y + (parallaxRatio * sceneHeight))
    self.view.center = centerStart
  }
// helper method to change the center point acording to the presentage of scrolling
  func updateViewPositionForPercentage(percentage: CGFloat) {
    view.center = CGPoint(
      x: centerStart.x + (centerEnd.x - centerStart.x) * percentage,
      y: centerStart.y + (centerEnd.y - centerStart.y) * percentage)
  }
}
