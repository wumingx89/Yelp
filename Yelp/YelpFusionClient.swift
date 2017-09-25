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
    
    func search(filters: YelpFilters, offset: Int?, completion: @escaping ([Business]?, Error?) -> ()) {
        var params = ["latitude": "37.785771", "longitude": "-122.406165", "limit": "20"]
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
            print(dataTask?.currentRequest?.url?.absoluteString ?? "Bad url")
            completion(nil, error)
        }
    }
}
