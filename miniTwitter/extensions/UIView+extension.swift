//
//  UIView+extension.swift
//  twitter
//
//  Created by kulraj singh on 15/01/23.
//

import Foundation
import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            if let borderCgColor = layer.borderColor {
                return UIColor(cgColor: borderCgColor)
            }
            return .clear
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    func addTapGesture(target: Any, selector: Selector) {
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: target, action: selector)
        tapGesture.numberOfTapsRequired = 1
        addGestureRecognizer(tapGesture)
    }
    
    func dropShadow(width: CGFloat = 0) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = cornerRadius
        var viewWidth = width
        if width == 0 {
            viewWidth = bounds.width
        }
        let rect = CGRect(x: 0, y: 0, width: viewWidth, height: bounds.height)
        layer.shadowPath = UIBezierPath(rect: rect).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
