//
//  ApiManager.swift
//  miniTwitter
//
//  Created by kulraj singh on 19/01/23.
//

import Foundation

extension APIManager {
    
    enum Environment {

        case development// we can have staging and production in future

        var apiKey: String {
            switch self {
            case .development:
                return ApiKeys.devApiKey
            }
        }
    }
    
    enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
}
