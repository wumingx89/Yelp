//
//  BusinessCell.swift
//  Yelp
//
//  Created by Wuming Xie on 9/19/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    fileprivate var resultNumber: Int!
    fileprivate var business: Business! {
        didSet {
            nameLabel.text = "\(resultNumber + 1). \(business.name ?? "")"
            thumbImageView.setImageWith(business.imageURL!)
            ratingImageView.setImageWith(business.ratingImageURL!)
            distanceLabel.text = business.distance
            addressLabel.text = business.address
            reviewsCountLabel.text = business.reviewCount!.stringValue + " Reviews"
            categoriesLabel.text = business.categories
        }
    }
    
    func setCell(business: Business, number: Int) {
        self.resultNumber = number
        self.business = business
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        thumbImageView.layer.cornerRadius = 5
        thumbImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
