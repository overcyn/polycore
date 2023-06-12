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
    
    public func theme(kind: ThemeKind) -> Theme {
        let traitCollection = UIApplication.shared.keyWindow?.rootViewController?.traitCollection
        return Theme(kind: kind, userInterfaceStyle: traitCollection?.userInterfaceStyle ?? .unspecified, safeAreaInsets: .zero)
    }
    
    public func theme(kind k: ThemeKind? = nil, input: LYPageInput) -> Theme {
        let vc = input.viewController
        var kind: ThemeKind
        if let k = k {
            kind = k
        } else if let splitVC = vc.splitViewController {
            if splitVC.isMaster(vc) {
                kind = .standard
            } else {
                kind = .detail
            }
        } else {
            if vc.view.window == nil {
                kind = .detail // Handle collapsed detail view
            } else {
                kind = .standard
            }
        }
        
        let userInterfaceStyle = UIApplication.shared.keyWindow?.rootViewController?.traitCollection.userInterfaceStyle ?? .unspecified
        let safeAreaInsets = vc.view.safeAreaInsets
        return Theme(kind: kind, userInterfaceStyle: userInterfaceStyle, safeAreaInsets: safeAreaInsets)
    }
    
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

