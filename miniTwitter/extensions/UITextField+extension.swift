//
//  UITextField+extension.swift
//  twitter
//
//  Created by kulraj singh on 16/01/23.
//

import Foundation
import UIKit

extension UITextField {
    
    func addToolbarWithDoneButton(target: Any, selector: Selector) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: target, action: selector)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        inputAccessoryView = toolBar
    }
    
    func addLeftPadding(_ padding: CGFloat) {
        leftView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: padding, height: frame.height)))
        leftViewMode = .always
    }
    
    func addRightPadding(_ padding: CGFloat) {
        rightView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: padding, height: frame.height)))
        rightViewMode = .always
    }
}
