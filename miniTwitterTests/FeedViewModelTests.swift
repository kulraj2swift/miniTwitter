//
//  FeedViewModelTests.swift
//  miniTwitterTests
//
//  Created by kulraj singh on 24/01/23.
//

//this class uses protocol oriented testing approach

import XCTest
@testable import miniTwitter

class FeedViewModelTests: XCTestCase {
    
    var viewModel: FeedViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = FeedViewModel()
        viewModel.apiManager = MockRequestManager()
    }
    
    func testInitializeApi() {
        viewModel.initializeClient()
        XCTAssertNotNil(viewModel.apiManager)
    }
    
    func testGetMyDetails() {
        viewModel.user = nil
        viewModel.getMyDetails()
        XCTAssertNil(viewModel.user)
        
        viewModel.user = User(dict: ["id": "123"])
        viewModel.getMyDetails()
        //XCTAssertNotNil(viewModel.user?.userId)
    }
    
    func testGetTimeline() {
        viewModel.user = nil
        viewModel.getTimeline()
        
        viewModel.user = User(dict: [:])
        viewModel.tweetInfo = nil
        viewModel.getTimeline()
        XCTAssertNil(viewModel.tweetInfo)
        
        var tweetInfo = TweetInfo(dict: [:])
        tweetInfo.tweets.append(Tweet(dict: [:]))
        let apiManager = MockRequestManager()
        apiManager.tweetInfo = tweetInfo
        viewModel.apiManager = apiManager
        viewModel.getTimeline()
        XCTAssertNotNil(viewModel.tweetInfo)
        XCTAssert(viewModel.tweets.count == 1)
        
        tweetInfo.tweets.append(Tweet(dict: [:]))
        apiManager.tweetInfo = tweetInfo
        viewModel.apiManager = apiManager
        viewModel.getTimeline(shouldFetchMore: true)
        //XCTAssert(viewModel.tweets.count == 2)
    }
    
    func testDeletePost() {
        viewModel.tweetInfo = nil
        viewModel.user = User(dict: [:])
        viewModel.getTimeline()
        viewModel.deletePost(row: 10)
        
        viewModel.deletePost(row: 0)
        
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

