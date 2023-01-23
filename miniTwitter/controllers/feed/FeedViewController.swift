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
    private let refreshControl = UIRefreshControl()

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noPostsLabel: UILabel!
    @IBOutlet weak var createPostButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var postsTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.delegate = self
        viewModel?.initializeClient()
        activityIndicator.startAnimating()
        viewModel?.getMyDetails()
        navigationItem.title = "My Posts"
        hideAll()
        registerCells()
        createRefreshView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        plusButton.dropShadow()
    }
    
    func createRefreshView() {
        postsTable.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    }
    
    @objc func refresh(_ sender: Any) {
        viewModel?.getTimeline()
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
        let createPostViewController = CreatePostViewController(nibName: "CreatePostViewController", bundle: nil)
        let createPostViewModel = CreatePostViewModel()
        createPostViewModel.apiManager = viewModel?.apiManager
        createPostViewController.viewModel = createPostViewModel
        navigationController?.pushViewController(createPostViewController, animated: true)
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
        cell.onDelete = { [weak self] in
            self?.showAlertForDelete(tweetRow: indexPath.row)
        }
        return cell
    }
    
    func showAlertForDelete(tweetRow: Int) {
        let alertController = UIAlertController(title: "Warning!", message: "This will delete the post. Do you want to proceed?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true)
        })
        alertController.addAction(cancelAction)
        let okAction = UIAlertAction(title: "Delete post", style: .destructive, handler: { [weak self] _ in self?.activityIndicator.startAnimating()
            self?.viewModel?.deletePost(row: tweetRow)
        })
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {
            return
        }
        if indexPath.row == viewModel.tweets.count - 1,
           viewModel.canDisplayMoreTweets() {
            activityIndicator.startAnimating()
            viewModel.getTimeline(shouldFetchMore: true)
        }
    }
}

extension FeedViewController: FeedViewModelDelegate {
    
    func tweetDeleted() {
        activityIndicator.stopAnimating()
        refreshUi()
    }
    
    func failedToDeleteTweet(error: Error) {
        UIAlertController.showAlert(title: "Failed to delete", controller: self)
        activityIndicator.stopAnimating()
        print(#function + " " + error.localizedDescription)
    }
    
    func tweetsFetched() {
        activityIndicator.stopAnimating()
        refreshControl.endRefreshing()
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
