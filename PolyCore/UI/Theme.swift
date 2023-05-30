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
    public var safeAreaInsets: UIEdgeInsets
    
    public init(kind: ThemeKind, userInterfaceStyle: UIUserInterfaceStyle, safeAreaInsets: UIEdgeInsets) {
        self.kind = kind
        self.userInterfaceStyle = userInterfaceStyle
        self.safeAreaInsets = safeAreaInsets
    }
}

public enum ThemeKind {
    case master // UISplitViewController primary / UITabBarController
    case detail // UISplitViewController secondary
    case modal // Modal
}
