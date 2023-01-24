//
//  HomeViewModel.swift
//  miniTwitter
//
//  Created by kulraj singh on 19/01/23.
//

import Foundation
import OAuthSwift
import KeychainSwift

protocol HomeViewModelDelegate: AnyObject {
    func accessTokenFetched()
    func failedToFetchAccessToken(error: Error)
}

//third party dependency are there so cannot write unit test for this class

class HomeViewModel {
    
    var apiManager: APIManager?
    weak var delegate: HomeViewModelDelegate?
    
    func fetchAccessToken() {
        let callbackUrl = URL(string: "miniSocialApp://home")!
        apiManager?.oauth?.authorize(withCallbackURL: callbackUrl, completionHandler: { [weak self] result in
            switch result {
            case .success(let (credential, _, _)):
                self?.credentialFetched(credential)
            case .failure(let error):
                print(#function + " " + error.localizedDescription)
                self?.delegate?.failedToFetchAccessToken(error: error)
            }
        })
    }
    
    private func credentialFetched(_ credential: OAuthSwiftCredential) {
        let keyChain = KeychainSwift()
        keyChain.set(credential.oauthToken, forKey: KeyChainKeys.accessToken)
        keyChain.set(credential.oauthTokenSecret, forKey: KeyChainKeys.accessTokenSecret)
        keyChain.set(credential.oauthVerifier, forKey: KeyChainKeys.accessTokenVerifier)
        
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.accessTokenFetched()
        }
    }
}
