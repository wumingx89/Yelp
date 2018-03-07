//
//  YelpFusionClient.swift
//  Yelp
//
//  Created by Wuming Xie on 9/22/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import Foundation
import Alamofire

enum YelpEndpoint: URLConvertible {
    case search
    case business
    
    var path: String {
        switch self {
        case .search: return "businesses/search"
        case .business: return "businesses"
        }
    }
    
    func asURL() throws -> URL {
        return Constants.fusionBaseURL!.appendingPathComponent(self.path)
    }
}

class YelpFusionClient {
    static let shared = YelpFusionClient()
    private static let headers: HTTPHeaders = ["Authorization": Constants.clientToken]
    
    func search(filters: YelpFilters, offset: Int?, completion: @escaping ([Business]?, Error?) -> ()) {
        var params: [String: Any] = ["latitude": "37.785771", "longitude": "-122.406165", "limit": "20"]
        if let offset = offset {
            params["offset"] = offset.description
        }
        filters.setParams(params: &params)
        
        Alamofire.request(
            YelpEndpoint.search,
            method: .get,
            parameters: params,
            encoding: Alamofire.URLEncoding.default,
            headers: YelpFusionClient.headers
        ).responseData { dataResponse in
            switch dataResponse.result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(SearchResult.self, from: data)
                    completion(result.businesses, nil)
                } catch let decoderError {
                    completion(nil, decoderError)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
