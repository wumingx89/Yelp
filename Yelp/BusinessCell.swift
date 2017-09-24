//
//  BusinessCell.swift
//  Yelp
//
//  Created by Wuming Xie on 9/19/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
    
    static let ratingImages = [
        0.0: #imageLiteral(resourceName: "small_0"),
        1.0: #imageLiteral(resourceName: "small_1"),
        1.5: #imageLiteral(resourceName: "small_1_half"),
        2.0: #imageLiteral(resourceName: "small_2"),
        2.5: #imageLiteral(resourceName: "small_2_half"),
        3.0: #imageLiteral(resourceName: "small_3"),
        3.5: #imageLiteral(resourceName: "small_3_half"),
        4.0: #imageLiteral(resourceName: "small_4"),
        4.5: #imageLiteral(resourceName: "small_4_half"),
        5.0: #imageLiteral(resourceName: "small_5")
    ]

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    fileprivate var resultNumber: Int!
    fileprivate var business: Business! {
        didSet {
            nameLabel.text = "\(resultNumber + 1). \(business.name ?? "")"
            thumbImageView.setImageWith(business.imageURL!)
            ratingImageView.image = BusinessCell.ratingImages[business.rating]
            distanceLabel.text = business.distance
            priceLabel.text = business.price
            addressLabel.text = business.address
            reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
            categoriesLabel.text = business.categories
        }
    }
    
    func setCell(business: Business, number: Int) {
        self.resultNumber = number
        self.business = business
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Make image corners rounded
        thumbImageView.layer.cornerRadius = 5
        thumbImageView.clipsToBounds = true
        
        // Set selection type
        selectionStyle = .none
    }
}
