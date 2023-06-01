//
//  BarItem.swift
//  PolyGit
//
//  Created by Kevin Dang on 11/9/20.
//  Copyright © 2020 Overcyn. All rights reserved.
//

import Foundation

@objc class BarButtonItem: UIBarButtonItem {
    public var poly_action: Action?
    public weak var viewController: UIViewController?
    
    @objc func performAction() {
        guard let vc = viewController else {
            return
        }
        
        if let barButtonAction = poly_action as? BarButtonAction {
            barButtonAction.perform(with: vc, barButtonItem: self)
        } else {
            poly_action?.perform(with: vc)
        }
    }
}

public class BarItem: NSObject, LYBarButtonItem {
    public var title: String?
    public var image: UIImage?
    public var customView: UIView?
    public var style: UIBarButtonItem.Style
    public var enabled: Bool
    public var action: Action?
    
    public static func cancelItem(action: Action?) -> BarItem {
        return BarItem(title: "Cancel", action: action)
    }
    
    public static func doneItem(action: Action?) -> BarItem {
        return BarItem(title: "Done", style: .done, action: action)
    }
    
    public init(title: String? = nil, image: UIImage? = nil, customView: UIView? = nil, enabled: Bool = true, style: UIBarButtonItem.Style = .plain, action: Action? = nil) {
        self.title = title
        self.image = image
        self.customView = customView
        self.enabled = enabled
        self.style = style
        self.action = action
    }
    
    // MARK: LYBarButtonItem
    
    public func barButtonItemClass() -> AnyClass {
        return BarButtonItem.self
    }
    
    public func configure(_ barButtonItem: UIBarButtonItem, for viewController: UIViewController) {
        guard let barButtonItem = barButtonItem as? BarButtonItem else {
            return
        }
        barButtonItem.title = title
        barButtonItem.image = image
        if barButtonItem.customView != customView { // Updating the custom view even if it hasn't changed will cause the bar button to rebuild.
            barButtonItem.customView = customView
        }
        barButtonItem.style = style
        barButtonItem.poly_action = action
        barButtonItem.viewController = viewController
        barButtonItem.isEnabled = enabled
        var hasMenu = false
        if #available(iOS 14.0, *) {
            if let contextMenuAction = action as? ContextMenuAction {
                hasMenu = true
                barButtonItem.menu = contextMenuAction.contextMenu.menu(viewController: viewController, view: nil)
            } else {
                barButtonItem.menu = nil
            }
        }
        if hasMenu {
            barButtonItem.target = nil
            barButtonItem.action = nil
        } else {
            barButtonItem.target = barButtonItem
            barButtonItem.action = #selector(BarButtonItem.performAction)
        }
    }
}
