//
//  FeedViewController.swift
//  miniTwitter
//
//  Created by kulraj singh on 19/01/23.
//

import UIKit

class FeedViewController: BaseViewController {

    var viewModel: FeedViewModel?
    @IBOutlet weak var logoutIcon: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        logoutIcon.addTapGesture(target: self, selector: #selector(showLogoutConfirmation))
    }

}
