//
//  UIColorExtensions.swift
//  GitApp
//
//  Created by Kevin Dang on 3/27/20.
//  Copyright © 2020 Overcyn. All rights reserved.
//

import Foundation

extension UIColor {
    public convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (r, g, b, a) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UIColor {
    public func lighter(by percentage: CGFloat = 0.2) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s*(1-percentage), brightness: min(b*(1+percentage), 1), alpha: a)
    }

    public func darker(by percentage: CGFloat = 0.1) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: min(s*(1+percentage), 1), brightness: b*(1-percentage), alpha: a)
    }
//    func lighter(by percentage: CGFloat = 10.0) -> UIColor {
//        return self.adjust(by: abs(percentage))
//    }
//
//    func darker(by percentage: CGFloat = 10.0) -> UIColor {
//        return self.adjust(by: -abs(percentage))
//    }
//
//    func adjust(by percentage: CGFloat) -> UIColor {
//        var alpha, hue, saturation, brightness, red, green, blue, white : CGFloat
//        (alpha, hue, saturation, brightness, red, green, blue, white) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
//
//        let multiplier = percentage / 100.0
//
//        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
//            let newBrightness: CGFloat = max(min(brightness + multiplier*brightness, 1.0), 0.0)
//            return UIColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha)
//        }
//        else if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
//            let newRed: CGFloat = min(max(red + multiplier*red, 0.0), 1.0)
//            let newGreen: CGFloat = min(max(green + multiplier*green, 0.0), 1.0)
//            let newBlue: CGFloat = min(max(blue + multiplier*blue, 0.0), 1.0)
//            return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: alpha)
//        }
//        else if self.getWhite(&white, alpha: &alpha) {
//            let newWhite: CGFloat = (white + multiplier*white)
//            return UIColor(white: newWhite, alpha: alpha)
//        }
//
//        return self
//    }
}
