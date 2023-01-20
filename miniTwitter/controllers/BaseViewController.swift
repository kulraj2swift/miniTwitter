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
        // Do any additional setup after loading the view.
    }
    
    func addRightBarButtonForLogout() {
        let image = UIImage(named: "logoutIcon.pdf")
        let barButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showLogoutConfirmation))
        navigationController?.navigationItem.rightBarButtonItem = barButton
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
