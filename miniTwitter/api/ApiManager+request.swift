//
//  ApiManager+request.swift
//  miniTwitter
//
//  Created by kulraj singh on 19/01/23.
//

import Foundation

extension APIManager {
    
    struct RequestKeys {
        static let oauthToken = "oauth_token"
        static let oauthSecret = "oauth_token_secret"
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
    
    func request(urlText: String, params: [String: Any] = [:], method: Method, headers: [String: Any] = [:], completion: @escaping(Any?, Error?) -> Void) {
        guard let url = URL(string: urlText) else {
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
        request.setValue(ApiKeys.accessToken, forHTTPHeaderField: RequestKeys.oauthToken)
        request.setValue(ApiKeys.accessTokenSecret, forHTTPHeaderField: RequestKeys.oauthSecret)
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
