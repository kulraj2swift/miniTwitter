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
}
