//
//  String+entension.swift
//  miniTwitter
//
//  Created by kulraj singh on 21/01/23.
//

import Foundation

extension String {
    
    func trim() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
