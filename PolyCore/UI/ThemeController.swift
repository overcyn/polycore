//
//  ThemeController.swift
//  PolyGit
//
//  Created by overcyn on 4/4/22.
//  Copyright © 2022 Overcyn. All rights reserved.
//

import Foundation

public protocol ThemeControllerObserver: AnyObject {
    func themeControllerOnUpdate(_: ThemeController)
}

public class WeakThemeControllerObserver {
    private(set) weak var value: ThemeControllerObserver?
    public init(_ value: ThemeControllerObserver?) {
        self.value = value
    }
}

public class ThemeController {
    public static var shared: ThemeController = ThemeController()
    public var observers: [WeakThemeControllerObserver] = []
    
    public func themeControllerOnUpdate() {
        observers = observers.filter({ i in
            return i.value != nil
        })
        for i in observers {
            i.value?.themeControllerOnUpdate(self)
        }
    }
}

extension UISplitViewController {
    public func isMaster(_ vc: UIViewController?) -> Bool {
        let masterVC = viewControllers[0]
        var parent: UIViewController? = vc
        while parent != nil {
            if parent == masterVC {
                return true
            }
            parent = parent?.parent
        }
        return false
    }
}

