//
//  TextStyle.swift
//  Pyaterochka
//
//  Created by KonstEmelyantsev on 07/02/2019.
//  Copyright © 2019 Zeno Inc. All rights reserved.
//

import UIKit

protocol TextStyleProtocol {
    var attributes: [NSAttributedString.Key : Any] { get }
}

struct TextStyle: TextStyleProtocol {
    let attributes: [NSAttributedString.Key : Any]
    
    init(attributes: [NSAttributedString.Key : Any]) {
        self.attributes = attributes
    }
    
    init(textColor: UIColor,
         font: UIFont,
         textAlignment: NSTextAlignment = .left,
         kern: Double = 0) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        self.init(attributes: [.foregroundColor: textColor, .font: font, .paragraphStyle: paragraphStyle, .kern: kern])
    }
    
    
}

extension TextStyle {
    static let listTitle = TextStyle(textColor: Color.white, font: UIFont.systemFont(ofSize: 16, weight: .semibold))
    static let listSubtitle = TextStyle(textColor: Color.white, font:  UIFont.systemFont(ofSize: 14))
}

extension NSAttributedString {
    convenience init(string: String, style: TextStyleProtocol) {
        self.init(string: string, attributes: style.attributes)
    }
}

extension UILabel {
    func bind(style: TextStyleProtocol) {
        textColor = style.attributes[.foregroundColor] as? UIColor
        font = style.attributes[.font] as? UIFont
    }
}

extension UITextField {
    func bind(style: TextStyleProtocol) {
        textColor = style.attributes[.foregroundColor] as? UIColor
        font = style.attributes[.font] as? UIFont
    }
}
