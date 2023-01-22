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
    
    func getFullUrl(baseUrl: String, params: [String: Any]) -> URL? {
        var urlText = baseUrl
        if params.keys.count > 0 {
            urlText.append("?")
        }
        for (key, value) in params {
            urlText.append(key)
            urlText.append("=")
            urlText.append("\(value)")
            urlText.append("&")
        }
        return URL(string: urlText)
    }
    
    func getHeaders() -> [String: String] {
        var headers: [String: String] = [:]
        let keychain = KeychainSwift()
        if let accessToken = keychain.get(KeyChainKeys.accessToken)  {
            headers[RequestKeys.oauthToken] = accessToken
        }
//        if let accessSecret = keychain.get(KeyChainKeys.accessTokenSecret) {
//            headers[RequestKeys.oauthSecret] = accessSecret
//        }
        headers[RequestKeys.oauthConsumerKey] = ApiKeys.devApiKey
        //headers[RequestKeys.oauthConsumerSecret] = ApiKeys.devApiSecret
        
        let timestamp = String(Int64(Date().timeIntervalSince1970))
        headers[RequestKeys.oauthTimestamp] = timestamp
        let nonce = OAuthSwiftCredential.generateNonce()
        headers[RequestKeys.oauthNonce] = nonce
        headers[RequestKeys.oauthSignatureMethod] = Keys.signatureMethod
        headers[RequestKeys.oauthVersion] = "1.0"

        return headers
    }
    
    func request(urlText: String, params: [String: Any] = [:], method: Method, headers: [String: Any] = [:], completion: @escaping(Any?, Error?) -> Void) {
        guard let url = URL(string: urlText) else {
            let urlError = NSError(domain: "wrong url", code: 100)
            completion(nil, urlError)
            return
        }
        let keychain = KeychainSwift()
        guard let accessToken = keychain.get(KeyChainKeys.accessToken) else {
            let accessTokenError = NSError(domain: "could not retrieve access token", code: 100)
            completion(nil, accessTokenError)
            return
        }
        guard let accessSecret = keychain.get(KeyChainKeys.accessTokenSecret) else {
            let accessSecretError = NSError(domain: "could not retrieve access secret", code: 100)
            completion(nil, accessSecretError)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if method == .get {
            request.url = getFullUrl(baseUrl: urlText, params: params)
        } else {
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //headers
        request.setValue(ApiKeys.devApiKey, forHTTPHeaderField: RequestKeys.oauthConsumerKey)
        request.setValue(ApiKeys.devApiSecret, forHTTPHeaderField: RequestKeys.oauthConsumerSecret)
        request.setValue(accessToken, forHTTPHeaderField: RequestKeys.oauthToken)
        request.setValue(accessSecret, forHTTPHeaderField: RequestKeys.oauthSecret)
        
        //adding keys and values called from method
        //these will override the values set in this function if passed
        for (key, value) in headers {
            request.setValue(value as? String, forHTTPHeaderField: key)
        }

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            guard let data = data else {
                completion(nil, error)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                if let dict = json as? [String: Any],
                   let errorsDict = dict["errors"] as? [[String: Any]],
                   let errorDict = errorsDict.first {
                    let message = errorDict["message"] as? String ?? ""
                    let code = errorDict["code"] as? Int ?? 0
                    let errorFromServer = NSError(domain: message, code: code)
                    completion(nil, errorFromServer)
                } else {
                    completion(json, nil)
                }
            } catch {
                let parseError = NSError(domain: "parse issue", code: 200)
                completion(nil, parseError)
            }
        })
        task.resume()
    }
}
