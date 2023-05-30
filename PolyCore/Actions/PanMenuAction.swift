//
//  PanMenuAction.swift
//  PolyGit
//
//  Created by Kevin Dang on 11/25/20.
//  Copyright © 2020 Overcyn. All rights reserved.
//

import Foundation
import PanModal

public struct PanMenuAction: Action, ViewAction {
    public let panMenu: PanMenu
    
    public init(panMenu: PanMenu) {
        self.panMenu = panMenu
    }

    public func perform(with viewController: UIViewController) {
        let pageViewController = LYPageViewController(page: PanMenuPage(panMenu: panMenu, viewController: viewController, view: nil))
        viewController.presentPanModal(pageViewController)
    }
    
    public func perform(with viewController: UIViewController, view: UIView) {
        let pageViewController = LYPageViewController(page: PanMenuPage(panMenu: panMenu, viewController: viewController, view: view))
        viewController.presentPanModal(pageViewController)
    }
}

public struct PanMenu {
    public var items: [PanMenuItem]
    
    public init(items: [PanMenuItem]) {
        self.items = items
    }
}

public struct PanMenuItem {
    public var title: String? = nil
    public var attributedTitle: NSAttributedString? = nil
    public var detail: String? = nil
    public var selected: Bool? = nil
    public var action: Action? = nil
    public var enabled: Bool = true

    public init(title: String? = nil, attributedTitle: NSAttributedString? = nil, detail: String? = nil, selected: Bool? = nil, action: Action? = nil, enabled: Bool = true) {
        self.title = title
        self.attributedTitle = attributedTitle
        self.detail = detail
        self.selected = selected
        self.action = action
        self.enabled = enabled
    }
}

class PanMenuPage: NSObject, LYPage {
    public let panMenu: PanMenu
    public weak var viewController: UIViewController?
    public weak var view: UIView?
    
    public init(panMenu: PanMenu, viewController: UIViewController?, view: UIView?) {
        self.panMenu = panMenu
        self.viewController = viewController
        self.view = view
    }
    
    // MARK: LYPage
    
    public weak var delegate: LYPageDelegate?
    public var renderImmediately = true
    
    public func render(_ input: LYPageInput) -> LYPageOutput {
        let theme = ThemeController.shared.theme(input: input)
        let output = LYPageOutput()
        var array: [LYSection] = []
        for i in panMenu.items {
            let section = UI.panMenuSection(theme, enabled: i.enabled)
            section.titleText = i.title
            section.titleAttributedText = i.attributedTitle
            section.detailText = i.detail
            if i.selected == true {
                section.leadingImage = UI.checkmarkLeadingIcon
            } else if i.selected == false {
                section.leadingImage = UI.emptyLeadingIcon
            }
            if i.detail != nil {
                section.contentPadding.top = 10
                section.contentPadding.bottom = 10
                section.detailPadding.top = 3
            }
            if i.enabled {
                section.action = BlockAction({ [weak self] vc in
                    vc.dismiss(animated: true, completion: {
                        guard let self = self, let viewController = self.viewController else {
                            return
                        }
                        if let action = i.action as? ViewAction, let view = self.view {
                            action.perform(with: viewController, view: view)
                        } else {
                            i.action?.perform(with: viewController)
                        }
                    })
                })
            }
            array.append(section)
            array.append(UI.panMenuSeparatorSection(theme))
        }
        array = UI.trimSeparators(array)
        output.sections = array
        output.shouldAutorotate = false
        UI.configure(theme, output: output)

        // Trigger the pan menu to relayout based on the content size.
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50), execute: {
            let vc = self.delegate?.pageViewController() as? PanModalPresentable & UIViewController
            vc?.panModalSetNeedsLayoutUpdate()
            vc?.panModalTransition(to: .shortForm)
        })
        
        return output
    }
}

extension LYPageViewController: PanModalPresentable {
    public var panScrollable: UIScrollView? {
        return view as? UIScrollView
    }
}

extension UI {
    class func panMenuSection(_ theme: Theme, enabled: Bool, line: Int = #line) -> BasicSection {
        let section = UI.defaultSection()
        section.identifier = "\(#function):\(line)"
        section.titleFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
        section.detailFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        section.style.backgroundColor = UI.secondaryBackgroundColor(theme)
        if !enabled {
            section.titleTextColor = UI.disabledLabelColor(theme)
        }
        return section
    }
    
    class func panMenuSeparatorSection(_ theme: Theme, line: Int = #line) -> LYSection {
        let section = SeparatorSection()
        section.identifier = "\(#function):\(line)"
        section.style.backgroundColor = UI.backgroundColor(theme)
        return section
    }
}
