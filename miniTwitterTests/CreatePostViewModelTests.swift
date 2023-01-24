//
//  CreatePostViewModelTests.swift
//  miniTwitterTests
//
//  Created by kulraj singh on 24/01/23.
//

import XCTest
@testable import miniTwitter

class CreatePostViewModelTests: XCTestCase {

    var viewModel: CreatePostViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = CreatePostViewModel()
    }
    
    func testInitializeSwifter() {
        viewModel.apiManager = APIManager()
        viewModel.initializeSwifter()
        XCTAssertNotNil(viewModel.apiManager?.swifter)
    }
    
    func testPost() {
        viewModel.post(message: nil, imageData: nil)
        
        viewModel.apiManager = ApiManagerSuccess()
        viewModel.post(message: "message", imageData: nil)
        
        viewModel.apiManager = ApiManagerSuccess()
        viewModel.post(message: "message", imageData: Data())
        
        viewModel.apiManager = ApiManagerFailure()
        viewModel.post(message: "message", imageData: Data())
        
        viewModel.apiManager = ApiManagerSuccess()
        viewModel.post(message: "message", imageData: Data())
    }
    
    func testPostTweetWithImage() {
        viewModel.postTweetWithImage(nil, message: "message")
    }
    
    func testCallDelegates() {
        viewModel.apiManager = ApiManagerSuccess()
        let tweet = Tweet(dict: [:])
        viewModel.callDelegates(tweet: tweet, error: nil)
        
        let error = NSError(domain: "some error", code: 500)
        viewModel.callDelegates(tweet: nil, error: error)
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
    }
}
