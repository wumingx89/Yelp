//
//  InfiniteScrollActivityView.swift
//  Yelp
//
//  Created by Wuming Xie on 9/22/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

class InfiniteScrollActivityView: UIView {
    
//    var activityIndicatorView = UIActivityIndicatorView()
//    static let defaultHeight = CGFloat(65.0)
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        commonSetup()
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonSetup()
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        activityIndicatorView.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
//    }
//    
//    func animate() {
//        isHidden = false
//        activityIndicatorView.startAnimating()
//    }
//    
//    func stop() {
//        isHidden = true
//        activityIndicatorView.stopAnimating()
//    }
//    
//    private func commonSetup() {
//        activityIndicatorView.activityIndicatorViewStyle = .gray
//        activityIndicatorView.hidesWhenStopped = true
//        self.addSubview(activityIndicatorView)
//        backgroundColor = UIColor.black
//        isHidden = true
//    }
    
    var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    static let defaultHeight:CGFloat = 60.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupActivityIndicator()
    }
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect)
        setupActivityIndicator()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
    }
    
    func setupActivityIndicator() {
        activityIndicatorView.activityIndicatorViewStyle = .gray
        activityIndicatorView.hidesWhenStopped = true
        self.addSubview(activityIndicatorView)
    }
    
    func stopAnimating() {
        self.activityIndicatorView.stopAnimating()
        self.isHidden = true
    }
    
    func startAnimating() {
        self.isHidden = false
        self.activityIndicatorView.startAnimating()
    }
}
