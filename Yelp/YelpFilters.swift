//
//  YelpFilters.swift
//  Yelp
//
//  Created by Wuming Xie on 9/20/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import Foundation

class YelpFilters {
    
    enum FilterName: String {
        case deal = "Offering a Deal"
        case tenBlocks = "10 blocks"
        case oneMile = "1 mile"
        case fiveMiles = "5 miles"
        case bestMatch = "Best Match"
        
        static let distances = [tenBlocks, oneMile, fiveMiles]
    }
    
    var searchString = ""
    var deals = false
    fileprivate var categories = Set<String>()
    
    
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
