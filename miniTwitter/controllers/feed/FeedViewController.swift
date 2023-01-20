//
//  FeedViewController.swift
//  miniTwitter
//
//  Created by kulraj singh on 19/01/23.
//

import UIKit

class FeedViewController: BaseViewController {

    struct Constants {
        static let tweetCellIdentifier = "FeedTableViewCell"
        static let defaultCellIdentifier = "defaultCellIdentifer"
    }
    
    var viewModel: FeedViewModel?
    @IBOutlet weak var logoutIcon: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noPostsLabel: UILabel!
    @IBOutlet weak var createPostButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var postsTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.delegate = self
        logoutIcon.addTapGesture(target: self, selector: #selector(showLogoutConfirmation))
        viewModel?.initializeClient()
        activityIndicator.startAnimating()
        viewModel?.getMyDetails()
        hideAll()
        registerCells()
    }
    
    func registerCells() {
        postsTable.register(UINib(nibName: Constants.tweetCellIdentifier, bundle: nil), forCellReuseIdentifier: Constants.tweetCellIdentifier)
        postsTable.register(UITableViewCell.self, forCellReuseIdentifier: Constants.defaultCellIdentifier)
    }
    
    func hideAll() {
        postsTable.isHidden = true
        createPostButton.isHidden = true
        noPostsLabel.isHidden = true
        plusButton.isHidden = true
    }
    
    @IBAction func createPostClicked(_ sender: Any) {
        //go to next screen
    }

}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.tweets.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else {
            return tableView.dequeueReusableCell(withIdentifier: Constants.defaultCellIdentifier)!
        }
        let tweet = viewModel.tweets[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tweetCellIdentifier, for: indexPath) as! FeedTableViewCell
        cell.tweet = tweet
        return cell
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension FeedViewController: FeedViewModelDelegate {
    func tweetsFetched() {
        activityIndicator.stopAnimating()
        refreshUi()
    }
    
    func refreshUi() {
        if let count = viewModel?.tweets.count,
           count > 0 {
            noPostsLabel.isHidden = true
            createPostButton.isHidden = true
            postsTable.isHidden = false
            postsTable.reloadData()
            plusButton.isHidden = false
        } else {
            noPostsLabel.isHidden = false
            createPostButton.isHidden = false
            postsTable.isHidden = true
            plusButton.isHidden = true
        }
    }
    
    func failedToFetchTweets(error: Error) {
        activityIndicator.stopAnimating()
        UIAlertController.showAlert(title: "Failed to fetch tweets", controller: self)
        print(#function + " " + error.localizedDescription)
    }
    
    func failedToGetMyDetails(error: Error) {
        activityIndicator.stopAnimating()
        UIAlertController.showAlert(title: "Failed to get my details", controller: self)
        print(#function + " " + error.localizedDescription)
    }
    
    
}
