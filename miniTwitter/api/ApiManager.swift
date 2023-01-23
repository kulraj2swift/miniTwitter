//
//  ApiManager.swift
//  miniTwitter
//
//  Created by kulraj singh on 19/01/23.
//

import Foundation
import KeychainSwift
import OAuthSwift

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
        static let uploadMedia = "https://upload.twitter.com/1.1/media/upload.json"
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
        static let text = "text"
        static let media = "media"
        static let data = "data"
        static let signatureMethod = "HMAC-SHA1"
        static let mediaIds = "media_ids"
    }

    private var environment = Environment.development
    private(set) var oauth: OAuth1Swift?
    private(set) var swifter: Swifter?
    private var keychain = KeychainSwift()
    
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
        credential.oauthToken = keychain.get(KeyChainKeys.accessToken) ?? ""
        credential.oauthTokenSecret = keychain.get(KeyChainKeys.accessTokenSecret) ?? ""
        let client = OAuthSwiftClient.init(credential: credential)
        oauth?.client = client
    }
    
    func initializeSwifter() {
        if swifter != nil {
            return
        }
        guard let oauthToken = keychain.get(KeyChainKeys.accessToken) else {
            return
        }
        guard let oauthSecret = keychain.get(KeyChainKeys.accessTokenSecret) else {
            return
        }
        swifter = Swifter(consumerKey: ApiKeys.devApiKey, consumerSecret: ApiKeys.devApiSecret, oauthToken: oauthToken, oauthTokenSecret: oauthSecret)
    }
    
    func getMyIdAndUserName(completion: @escaping (User?, Error?) -> Void) {
        oauth?.client.get(Constants.baseUrl + Constants.me, completionHandler: { result in
            switch result {
            case .success(let response):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data, options: [])
                    if let jsonDict = json as? [String: Any],
                       let userDict = jsonDict[Keys.data] as? [String: Any] {
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
                        let tweetInfo = TweetInfo(dict: jsonDict)
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
    
    func uploadImageWithSwifter(imageData: Data, completion: @escaping(UploadImageResponse?, Error?) -> Void) {
        swifter?.postMedia(imageData, success: { response in
            let uploadResponse = UploadImageResponse(json: response.object)
            completion(uploadResponse, nil)
        }, failure: { error in
            completion(nil, error)
        })
    }
    
    func uploadImage(imageData: Data, completion: @escaping(Any?, Error?) -> Void) {
        var params: [String: String] = [:]
        params["media_category"] = "TWEET_IMAGE"
        let base64EncodedData = imageData.base64EncodedData()
        
        guard let url = URL(string: Constants.uploadMedia),
            let client = oauth?.client else {
            return
        }

        let boundary = "AS-boundary-\(arc4random())-\(arc4random())"

        let session = URLSession.shared

        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = Method.post.rawValue
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])

        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()
        let paramName = "media_data"
        let fileName = "file"

        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        data.append(base64EncodedData)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        let headers = getHeaders()
        for (key, value) in headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        var authorizationParameters = client.credential.authorizationParameters(data, timestamp: headers[RequestKeys.oauthTimestamp] ?? "", nonce: headers[RequestKeys.oauthNonce] ?? "") as? [String: String] ?? [:]

        authorizationParameters.merge(headers, uniquingKeysWith: {
            (_, last) in last
        })
        
        let signature = client.credential.signature(method: .POST, url: url, parameters: authorizationParameters)
        urlRequest.setValue(signature, forHTTPHeaderField: RequestKeys.oauthSignature)
        
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
                if error == nil {
                    let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                    if let json = jsonData as? [String: Any] {
                        print(json)
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }).resume()
    }
    
    func postTweet(message: String?, imageResponse: UploadImageResponse? = nil, completion: @escaping(Tweet?, Error?) -> Void) {
        let url = Constants.baseUrl + Constants.tweets
        var params: [String: Any] = [:]
        if let message = message {
            params[Keys.text] = message
        }
        if let mediaId = imageResponse?.mediaIdString {
            let mediaDict: [String: Any] = [Keys.mediaIds: [mediaId]]
            params[Keys.media] = mediaDict
        }
        var headers: [String: String] = [:]
        headers["content-type"] = "application/json"
        
        oauth?.client.post(url, parameters: params, headers: headers, completionHandler: { result in
            switch result {
            case .success(let response):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data, options: [])
                    if let jsonDict = json as? [String: Any],
                       let tweetDict = jsonDict[Keys.data] as? [String: Any] {
                        let tweet = Tweet(dict: tweetDict)
                        completion(tweet, nil)
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
