//
//  YelpFusionClient.swift
//  Yelp
//
//  Created by Wuming Xie on 9/22/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import Foundation

import AFNetworking
import SwiftyJSON

enum YelpEndpoint: String {
    case search = "businesses/search"
    case business = "businesses"
}

class YelpFusionClient: AFHTTPSessionManager {
    
    static let shared = { () -> YelpFusionClient in 
        let client = YelpFusionClient(baseURL: Constants.fusionBaseURL)
        client.requestSerializer.setValue(Constants.clientToken, forHTTPHeaderField: "Authorization")
        return client
    }()
    
    func searchWithFilters(_ filters: YelpFilters) {
        
    }
    
    func searchWithParams(_ params: [String: AnyObject],
                          completion: @escaping ([Business]?, Error?) -> ()) {
        // Default the location to San Francisco
        let params2 = ["term": "dinner" as AnyObject, "latitude": "37.785771" as AnyObject, "longitude": "-122.406165" as AnyObject]
        
        print(params2)
        
        self.get(
            "businesses/search",
            parameters: params2,
            progress: nil,
            success: { (dataTask, response) in
                let json = JSON(response!)
                if let businessArray = json["businesses"].array {
                    completion(Business.businesses(array: businessArray), nil)
                } else {
                    NSLog("No businesses found")
                    completion(nil, nil)
                }
        }) { (dataTask, error) in
            completion(nil, error)
        }
    }
    
    func search(filters: YelpFilters, offset: Int?, completion: @escaping ([Business]?, Error?) -> ()) {
        var params = ["latitude": "37.785771", "longitude": "-122.406165"]
        if let offset = offset {
            params["offset"] = offset.description
        }
        filters.setParams(params: &params)
        
        print(params)
        self.get(
            YelpEndpoint.search.rawValue,
            parameters: params,
            progress: nil,
            success: { (dataTask, response) in
                let json = JSON(response!)
                if let businessArray = json["businesses"].array {
                    completion(Business.businesses(array: businessArray), nil)
                } else {
                    NSLog("No businesses found")
                    completion(nil, nil)
                }
        }) { (dataTask, error) in
            print(dataTask?.currentRequest?.url?.absoluteString)
            completion(nil, error)
        }
    }
}
