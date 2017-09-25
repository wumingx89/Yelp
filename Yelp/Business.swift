//
//  BusinessV3.swift
//  Yelp
//
//  Created by Wuming Xie on 9/22/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import Foundation
import SwiftyJSON

class Business: NSObject {
    
    let name: String?
    let rating: Double!
    let price: String?
    let id: String?
    let address: String?
    let imageURL: URL?
    let categories: String?
    let distance: String?
    let reviewCount: Int!
    var coordinates: [String: Double?]
    
    init(json: JSON) {
        name = json["name"].string
        rating = json["rating"].double ?? 0.0
        price = json["price"].string
        id = json["id"].string
        address = json["location"]["address1"].string
        reviewCount = json["review_count"].int ?? 0
        
        if let urlString = json["image_url"].string {
            imageURL = URL(string: urlString)!
        } else {
            imageURL = nil
        }
        
        if let categoriesArray = json["categories"].array {
            var names = [String]()
            for category in categoriesArray {
                if let name = category["title"].string {
                    names.append(name)
                }
            }
            categories = names.joined(separator: ", ")
        } else {
            categories = nil
        }
        
        if let distanceMeters = json["distance"].double {
            distance = String.init(format: "%.2f mi", distanceMeters/1609.34)
        } else {
            distance = nil
        }
        
        coordinates = [:]
        if let coords = json["coordinates"].dictionary {
            coordinates["latitude"] = coords["latitude"]?.double
            coordinates["longitude"] = coords["longitude"]?.double
        }
    }
    
    static func businesses(array: [JSON]) -> [Business] {
        var businesses = [Business]()
        for businessJson in array {
            businesses.append(Business(json: businessJson))
        }
        return businesses
    }
    
    public override var description: String {
        return "Business:" +
            "\n\tname:\(name ?? "")" +
            "\n\trating:\(rating ?? 0)" +
            "\n\tprice:\(price ?? "")" +
            "\n\tid:\(id ?? "")" +
            "\n\taddress:\(address ?? "")" +
            "\n\tdistance:\(distance ?? "")" +
            "\n\tcategories:\(categories ?? "")" +
            "\n\treviews:\(reviewCount ?? 0)"
    }
}
