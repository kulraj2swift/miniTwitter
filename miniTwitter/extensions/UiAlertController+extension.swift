//
//  UiAlertController+extension.swift
//  miniTwitter
//
//  Created by kulraj singh on 19/01/23.
//

import Foundation
import UIKit

extension UIAlertController {
    
    class func showAlert(title: String? = nil, message: String? = nil, controller: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            controller.dismiss(animated: true)
        })
        alertController.addAction(alertAction)
        controller.present(alertController, animated: true)
    }
}
