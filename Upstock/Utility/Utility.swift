//
//  Utility.swift
//  Upstock
//
//  Created by Nikita Arora on 19/11/24.
//

import UIKit

struct Utility {
    
    static func getAttrString(s1: String, s2: String, color: UIColor, color2: UIColor? = nil, size1: CGFloat, size2: CGFloat) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(
            string: "\(s1)",
            attributes: [
                .foregroundColor: color,
                .font: UIFont.systemFont(ofSize: size1, weight: .semibold)
            ]
        )
        attributedText.append(
            NSAttributedString(
                string: "\(s2)",
                attributes: [
                    .foregroundColor: color2 != nil ? color2! : color,
                    .font: UIFont.systemFont(ofSize: size2)
                ]
            )
        )
        return attributedText
    }
    
}
