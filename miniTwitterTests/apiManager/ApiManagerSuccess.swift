//
//  ApiManagerSuccess.swift
//  miniTwitterTests
//
//  Created by kulraj singh on 24/01/23.
//
import Foundation
@testable import miniTwitter

class ApiManagerSuccess: APIManager {

    override func getMyIdAndUserName(completion: @escaping (User?, Error?) -> Void) {
        var user = User(dict: [:])
        user.userId = "1234"
        completion(user, nil)
    }
    
    override func getTimeline(user: User, maxResults: Int, nextToken: String? = nil, completion: @escaping (TweetInfo?, Error?) -> Void) {
        var tweetInfo = TweetInfo(dict: [:])
        var tweet = Tweet(dict: [:])
        tweet.tweetId = "12345"
        tweetInfo.tweets = [tweet]
        completion(tweetInfo, nil)
    }
    
    override func deleteTweet(tweetId: String, completion: @escaping (Bool, Error?) -> Void) {
        completion(true, nil)
    }
    
    override func uploadImageWithSwifter(imageData: Data, completion: @escaping (UploadImageResponse?, Error?) -> Void) {
        let response = UploadImageResponse(json: [:])
        completion(response, nil)
    }
    
    override func postTweet(message: String?, imageResponse: UploadImageResponse? = nil, completion: @escaping (Tweet?, Error?) -> Void) {
        var tweet = Tweet(dict: [:])
        tweet.tweetId = "1234"
        completion(tweet, nil)
    }
}
