//
//  ApiManager+request.swift
//  miniTwitter
//
//  Created by kulraj singh on 19/01/23.
//

import Foundation
import KeychainSwift
import OAuthSwift

extension APIManager {
    
    struct RequestKeys {
        static let oauthToken = "oauth_token"
        static let oauthSecret = "oauth_token_secret"
        static let oauthConsumerKey = "oauth_consumer_key"
        static let oauthConsumerSecret = "oauth_consumer_secret"
        static let oauthTimestamp = "oauth_timestamp"
        static let oauthNonce = "oauth_nonce"
        static let oauthSignatureMethod = "oauth_signature_method"
        static let oauthSignature = "oauth_signature"
        static let oauthVersion = "oauth_version"
    }
    
    struct ResponseKeys {
        static let errors = "errors"
        static let message = "message"
        static let code = "code"
    }
}
