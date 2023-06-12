//
//  Styles.swift
//  GitApp
//
//  Created by Kevin Dang on 2/6/20.
//  Copyright © 2020 Overcyn. All rights reserved.
//

import Foundation

public struct Theme {
    public let kind: ThemeKind
    public var userInterfaceStyle: UIUserInterfaceStyle
    
    public init(kind: ThemeKind, userInterfaceStyle: UIUserInterfaceStyle) {
        self.kind = kind
        self.userInterfaceStyle = userInterfaceStyle
    }
    
    public init(kind: ThemeKind) {
        self.kind = kind
        self.userInterfaceStyle = UIApplication.shared.keyWindow?.rootViewController?.traitCollection.userInterfaceStyle ?? .unspecified
    }
}

public enum ThemeKind {
    case standard
    case modal
}
