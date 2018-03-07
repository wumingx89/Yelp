//
//  BusinessV3.swift
//  Yelp
//
//  Created by Wuming Xie on 9/22/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import Foundation

struct SearchResult: Decodable {
    let businesses: [Business]
}

struct Business: Decodable {
    
    let name: String?
    let rating: Double?
    let price: String?
    let id: String?
    let address: Address?
    let imageURL: URL?
    let categoriesList: [Category]?
    let distanceMeters: Double?
    let reviewCount: Int?
    let coordinates: [String: Double]
    
    private var _distance: String? = nil
    var distance: String? {
        mutating get {
            if _distance == nil {
                _distance = String(format: "%.2f mi", self.distanceMeters!/1609.34)
            }
            
            return _distance
        }
    }
    
    private var _categories: String? = nil
    var categories: String? {
        mutating get {
            if _categories == nil {
                _categories = categoriesList?.map { $0.name }.joined(separator: ", ")
            }
            return _categories
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case name, rating, price, id
        case address = "location"
        case imageURL = "image_url"
        case categoriesList = "categories"
        case distanceMeters = "distance"
        case reviewCount = "review_count"
        case coordinates
    }
}

struct Category: Decodable {
    let alias: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case alias
        case name = "title"
    }
}

struct Address: Decodable {
    let address1: String
    let city: String
    let zipCode: String
    
    enum CodingKeys: String, CodingKey {
        case address1, city
        case zipCode = "zip_code"
    }
}
