//
//  CreatePostViewModel.swift
//  miniTwitter
//
//  Created by kulraj singh on 21/01/23.
//

import Foundation

protocol CreatePostViewModelDelegate: AnyObject {
    func postSuccess()
    func failedToPost(_ error: Error)
}

class CreatePostViewModel {
    
    weak var delegate: CreatePostViewModelDelegate?
    var apiManager: APIManager?
    var message: String?
    
    func post(message: String?, imageData: Data?) {
        guard message != nil || imageData != nil else {
            //though this condition will never arise due to check in controller
            let error = NSError(domain: "no message or image", code: 200)
            delegate?.failedToPost(error)
            return
        }
        if let imageData = imageData {
            self.message = message
            apiManager?.uploadImage(imageData: imageData, completion: { [weak self] result, error in
                if let error = error {
                    self?.delegate?.failedToPost(error)
                } else {
                    self?.postImageWithMessage()
                }
            })
            return
        }
        apiManager?.postTweet(message: message, completion: { [weak self] tweet, error in
            if tweet?.tweetId != nil {
                //success
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.postSuccess()
                }
            } else if let error = error {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.failedToPost(error)
                }
            }
        })
    }
    
    func postImageWithMessage() {
        
    }
}
