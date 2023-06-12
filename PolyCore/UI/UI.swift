//
//  Page.swift
//  GitApp
//
//  Created by Kevin Dang on 11/14/19.
//  Copyright © 2019 Overcyn. All rights reserved.
//

import Foundation
import SwiftDate

extension BasicSection {
    public class func defaultSection() -> BasicSection {
        let section = BasicSection()
        section.contentPadding = UI.defaultContentPadding
        section.subtitlePadding = UI.defaultSubtitlePadding
        section.detailPadding = UI.defaultDetailPadding
        section.leadingImagePadding = UI.defaultLeadingIconPadding
        section.leadingImageSize = UI.defaultLeadingIconSize
        section.trailingImagePadding = UI.defaultTrailingImagePadding
        return section
    }
    
    public func addFileIcon(_ theme: Theme, isDir: Bool = false) {
        if isDir {
            leadingImage = UI.folderLeadingIcon
            leadingImageTintColor = .systemBlue
        } else {
            leadingImage = UI.fileLeadingIcon
            leadingImageTintColor = UI.disabledLabelColor(theme)
        }
    }
    
    public func addDisclosureIndicator(_ theme: Theme, _ open: Bool) {
        leadingImage = open ? UI.disclosureOpenLeadingIcon : UI.disclosureClosedLeadingIcon
        leadingImageTintColor = UI.chevronColor(theme)
        leadingImageSize = nil
        contentPadding.left -= 5
        leadingImagePadding.right -= 5
    }
    
    public func addChevron(_ theme: Theme) {
        trailingImage = UIImage(systemName: "chevron.right")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
        trailingImageTintColor = UI.chevronColor(theme)
        trailingImageSize = CGSize(width: 20, height: 20)
    }
}

extension UI {
    public static func configure(_ theme: Theme, navigationBar: UINavigationBar) {
        if theme.kind == .modal {
            return
        }
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UI.secondaryBackgroundColor(theme)
        navBarAppearance.shadowColor = UI.barBorderColor(theme)
        
        navigationBar.standardAppearance = navBarAppearance
        navigationBar.compactAppearance = navBarAppearance
        navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    public static func configure(_ theme: Theme, quickOpenNavigationBar navigationBar: UINavigationBar) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UI.backgroundColor(theme)
        navBarAppearance.shadowColor = UI.barBorderColor(theme)
        
        navigationBar.standardAppearance = navBarAppearance
        navigationBar.compactAppearance = navBarAppearance
        navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    public static func configure(_ theme: Theme, tabBar: UITabBar) {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UI.secondaryBackgroundColor(theme)
        tabBarAppearance.shadowImage = UIImage()
        tabBarAppearance.backgroundImage = UIImage()
        tabBarAppearance.shadowColor = UI.barBorderColor(theme)
        
        tabBar.standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = tabBarAppearance
        }
    }
}


public class UI {
    public static var defaultSelectionColor = UIColor.systemBlue.withAlphaComponent(0.7)
    public static var defaultContentPadding = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    public static var defaultSubtitlePadding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    public static var defaultDetailPadding = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    public static var defaultLeadingIconPadding = UIEdgeInsets(top: CGFloat.greatestFiniteMagnitude, left: 0, bottom: 0, right: 10)
    public static var defaultTrailingImagePadding = UIEdgeInsets(top: CGFloat.greatestFiniteMagnitude, left: 10, bottom: 0, right: 0)
    public static var defaultLeadingIconSize = CGSize(width: 25, height: 25)
    
    public static var defaultGraphContentPadding = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
    public static var defaultGraphDetailPadding = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
    public static var defaultGraphTagPadding = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
    
    public class func trimSeparators(_ sections: [LYSection]) -> [LYSection] {
        var trimmed = sections
        if trimmed.last is SeparatorSection {
            _ = trimmed.popLast()
        }
        return trimmed
    }
    
    public class func configure(_ theme: Theme, output: LYPageOutput) {
        output.backgroundColor = UI.backgroundColor(theme)
        output.sections = UI.configure(theme, sections: output.sections)
    }
    
    public class func configure(_ theme: Theme, sections: [LYSection]) -> [LYSection] {
        if (theme.kind == .detail && UIDevice.current.userInterfaceIdiom == .phone) || theme.kind == .master {
            for i in sections {
                if let configurable = i as? ConfigurableSection, !configurable.style.configuredContentPadding {
                    configurable.contentPadding.left += theme.safeAreaInsets.left
                    configurable.contentPadding.right += theme.safeAreaInsets.right
                    configurable.style.configuredContentPadding = true // Don't apply content insets multiple times
                }
            }
            return sections
        }
        
        // For each section
        for i in 0..<sections.count {
            let section = sections[i]
            // If section is configurable, is not a spacer and has not been configured
            if let section = section as? ConfigurableSection, !(section is SpacerSection), (section.style.cornerRadius == 0 && section.style.maskedCorners == [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]) || section.style.configuredCornerRadius {
                section.style.configuredCornerRadius = true
                
                // Set the corner radius
                section.style.cornerRadius = 10
                
                // And the masked corners
                let prevSection = sections[safe: i-1]
                let nextSection = sections[safe: i+1]
                section.style.maskedCorners = []
                if (prevSection is SpacerSection) || prevSection == nil {
                    section.style.maskedCorners.insert(.layerMinXMinYCorner)
                    section.style.maskedCorners.insert(.layerMaxXMinYCorner)
                }
                if (nextSection is SpacerSection) || nextSection == nil {
                    section.style.maskedCorners.insert(.layerMinXMaxYCorner)
                    section.style.maskedCorners.insert(.layerMaxXMaxYCorner)
                }
            }
        }
        
        // Set insets
        let insets: UIEdgeInsets
        if UIDevice.current.userInterfaceIdiom == .pad {
            insets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        } else {
            insets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        }
        
        for i in sections {
            if let configurable = i as? ConfigurableSection {
                if configurable.behavior == nil {
                    let behavior = LYInsetBehavior()
                    behavior.insets = insets
                    
                    if theme.kind == .modal {
                        configurable.behavior = behavior
                    } else if theme.kind == .detail {
                        behavior.maxWidth = 800
                        configurable.behavior = behavior
                    }
                } else if let behavior = configurable.behavior as? LYFixedBottomBehavior {
                    behavior.insets = insets
                    
                    if theme.kind == .modal {
                        configurable.behavior = behavior
                    } else if theme.kind == .detail {
                        behavior.maxWidth = 800
                        configurable.behavior = behavior
                    }
                }
            }
        }
        return sections
    }
}