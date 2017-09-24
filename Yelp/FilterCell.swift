//
//  FilterCell.swift
//  Yelp
//
//  Created by Wuming Xie on 9/24/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {
    weak var filters: YelpFilters! {
        didSet {
            filterWasSet()
        }
    }
    var indexPath: IndexPath!
    
    func filterWasSet() {
    }
}
