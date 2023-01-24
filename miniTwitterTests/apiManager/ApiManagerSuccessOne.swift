//
//  ApiManagerSuccessOne.swift
//  miniTwitterTests
//
//  Created by kulraj singh on 24/01/23.
//

@testable import miniTwitter

class ApiManagerSuccessOne: APIManager {
    
    override func deleteTweet(tweetId: String, completion: @escaping (Bool, Error?) -> Void) {
        completion(false, nil)
    }

}
