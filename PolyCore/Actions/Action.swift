//
//  Actions.swift
//  GitApp
//
//  Created by Kevin Dang on 9/30/19.
//  Copyright © 2019 Overcyn. All rights reserved.
//

import Foundation
import UIKit

public protocol Action {
    func perform(with vc: UIViewController)
}

public protocol ViewAction: Action {
    func perform(with vc: UIViewController, view: UIView)
}

public protocol BarButtonAction: Action {
    func perform(with vc: UIViewController, barButtonItem: UIBarButtonItem)
}

public struct LogAction: Action {
    public let string: String
    
    public init(string: String) {
        self.string = string
    }
    
    public func perform(with viewController: UIViewController) {
        NSLog(string)
    }
}

public struct BlockAction: Action {
    public let block: ((UIViewController) -> ())
    
    public init(_ block: @escaping ((UIViewController) -> ())) {
        self.block = block
    }
    
    public func perform(with viewController: UIViewController) {
        block(viewController)
    }
}
