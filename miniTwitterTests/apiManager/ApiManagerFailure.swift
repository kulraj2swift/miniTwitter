//
//  ApiManagerFailure.swift
//  miniTwitterTests
//
//  Created by kulraj singh on 24/01/23.
//

import Foundation
@testable import miniTwitter

class ApiManagerFailure: APIManager {
    
    override func getMyIdAndUserName(completion: @escaping (User?, Error?) -> Void) {
        let error = NSError(domain: "some error", code: 500)
        completion(nil, error)
    }
    
    override func getTimeline(user: User, maxResults: Int, nextToken: String? = nil, completion: @escaping (TweetInfo?, Error?) -> Void) {
        let error = NSError(domain: "some error", code: 500)
        completion(nil, error)
    }

    override func deleteTweet(tweetId: String, completion: @escaping (Bool, Error?) -> Void) {
        let error = NSError(domain: "some error", code: 500)
        completion(false, error)
    }
    
    override func uploadImageWithSwifter(imageData: Data, completion: @escaping (UploadImageResponse?, Error?) -> Void) {
        let error = NSError(domain: "some error", code: 500)
        completion(nil, error)
    }
}
