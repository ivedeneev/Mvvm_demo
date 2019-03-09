//
//  Color.swift
//  Pyaterochka
//
//  Created by Igor Vedeneev on 10.07.2018.
//  Copyright © 2018 Zeno Inc. All rights reserved.
//

import UIKit.UIColor

final class Color {
    static let black = UIColor(hex: 0x212121)
    static let white = UIColor(hex: 0xffffff)
    static let background = UIColor(hex: 0x2f2f2f)
    static let feedImageBackground = UIColor(hex: 0xcccccc)
    static let navigationBarTint = UIColor(r: 90, g: 176, b: 196, a: 1)
}


//MARK:- Private
extension UIColor {
    
    /**
     Makes UIColor with hex string
     */
    convenience init(withHexString hex: String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        switch cString.count {
        case 6:
            self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                      alpha: CGFloat(1.0))
        case 8:
            self.init(
                red: CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0,
                green: CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0,
                blue: CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0,
                alpha: CGFloat(rgbValue & 0x000000FF) / 255.0)
        default:
            debugPrint("probably invalid hex: \(hex)")
            self.init(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    convenience init(hex: Int, alpha: CGFloat = 1) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        
        self.init(red: components.R, green: components.G, blue: components.B, alpha: alpha)
    }
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    convenience init(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) {
        let components = (
            R: r/255.0,
            G: g/255.0,
            B: b/255.0
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: a)
    }
    
    var highlighted: UIColor {
        guard let components = getRGBAComponents() else { return self }
        let r = components.red * 0.9 * 255
        let g = components.green * 0.9 * 255
        let b = components.blue * 0.9 * 255
        return UIColor.init(r: r, g: g, b: b, a: components.alpha)
    }
    
    func getRGBAComponents() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var (red, green, blue, alpha) = (CGFloat(0.0), CGFloat(0.0), CGFloat(0.0), CGFloat(0.0))
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        {
            return (red, green, blue, alpha)
        }
        else
        {
            return nil
        }
    }
}

