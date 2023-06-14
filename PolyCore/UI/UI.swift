//
//  Page.swift
//  GitApp
//
//  Created by Kevin Dang on 11/14/19.
//  Copyright © 2019 Overcyn. All rights reserved.
//

import Foundation
import SwiftDate

extension UI {
    public class func headerSections(_ theme: Theme, line: Int = #line) -> [LYSection] {
        let section = SpacerSection(height: 0)
        section.identifier = "\(#function):\(line)"
        if theme.kind == .standard {
            if UIDevice.current.userInterfaceIdiom == .phone {
                section.height = 10
            } else {
                section.height = 20
            }
        } else if theme.kind == .modal {
            section.height = 25
        }
        section.style.backgroundColor = UI.backgroundColor(theme)
        return [section]
    }
    
    public class func footerSections(_ theme: Theme, line: Int = #line) -> [LYSection] {
        let section = SpacerSection(height: 0)
        section.identifier = "\(#function):\(line)"
        if theme.kind == .standard {
            if UIDevice.current.userInterfaceIdiom == .phone {
                section.height = 10
            } else {
                section.height = 30
            }
        } else if theme.kind == .modal {
            section.height = 25
        }
        return [section]
    }
    
    public class func titleSections(_ theme: Theme, title: String, loading: Bool = false, background: Bool = true, line: Int = #line) -> [LYSection] {
        let section = TitleSection()
        section.identifier = "\(#function):\(line)"
        section.contentPadding = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        section.titleText = title.uppercased()
        section.titleTextColor = UI.secondaryLabelColor(theme)
        if background {
            section.style.backgroundColor = UI.secondaryBackgroundColor(theme)
        }
        section.loading = loading
        var array: [LYSection] = [section]
        array.append(SeparatorSection.default(theme))
        return array
    }
            
    public class func loadingSections(_ theme: Theme, line: Int = #line) -> [LYSection] {
        let section = LoadingSection()
        section.identifier = "\(#function):\(line)"
        return [section]
    }

    public class func loadingPage(_ theme: Theme) -> [LYSection] {
        var array: [LYSection] = []
        array.append(contentsOf: UI.headerSections(theme))
        array.append(contentsOf: UI.loadingSections(theme))
        array.append(contentsOf: UI.footerSections(theme))
        return array
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
    
    public class func configure(_ theme: Theme, input: LYPageInput, output: LYPageOutput) {
        output.backgroundColor = UI.backgroundColor(theme)
        output.sections = UI.configure(theme, input: input, sections: output.sections)
    }
    
    public class func configure(_ theme: Theme, input: LYPageInput, sections: [LYSection]) -> [LYSection] {
        var shouldAddRoundedInsets: Bool
        if theme.kind == .modal {
            shouldAddRoundedInsets = true
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            if let splitVC = input.viewController.splitViewController {
                if splitVC.isMaster(input.viewController) {
                    shouldAddRoundedInsets = false // Don't round splitview master
                } else {
                    shouldAddRoundedInsets = true // Round the splitview detail
                }
            } else {
                if input.viewController.view.window == nil {
                    shouldAddRoundedInsets = true // Handle collapsed detail view, which should be rounded
                } else {
                    shouldAddRoundedInsets = false
                }
            }
        } else {
            shouldAddRoundedInsets = false // dont round on iphone
        }
        
        if shouldAddRoundedInsets {
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
                        } else {
                            behavior.maxWidth = 800
                            configurable.behavior = behavior
                        }
                    } else if let behavior = configurable.behavior as? LYFixedBottomBehavior {
                        behavior.insets = insets
                        
                        if theme.kind == .modal {
                            configurable.behavior = behavior
                        } else {
                            behavior.maxWidth = 800
                            configurable.behavior = behavior
                        }
                    }
                }
            }
            return sections
        } else {
            // Configure the left and right safe area insets
            for i in sections {
                if let configurable = i as? ConfigurableSection, !configurable.style.configuredContentPadding {
                    let safeAreaInsets = input.viewController.view.safeAreaInsets
                    configurable.contentPadding.left += safeAreaInsets.left
                    configurable.contentPadding.right += safeAreaInsets.right
                    configurable.style.configuredContentPadding = true // Don't apply content insets multiple times
                }
            }
            return sections
        }
    }
}
