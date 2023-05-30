//
//  ContextMenuAction.swift
//  PolyGit
//
//  Created by Kevin Dang on 11/10/20.
//  Copyright © 2020 Overcyn. All rights reserved.
//

import Foundation

public struct ContextMenuAction: ViewAction, BarButtonAction, Action {
    public let contextMenu: ContextMenu
    
    public init(contextMenu: ContextMenu) {
        self.contextMenu = contextMenu
    }
    
    // MARK: API
    
    public func perform(with viewController: UIViewController) {
        ShowErrorAction_NoCancelled(error: StringError("No target view to display popover"), completion: nil).perform(with: viewController)
    }
    
    public func perform(with viewController: UIViewController, barButtonItem: UIBarButtonItem) {
        panMenuAction().perform(with: viewController)
    }
    
    public func perform(with viewController: UIViewController, view: UIView) {
        panMenuAction().perform(with: viewController, view: view)
    }
    
    // MARK: Internal
    
    private func panMenuAction() -> PanMenuAction {
        return PanMenuAction(panMenu: PanMenu(items: contextMenu.panMenuItems()))
    }
}

public struct ContextMenu: ContextMenuChild {
    public var title: String?
    public var children: [ContextMenuChild]
    
    public init(title: String? = nil, children: [ContextMenuChild]) {
        self.title = title
        self.children = children
    }
    
    public func menu(viewController: UIViewController, view: UIView?) -> UIMenu {
        var actions: [UIMenuElement] = []
        for i in children {
            actions.append(i.menuElement(viewController: viewController, view: view))
        }
        return UIMenu(title: title ?? "", options: .displayInline, children: actions)
    }
    
    // MARK: ContextMenuChild
    
    public func menuElement(viewController: UIViewController, view: UIView?) -> UIMenuElement {
        return menu(viewController: viewController, view: view)
    }
    
    public func panMenuItems() -> [PanMenuItem] {
        var panItems: [PanMenuItem] = []
        for i in children {
            panItems.append(contentsOf: i.panMenuItems())
        }
        return panItems
    }
}

public struct ContextItem: ContextMenuChild {
    public var title: String = ""
    public var image: UIImage?
    public var attributes: UIMenuElement.Attributes?
    public var state: UIMenuElement.State?
    public var action: Action?
    
    public init(title: String = "", image: UIImage? = nil, attributes: UIMenuElement.Attributes? = nil, state: UIMenuElement.State? = nil, action: Action? = nil) {
        self.title = title
        self.image = image
        self.attributes = attributes
        self.state = state
        self.action = action
    }
    
    // MARK: ContextMenuChild
    
    public func menuElement(viewController: UIViewController, view: UIView?) -> UIMenuElement {
        return UIAction(title: title, image: image, attributes: attributes ?? UIMenuElement.Attributes(), state: state ?? .off, handler: {_ in
            if let action = action as? ViewAction, let view = view {
                action.perform(with: viewController, view: view)
            } else {
                action?.perform(with: viewController)
            }
        })
    }
    
    public func panMenuItems() -> [PanMenuItem] {
        let disabled = attributes?.contains(.disabled) ?? false
        let selected: Bool?
        switch state {
        case .mixed, .on:
            selected = true
        case .off:
            selected = false
        case .none:
            fallthrough
        default:
            selected = nil
        }
        return [PanMenuItem(title: title, selected: selected, action: action, enabled: !disabled)]
    }
}

public protocol ContextMenuChild {
    func menuElement(viewController: UIViewController, view: UIView?) -> UIMenuElement
    func panMenuItems() -> [PanMenuItem]
}
