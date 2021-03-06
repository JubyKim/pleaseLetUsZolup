//
//  CALayer+.swift
//  CA-PIN_IOS
//
//  Created by λΈνμ on 2021/06/28.
//

import Foundation
import UIKit

extension UILabel {
    func setupLabel(text: String, color: UIColor, font: UIFont, align: NSTextAlignment? = .left) {
        self.font = font
        self.text = text
        self.textColor = color
        self.textAlignment = align ?? .left
    }
    func halfTextColorChange (fullText : String , changeText : String ) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.mainBlue , range: range)
        self.attributedText = attribute
    }
}
