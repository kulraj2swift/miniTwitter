//
//  FeedViewModelTests.swift
//  miniTwitterTests
//
//  Created by kulraj singh on 24/01/23.
//

import XCTest
@testable import miniTwitter

class FeedViewModelTests: XCTestCase {
    
    var viewModel: FeedViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = FeedViewModel()
    }
    
    func testInitializeApi() {
        viewModel.apiManager = APIManager()
        viewModel.initializeClient()
        XCTAssertNotNil(viewModel.apiManager)
    }
    
    func testGetMyDetails() {
        viewModel.apiManager = ApiManagerFailure()
        viewModel.user = nil
        viewModel.getMyDetails()
        XCTAssertNil(viewModel.user)
        
        viewModel.user = nil
        viewModel.apiManager = ApiManagerSuccess()
        viewModel.getMyDetails()
        XCTAssertNotNil(viewModel.user?.userId)
    }
    
    func testGetTimeline() {
        viewModel.user = nil
        viewModel.getTimeline()
        
        viewModel.user = User(dict: [:])
        viewModel.apiManager = ApiManagerFailure()
        viewModel.tweetInfo = nil
        viewModel.getTimeline()
        XCTAssertNil(viewModel.tweetInfo)
        
        viewModel.apiManager = ApiManagerSuccess()
        viewModel.tweetInfo = nil
        viewModel.getTimeline()
        XCTAssertNotNil(viewModel.tweetInfo)
        XCTAssert(viewModel.tweets.count == 1)
        
        viewModel.getTimeline(shouldFetchMore: true)
        XCTAssert(viewModel.tweets.count == 2)
    }
    
    func testDeletePost() {
        viewModel.tweetInfo = nil
        viewModel.apiManager = ApiManagerSuccess()
        viewModel.user = User(dict: [:])
        viewModel.getTimeline()
        viewModel.deletePost(row: 10)
        
        viewModel.apiManager = ApiManagerFailure()
        viewModel.deletePost(row: 0)
        
        viewModel.apiManager = ApiManagerSuccess()
        viewModel.deletePost(row: 0)
        XCTAssert(viewModel.tweets.count == 0)
    }
    
    func testCanDisplayMoreTweets() {
        var meta = Meta(dict: [:])
        meta.nextToken = "jj"
        var tweetInfo = TweetInfo(dict: [:])
        tweetInfo.meta = meta
        viewModel.tweetInfo = tweetInfo
        var canDisplayMore = viewModel.canDisplayMoreTweets()
        XCTAssertTrue(canDisplayMore)
        
        viewModel.tweetInfo = nil
        canDisplayMore = viewModel.canDisplayMoreTweets()
        XCTAssertFalse(canDisplayMore)
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
    }

}
