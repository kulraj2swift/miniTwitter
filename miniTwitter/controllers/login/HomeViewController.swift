//
//  HomeViewController.swift
//  miniTwitter
//
//  Created by kulraj singh on 18/01/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var loginButton: CustomButton!
    @IBOutlet weak var signupButton: CustomButton!

    var viewModel: HomeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.delegate = self
    }
    
    @IBAction func loginOrSignupTapped(_ sender: UIButton) {
        viewModel?.fetchAccessToken()
    }

}

extension HomeViewController: HomeViewModelDelegate {
    func accessTokenFetched() {
        let feedViewController = FeedViewController(nibName: "FeedViewController", bundle: nil)
        let feedViewModel = FeedViewModel()
        feedViewModel.apiManager = viewModel?.apiManager
        feedViewController.viewModel = feedViewModel
        navigationController?.pushViewController(feedViewController, animated: true)
    }
    
    func failedToFetchAccessToken(error: Error) {
        UIAlertController.showAlert(message: error.localizedDescription, controller: self)
    }
    
    
}
