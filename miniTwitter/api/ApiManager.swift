//
//  ApiManager.swift
//  miniTwitter
//
//  Created by kulraj singh on 19/01/23.
//

import Foundation
import OAuthSwift
import OhhAuth

class APIManager {
    
    private struct Constants {
        static let baseUrl = "https://api.twitter.com"
        static let requestToken = "/oauth/request_token"
        static let authorize = "/oauth/authorize"
        static let accessToken = "/oauth/access_token"
    }

    private var environment = Environment.development
    private(set) var oauth: OAuth1Swift?
    
    init() {
        oauth = OAuth1Swift(
            consumerKey:    ApiKeys.devApiKey,
            consumerSecret: ApiKeys.devApiSecret,
            requestTokenUrl: Constants.baseUrl + Constants.requestToken,
            authorizeUrl:    Constants.baseUrl + Constants.authorize,
            accessTokenUrl:  Constants.baseUrl + Constants.accessToken
        )
    }
}
