//
//  YelpFilters.swift
//  Yelp
//
//  Created by Wuming Xie on 9/20/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import Foundation

class YelpFilters {
    
    fileprivate var categories = Set<String>()
    var searchString = ""
    var deals = false
    var sort = YelpSortMode.bestMatched
    var distance = 1600 {
        didSet {
            if distance > Constants.maxDistance {
                distance = Constants.maxDistance
            }
        }
    }
    
    func toggleCategory(_ name: String) {
        if categories.contains(name) {
            categories.remove(name)
        } else {
            categories.insert(name)
        }
    }
}

class FilterState {
    
}
