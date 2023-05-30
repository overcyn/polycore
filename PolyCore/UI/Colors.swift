//
//  Colors.swift
//  GitApp
//
//  Created by Kevin Dang on 3/18/20.
//  Copyright © 2020 Overcyn. All rights reserved.
//

import Foundation

extension UI {
    public class func backgroundColor(_ theme: Theme) -> UIColor {
        switch theme.userInterfaceStyle {
        case .dark:
            switch theme.kind {
            case .modal:
                return gray(theme, index: 0.925)
            default:
                return gray(theme, index: 1.0)
            }
        default:
            return gray(theme, index: 0.95)
        }
    }
    
    public class func secondaryBackgroundColor(_ theme: Theme) -> UIColor {
        switch theme.userInterfaceStyle {
        case .dark:
            switch theme.kind {
            case .modal:
                return gray(theme, index: 0.85)
            default:
                return gray(theme, index: 0.9)
            }
        default:
            return gray(theme, index: 1.0)
        }
    }
    
    public class func tertiaryBackgroundColor(_ theme: Theme) -> UIColor {
        switch theme.userInterfaceStyle {
        case .dark:
            switch theme.kind {
            case .modal:
                return gray(theme, index: 0.875)
            default:
                return gray(theme, index: 0.925)
            }
        default:
            return gray(theme, index: 0.98)
        }
    }
    
    public class func barBorderColor(_ theme: Theme) -> UIColor {
        switch theme.userInterfaceStyle {
        case .dark:
            return gray(theme, index: 0.8)
        default:
            return gray(theme, index: 0.9)
        }
    }
    
    // Push & Pull buttons on status page
    public class func buttonColor(_ theme: Theme) -> UIColor {
        switch theme.userInterfaceStyle {
        case .dark:
            return gray(theme, index: 0.8)
        default:
            return gray(theme, index: 0.95)
        }
    }
    
    // Push & Pull buttons on status page
    public class func highlightedButtonColor(_ theme: Theme) -> UIColor {
        switch theme.userInterfaceStyle {
        case .dark:
            return gray(theme, index: 0.7)
        default:
            return gray(theme, index: 0.85)
        }
    }
    
    // MARK: Colors
    
    public class func tintColor(_ theme: Theme) -> UIColor {
        return .systemBlue
    }
    
    public class func destructiveColor(_ theme: Theme) -> UIColor {
        return .systemRed
    }
    
    public class func disabledTintColor(_ theme: Theme) -> UIColor {
        switch theme.userInterfaceStyle {
        case .dark:
            var h: CGFloat = 0
            var s: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            UI.tintColor(theme).getHue(&h, saturation: &s, brightness: &b, alpha: &a)
            return UIColor(hue: h, saturation: s*0.4, brightness: min(b*0.3, 1), alpha: a)
        default:
            var h: CGFloat = 0
            var s: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            UI.tintColor(theme).getHue(&h, saturation: &s, brightness: &b, alpha: &a)
            return UIColor(hue: h, saturation: s*0.2, brightness: min(b*1.2, 1), alpha: a)
        }
    }
    
    public class func selectedTabColor(_ theme: Theme) -> UIColor {
        switch theme.userInterfaceStyle {
        case .dark:
            return UI.tintColor(theme).darker(by: 0.7)
        default:
            return UI.tintColor(theme).lighter(by: 0.85)
        }
    }
    
    public class func highlightedTintColor(_ theme: Theme) -> UIColor {
        switch theme.userInterfaceStyle {
        case .dark:
            return UI.tintColor(theme).darker(by: 0.4)
        default:
            return UI.tintColor(theme).lighter(by: 0.4)
        }
    }
    
    public class func diffHeaderColor(_ theme: Theme) -> UIColor {
        switch theme.userInterfaceStyle {
        case .dark:
            return UIColor(red: 34.0/255.0, green: 39.0/255.0, blue: 53.0/255.0, alpha: 1)
        default:
            return UIColor(red: 236.0/255.0, green: 243.0/255.0, blue: 253.0/255.0, alpha: 1)
        }
    }
    
    // MARK: Grays
    
    public class func labelColor(_ theme: Theme) -> UIColor {
        return gray(theme, index: 0)
    }
    
    public class func secondaryLabelColor(_ theme: Theme) -> UIColor {
        switch theme.userInterfaceStyle {
        case .dark:
            return gray(theme, index: 0.45)
        default:
            return gray(theme, index: 0.55)
        }
    }
    
    public class func disabledLabelColor(_ theme: Theme) -> UIColor {
        switch theme.userInterfaceStyle {
        case .dark:
            return gray(theme, index: 0.6)
        default:
            return gray(theme, index: 0.7)
        }
    }
        
    public class func chevronColor(_ theme: Theme) -> UIColor {
        switch theme.userInterfaceStyle {
        case .dark:
            return gray(theme, index: 0.7)
        default:
            return gray(theme, index: 0.8)
        }
    }
    
    // MARK: Internal
    
    public class func gray(_ theme: Theme, index: CGFloat) -> UIColor {
        var idx: CGFloat = min(max(index, 0.0), 1.0)
        switch theme.userInterfaceStyle {
        case .dark:
            idx = 1-idx
        default:
            break
        }
        switch theme.userInterfaceStyle {
        case .dark:
            return UIColor(red: idx, green: idx, blue: idx + 0.01, alpha: 1.0)
        default:
            return UIColor(red: idx, green: idx, blue: idx + 0.017, alpha: 1.0)
        }
    }
}
