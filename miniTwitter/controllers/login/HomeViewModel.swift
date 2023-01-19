//
//  HomeViewModel.swift
//  miniTwitter
//
//  Created by kulraj singh on 19/01/23.
//

import Foundation
import OAuthSwift
import Security

protocol HomeViewModelDelegate: AnyObject {
    func accessTokenFetched()
    func failedToFetchAccessToken(error: Error)
}

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
        DispatchQueue.main.async { [weak self] in
            let isTokenSaved = KeyChain.save(key: KeyChainKeys.accessToken, data: Data.init(value: credential.oauthToken))
            let isSecretSaved = KeyChain.save(key: KeyChainKeys.accessTokenSecret, data: Data.init(value: credential.oauthTokenSecret))
            let isVerifierSaved = KeyChain.save(key: KeyChainKeys.accessTokenVerifier, data: Data.init(value: credential.oauthVerifier))
            if isTokenSaved == noErr,
               isSecretSaved == noErr,
               isVerifierSaved == noErr {
                self?.delegate?.accessTokenFetched()
            } else {
                let saveError = NSError(domain: "error in saving to keychain", code: 200)
                self?.delegate?.failedToFetchAccessToken(error: saveError)
            }
        }
    }
}
