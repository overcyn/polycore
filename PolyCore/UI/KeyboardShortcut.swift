//
//  KeyboardShortcut.swift
//  PolyGit
//
//  Created by Kevin Dang on 1/4/21.
//  Copyright © 2021 Overcyn. All rights reserved.
//

import Foundation

public struct KeyboardShortcut {
    public var title: String
    public var action: Action?
    public var input: String
    public var modifierFlags: UIKeyModifierFlags = []
    public var attributes: UIMenuElement.Attributes = []
    
    public init(title: String, action: Action?, input: String, modifierFlags: UIKeyModifierFlags = [], attributes: UIMenuElement.Attributes = []) {
        self.title = title
        self.action = action
        self.input = input
        self.modifierFlags = modifierFlags
        self.attributes = attributes
    }
}
