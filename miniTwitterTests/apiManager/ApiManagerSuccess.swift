//
//  ApiManagerSuccess.swift
//  miniTwitterTests
//
//  Created by kulraj singh on 24/01/23.
//
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
}
