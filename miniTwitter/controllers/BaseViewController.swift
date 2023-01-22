//
//  BaseViewController.swift
//  miniTwitter
//
//  Created by kulraj singh on 19/01/23.
//

import UIKit
import KeychainSwift

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addRightBarButtonForLogout()
    }
    
    func addRightBarButtonForLogout() {
        let image = UIImage(named: "logoutIcon.pdf")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        imageView.addTapGesture(target: self, selector: #selector(showLogoutConfirmation))
        let containerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
        containerView.addSubview(imageView)
        let barButton = UIBarButtonItem(customView: containerView)
        navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func showLogoutConfirmation(_ sender: Any) {
        let alertController = UIAlertController(title: "Are you sure?", message: "This will log you out of the app.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true, completion: { [weak self] in
                self?.logout()
            })
        })
        alertController.addAction(alertAction)
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: { [weak self] _ in
            self?.dismiss(animated: true)
        })
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func logout() {
        let keychain = KeychainSwift()
        keychain.delete(KeyChainKeys.accessToken)
        keychain.delete(KeyChainKeys.accessTokenSecret)
        keychain.delete(KeyChainKeys.accessTokenVerifier)
        
        //show login screen
        let homeViewController = HomeViewController(nibName: "HomeViewController", bundle: nil)
        let viewModel = HomeViewModel()
        viewModel.apiManager = APIManager()
        homeViewController.viewModel = viewModel
        navigationController?.setViewControllers([homeViewController], animated: true)
    }

}
