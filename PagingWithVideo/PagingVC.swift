//
//  PagingVC.swift
//  Salaat
//
//  Created by Karthick on 5/15/18.
//  Copyright © 2018 Karthick. All rights reserved.
//

import UIKit
import StoreKit
import AVFoundation

class PagingVC: UIViewController,UIScrollViewDelegate
{
  let imagelist = ["1.png","12.png"]
  var scrollView = UIScrollView()
  var pageControl : UIPageControl = UIPageControl()
  var screenWidth = CGFloat()
  var screenHeight = CGFloat()
  
  var avPlayer: AVPlayer!
  var avPlayerLayer: AVPlayerLayer!
  var paused: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.isNavigationBarHidden = true
    screenHeight = self.view.frame.size.height
    screenWidth = self.view.frame.size.width
    let theURL = Bundle.main.url(forResource:"sample_iPod", withExtension: "m4v")
    avPlayer = AVPlayer(url: theURL!)
    avPlayerLayer = AVPlayerLayer(player: avPlayer)
    avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
    avPlayer.volume = 1
    avPlayer.actionAtItemEnd = .none
    
    avPlayerLayer.frame = view.layer.bounds
    view.backgroundColor = .clear
    view.layer.insertSublayer(avPlayerLayer, at: 0)
    NotificationCenter.default.addObserver(self,selector: #selector(playerItemDidReachEnd(notification:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,object: avPlayer.currentItem)
    
    
    scrollView = UIScrollView(frame: CGRect(x: 0, y: -20, width: screenWidth, height: screenHeight+20))
    
    pageControl = UIPageControl(frame: CGRect(x: screenWidth/2-screenWidth/4, y: screenHeight-100, width: screenWidth/2, height: 50))
    scrollView.delegate = self
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.bounces = false
    self.view.addSubview(scrollView)
    
    //PAge control
    configurePageControl()
    for  i in stride(from: 0, to: imagelist.count, by: 1) {
      self.scrollView.isPagingEnabled = true
      let myImage:UIImage = UIImage(named: imagelist[i])!
      let myImageView:UIImageView = UIImageView()
      myImageView.image = myImage
     // myImageView.contentMode = UIViewContentMode.scaleAspectFit
      myImageView.frame = CGRect(x: self.scrollView.frame.size.width * CGFloat(i), y: 0, width: screenWidth, height: screenHeight)
      scrollView.addSubview(myImageView)
    }
    self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * CGFloat(imagelist.count), height: screenHeight-20)
    pageControl.addTarget(self, action: Selector(("changePage:")), for: UIControlEvents.valueChanged)
  }
  
  @objc func playerItemDidReachEnd(notification: Notification) {
    avPlayer.seek(to: kCMTimeZero)
    avPlayer.play()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    avPlayer.pause()
    paused = true
  }
  override func viewWillAppear(_ animated: Bool) {
    avPlayer.play()
    paused = false
    self.navigationController?.isNavigationBarHidden = true
  }
  
  func configurePageControl() {
    self.pageControl.numberOfPages = imagelist.count
    self.pageControl.currentPage = 0
    self.pageControl.tintColor = UIColor.red
    self.pageControl.pageIndicatorTintColor = UIColor.black
    self.pageControl.currentPageIndicatorTintColor = UIColor.green
    self.view.addSubview(pageControl)
  }
  
  // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
  func changePage(sender: AnyObject) -> () {
    let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
    scrollView.setContentOffset(CGPoint(x: x,y :0), animated: true)
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
    pageControl.currentPage = Int(pageNumber)
    print(imagelist.count)
    print(Int(pageNumber))
    if imagelist.count-1 == Int(pageNumber) {
      print("next Page")
      //moveToDashBoard()
    }
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

