//
//  UITextField+extension.swift
//  twitter
//
//  Created by kulraj singh on 16/01/23.
//

import Foundation
import UIKit

extension UITextField {
    
    func addLeftPadding(_ padding: CGFloat) {
        leftView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: padding, height: frame.height)))
        leftViewMode = .always
    }
    
    func addRightPadding(_ padding: CGFloat) {
        rightView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: padding, height: frame.height)))
        rightViewMode = .always
    }
}
