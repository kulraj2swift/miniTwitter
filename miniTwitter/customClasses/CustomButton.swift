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
        tintColor = .twitterBlue
        borderWidth = 3
    }
    
    override open var isHighlighted: Bool {
        didSet {
            tintColor = isHighlighted ? .white : .twitterBlue
            backgroundColor = isHighlighted ? .twitterBlue : .white
        }
    }
}
