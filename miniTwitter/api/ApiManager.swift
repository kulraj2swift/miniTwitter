//
//  ApiManager.swift
//  miniTwitter
//
//  Created by kulraj singh on 19/01/23.
//

import Foundation
import OAuthSwift
import KeychainSwift

class APIManager {
    
    private struct Constants {
        static let baseUrl = "https://api.twitter.com"
        static let requestToken = "/oauth/request_token"
        static let authorize = "/oauth/authorize"
        static let accessToken = "/oauth/access_token"
        static let tweets = "/2/tweets"
        static let me = "/2/users/me"
        static let users = "/2/users"
        static let timelines = "/timelines/reverse_chronological"
    }
    
    struct Keys {
        static let expansions = "expansions"
        static let maxResults = "max_results"
        static let mediaFields = "media.fields"
        static let height = "height"
        static let mediaKeys = "attachments.media_keys"
        static let mediaKey = "media_key"
        static let type = "type"
        static let url = "url"
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
    
    func initializeClient() {
        let accessToken = oauth?.client.credential.oauthToken ?? ""
        if accessToken.count > 0 {
            return //already initialized
        }
        let credential = OAuthSwiftCredential.init(consumerKey: ApiKeys.devApiKey, consumerSecret: ApiKeys.devApiSecret)
        let keychain = KeychainSwift()
        credential.oauthToken = keychain.get(KeyChainKeys.accessToken) ?? ""
        credential.oauthTokenSecret = keychain.get(KeyChainKeys.accessTokenSecret) ?? ""
        let client = OAuthSwiftClient.init(credential: credential)
        oauth?.client = client
    }
    
    func getMyIdAndUserName(completion: @escaping (User?, Error?) -> Void) {
        oauth?.client.get(Constants.baseUrl + Constants.me, completionHandler: { result in
            switch result {
            case .success(let response):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data, options: [])
                    if let jsonDict = json as? [String: Any],
                       let userDict = jsonDict["data"] as? [String: Any] {
                        let user = User(dict: userDict)
                        completion(user, nil)
                    } else {
                        let parseError = NSError(domain: "parse error", code: 400)
                        completion(nil, parseError)
                    }
                } catch let jsonError {
                    completion(nil, jsonError)
                }
            case .failure(let error):
                completion(nil, error)
            }
        })
    }
    
    func getTimeline(user: User, maxResults: Int, completion: @escaping (TweetInfo?, Error?) -> Void) {
        let userId = user.userId ?? ""
        //let url = Constants.baseUrl + Constants.users + "/" + userId + Constants.timelines
        let url = Constants.baseUrl + "/2/users/" + userId + "/tweets"
        var params: [String: Any] = [:]
        params[Keys.maxResults] = maxResults
        params[Keys.expansions] = Keys.mediaKeys
        params[Keys.mediaFields] = Keys.mediaKey + "," + Keys.height + "," + Keys.url + "," + Keys.type
        
        oauth?.client.get(url,parameters: params, completionHandler: { result in
            switch result {
            case .success(let response):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data, options: [])
                    if let jsonDict = json as? [String: Any] {
                        var tweetInfo = TweetInfo(dict: jsonDict)
                        completion(tweetInfo, nil)
                    } else {
                        let parseError = NSError(domain: "parse error", code: 400)
                        completion(nil, parseError)
                    }
                } catch let jsonError {
                    completion(nil, jsonError)
                }
            case .failure(let error):
                completion(nil, error)
            }
        })
    }
}
