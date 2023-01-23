//
//  UItextInput+extension.swift
//  miniTwitter
//
//  Created by kulraj singh on 23/01/23.
//

import Foundation
import UIKit

//common extension for textview and textfield
extension UITextInput {
    
    func addToolbarWithDoneButton(target: Any, selector: Selector) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: target, action: selector)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        if let textfield = self as? UITextField {
            textfield.inputAccessoryView = toolBar
        } else if let textView = self as? UITextView {
            textView.inputAccessoryView = toolBar
        }
    }
}
