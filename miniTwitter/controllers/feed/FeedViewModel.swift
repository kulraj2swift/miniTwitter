//
//  FeedViewModel.swift
//  miniTwitter
//
//  Created by kulraj singh on 19/01/23.
//

import Foundation

protocol FeedViewModelDelegate: AnyObject {
    
    func tweetsFetched()
    func failedToFetchTweets(error: Error)
    func failedToGetMyDetails(error: Error)
    func tweetDeleted()
    func failedToDeleteTweet(error: Error)
}

class FeedViewModel {
    
    weak var delegate: FeedViewModelDelegate?
    
    var apiManager: APIManager?
    var user: User?
    var tweetInfo: TweetInfo?
    var tweets: [Tweet] = []
    let maxResults = 20
    
    func initializeClient() {
        apiManager?.initializeClient()
    }
    
    func getMyDetails() {
        apiManager?.getMyIdAndUserName(completion: { [weak self] user, error in
            if let error = error {
                self?.delegate?.failedToGetMyDetails(error: error)
            } else {
                self?.user = user
                self?.getTimeline()
            }
        })
    }
    
    func getTimeline() {
        guard let user = user else {
            let error = NSError(domain: "user not initialized", code: 200)
            delegate?.failedToFetchTweets(error: error)
            return
        }
        apiManager?.getTimeline(user: user, maxResults: maxResults, completion: { [weak self] tweetInfo, error in
            if let error = error {
                self?.delegate?.failedToFetchTweets(error: error)
            } else {
                self?.tweetInfo = tweetInfo
                self?.tweets = tweetInfo?.tweets ?? []
                self?.delegate?.tweetsFetched()
            }
        })
    }
    
    func deletePost(row: Int) {
        if row >= tweets.count { return }
        guard let tweetId = tweets[row].tweetId else { return }
        apiManager?.deleteTweet(tweetId: tweetId, completion: { [weak self] success, error in
            if let error = error {
                self?.delegate?.failedToDeleteTweet(error: error)
            } else if success {
                self?.tweets.remove(at: row)
                self?.tweetInfo?.tweets = self?.tweets ?? []
                self?.delegate?.tweetDeleted()
            } else {
                let failureError = NSError(domain: "didnt get success in response", code: 200)
                self?.delegate?.failedToDeleteTweet(error: failureError)
            }
        })
    }
}
