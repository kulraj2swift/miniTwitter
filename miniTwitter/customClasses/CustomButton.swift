//
//  CustomButton.swift
//  miniTwitter
//
//  Created by kulraj singh on 18/01/23.
//

import UIKit

class CustomButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        borderColor = .twitterBlue
        tintColor = .white
        borderWidth = 3
        backgroundColor = .twitterBlue
    }
    
    override open var isHighlighted: Bool {
        didSet {
            tintColor = isHighlighted ? . twitterBlue : .white
            backgroundColor = isHighlighted ? .white : .twitterBlue
        }
    }
    
    override var isUserInteractionEnabled: Bool {
        didSet {
            alpha = isUserInteractionEnabled ? 1 : 0.5
        }
    }
}
