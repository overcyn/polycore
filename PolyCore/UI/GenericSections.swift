//
//  GenericSections.swift
//  GitApp
//
//  Created by Kevin Dang on 3/6/20.
//  Copyright © 2020 Overcyn. All rights reserved.
//

import Foundation

extension ButtonGroupSection {
    public static func defaultSection(_ theme: Theme, edges: UIRectEdge = UIRectEdge(), line: Int = #line) -> ButtonGroupSection {
        let section = ButtonGroupSection()
        section.identifier = "\(#function):\(line)"
        section.style.backgroundColor = UI.secondaryBackgroundColor(theme)
        section.contentPadding = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        if edges.contains(.top) {
            section.contentPadding.top = 5
        }
        if edges.contains(.bottom) {
            section.contentPadding.bottom = 5
        }
        return section
    }
}

extension ButtonSection {
    public class func `default`() -> ButtonSection {
        let section = ButtonSection()
        section.detailComponent.padding = UI.defaultDetailPadding
        section.buttonPadding = UI.defaultContentPadding
        section.subtitleComponent.padding = UI.defaultSubtitlePadding
        section.leadingImageComponent.padding = UI.defaultLeadingIconPadding
        section.leadingImageComponent.padding.right = 7
        section.trailingImageComponent.padding = UI.defaultTrailingImagePadding
        return section
    }
    
    // Blue button with white text
    public class func filled(_ theme: Theme, line: Int = #line) -> ButtonSection {
        let section = ButtonSection.default()
        section.identifier = "\(#function):\(line)"
        section.titleComponent.font = UIFont.boldSystemFont(ofSize: 20)
        section.titleComponent.textColor = UI.secondaryBackgroundColor(theme)
        section.titleComponent.textAlignment = .center
        section.buttonStyle.backgroundColor = UI.tintColor(theme)
        section.buttonStyle.cornerRadius = 27
        section.highlightedStyle = section.buttonStyle
        section.highlightedStyle?.backgroundColor = UI.highlightedTintColor(theme)
        section.disabledStyle = section.buttonStyle
        section.disabledStyle?.backgroundColor = UI.disabledTintColor(theme)
        return section
    }
    
    // Blue button with white text
    public class func multilineFilled(_ theme: Theme, line: Int = #line) -> ButtonSection {
        let section = ButtonSection.filled(theme, line: line)
        section.titleComponent.font = UIFont.boldSystemFont(ofSize: 19)
        section.detailComponent.padding.top = 0
        section.detailComponent.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        section.detailComponent.textColor = UI.secondaryBackgroundColor(theme)
        section.detailComponent.textAlignment = .center
        section.buttonPadding = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
        section.buttonStyle.backgroundColor = UI.tintColor(theme)
        section.buttonStyle.cornerRadius = 27
        return section
    }
    
    // Blue button with white text
    public class func bottom(_ theme: Theme, line: Int = #line) -> ButtonSection {
        let section = ButtonSection.filled(theme, line: line)
        section.behavior = LYFixedBottomBehavior()
        section.style.backgroundColor = UI.backgroundColor(theme).withAlphaComponent(0.8)
        section.style.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        section.style.cornerRadius = 27
        return section
    }
    
    // Blue button with white text
    public class func multilineBottom(_ theme: Theme, line: Int = #line) -> ButtonSection {
        let section = ButtonSection.multilineFilled(theme, line: line)
        section.behavior = LYFixedBottomBehavior()
        section.style.backgroundColor = UI.backgroundColor(theme).withAlphaComponent(0.8)
        section.style.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        section.style.cornerRadius = 27
        return section
    }
    
    public class func pro(_ theme: Theme, line: Int = #line) -> ButtonSection {
        let section = ButtonSection()
        section.buttonStyle.contents = UI.proIcon(theme).cgImage
        section.buttonStyle.contentsGravity = .resizeAspectFill
        section.highlightedStyle = section.buttonStyle
        section.highlightedStyle?.alpha = 0.5
        section.action = BlockAction({ _ in })
        return section
    }
    
    public class func bottomFooter(_ theme: Theme, small: Bool = false, line: Int = #line) -> SpacerSection {
        let behavior = LYFixedBottomBehavior()
        behavior.includeBottomOffsetInHeight = true
        let section = SpacerSection(height: small ? 10 : 20)
        section.identifier = "\(#function):\(line)"
        section.behavior = behavior
        section.style.backgroundColor = UI.backgroundColor(theme).withAlphaComponent(0.8)
        return section
    }
    
    public class func system(_ theme: Theme, line: Int = #line) -> ButtonSection {
        let section = ButtonSection.default()
        section.identifier = "\(#function):\(line)"
        section.titleComponent.font = UIFont.boldSystemFont(ofSize: 16)
        section.titleComponent.textColor = UI.tintColor(theme)
        section.titleComponent.textAlignment = .center
        section.highlightedTitleComponent = section.titleComponent
        section.highlightedTitleComponent?.textColor = UI.highlightedTintColor(theme)
        section.disabledTitleComponent = section.titleComponent
        section.disabledTitleComponent?.textColor = UI.disabledLabelColor(theme)
        return section
    }
    
    public class func systemBottom(_ theme: Theme, line: Int = #line) -> ButtonSection {
        let section = ButtonSection.system(theme)
        section.behavior = LYFixedBottomBehavior()
        section.style.backgroundColor = UI.backgroundColor(theme).withAlphaComponent(0.8)
        section.style.maskedCorners = []
        return section
    }
    
    // Cell with blue underlined text
    public class func link(_ theme: Theme, text: String, textAlignment: NSTextAlignment, line: Int = #line) -> ButtonSection {
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        
        let section = ButtonSection.default()
        section.identifier = "\(#function):\(line)"
        section.buttonPadding = .zero
        section.titleComponent.attributedText = NSAttributedString(string: text, attributes: [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: UI.tintColor(theme),
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
        ])
        section.highlightedTitleComponent = section.titleComponent
        section.highlightedTitleComponent?.attributedText = NSAttributedString(string: text, attributes: [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: UI.highlightedTintColor(theme),
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
        ])
        section.disabledTitleComponent = section.titleComponent
        section.disabledTitleComponent?.attributedText = NSAttributedString(string: text, attributes: [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: UI.disabledLabelColor(theme),
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
        ])
        return section
    }
    
    // Grey button with blue text
    public class func button(_ theme: Theme, destructive: Bool = false, line: Int = #line) -> ButtonSection {
        let section = ButtonSection.default()
        section.identifier = "\(#function):\(line)"
        section.titleComponent.textAlignment = .center
        section.titleComponent.font = UIFont.boldSystemFont(ofSize: 18)
        section.titleComponent.numberOfLines = 0
        if destructive {
            section.titleComponent.textColor = UI.destructiveColor(theme)
        } else {
            section.titleComponent.textColor = UI.tintColor(theme)
        }
        section.disabledTitleComponent = section.titleComponent
        section.disabledTitleComponent?.textColor = UI.disabledLabelColor(theme)
        section.buttonStyle.backgroundColor = UI.buttonColor(theme)
        section.buttonStyle.cornerRadius = 10
        section.highlightedStyle = section.buttonStyle
        section.highlightedStyle?.backgroundColor = UI.highlightedButtonColor(theme)
        return section
    }
    
    // Ellipsis button
    public class func ellipsis(_ theme: Theme, destructive: Bool = false, line: Int = #line) -> ButtonSection {
        let section = ButtonSection.default()
        section.identifier = "\(#function):\(line)"
        section.leadingImageComponent.image = UI.sidewaysEllipsisLeadingIcon
        section.leadingImageComponent.tintColor = UI.tintColor(theme)
        section.leadingImageComponent.padding = UIEdgeInsets(top: -2, left: -7, bottom: -2, right: -7)
        section.disabledLeadingImageComponent = section.leadingImageComponent
        section.disabledLeadingImageComponent?.tintColor = UI.disabledLabelColor(theme)
        section.buttonStyle.backgroundColor = UI.buttonColor(theme)
        section.buttonStyle.cornerRadius = 10
        section.highlightedStyle = section.buttonStyle
        section.highlightedStyle?.backgroundColor = UI.highlightedButtonColor(theme)
        return section
    }
}

extension UI {

    
    
    // Cell with blue text
    public class func secondaryButtonSection(_ theme: Theme, enabled: Bool = true, destructive: Bool = false, line: Int = #line) -> BasicSection {
        let section = BasicSection.defaultSection()
        section.identifier = "\(#function):\(line)"
        section.titleNumberOfLines = 0
        section.titleTextColor = enabled ? (destructive ? UI.destructiveColor(theme) : UI.tintColor(theme)) : UI.disabledLabelColor(theme)
        section.leadingImageTintColor = enabled ? (destructive ? UI.destructiveColor(theme) : UI.tintColor(theme)) : UI.disabledLabelColor(theme)
        if theme.kind == .modal {
            section.titleFont = UIFont.boldSystemFont(ofSize: 18)
        } else {
            section.titleFont = UIFont.boldSystemFont(ofSize: 16)
        }
        section.titleTextAlignment = .center
        section.style.backgroundColor = UI.secondaryBackgroundColor(theme)
        return section
    }
    
    public class func secondaryButtonSection2(_ theme: Theme, enabled: Bool = true, destructive: Bool = false, line: Int = #line) -> BasicSection {
        let section = secondaryButtonSection(theme, enabled: enabled, destructive: destructive, line: line)
        section.titleTextAlignment = .natural
        return section
    }
        
    public class func segmentButtonSection(_ theme: Theme, line: Int = #line) -> ButtonSection {
        let section = ButtonSection()
        section.identifier = "\(#function):\(line)"
        section.buttonPadding = UIEdgeInsets(top: 7, left: 3, bottom: 7, right: 3)
        section.titleComponent.textAlignment = .center
        section.titleComponent.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        section.titleComponent.textColor = UI.disabledLabelColor(theme)
        section.disabledTitleComponent = section.titleComponent
        section.disabledTitleComponent?.textColor = UI.labelColor(theme)
        section.disabledTitleComponent?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        section.disabledStyle = section.style
        section.disabledStyle?.backgroundColor = UI.buttonColor(theme)
        section.disabledStyle?.cornerRadius = 14.5
        section.highlightedTitleComponent = section.titleComponent
        section.highlightedTitleComponent?.textColor = UI.labelColor(theme)
        section.highlightedStyle = section.style
        section.highlightedStyle?.backgroundColor = UI.buttonColor(theme)
        section.highlightedStyle?.cornerRadius = 14.5
        return section
    }
    
    public class func segmentButtonGroupSection(_ theme: Theme, line: Int = #line) -> ButtonGroupSection {
        let section = ButtonGroupSection()
        section.contentPadding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        section.identifier = "\(#function):\(line)"
        return section
    }
    
    // For commit info and file info
    public class func infoSection(_ theme: Theme, noContent: Bool = false, line: Int = #line) -> BasicSection {
        let section = BasicSection.defaultSection()
        section.contentPadding.top = 10
        section.contentPadding.bottom = 10
        section.identifier = "\(#function):\(line)"
        section.titleFont = UIFont.systemFont(ofSize: 13, weight: .regular)
        section.titleTextColor = UI.secondaryLabelColor(theme)
        section.subtitleFont = UIFont.systemFont(ofSize: 16)
        section.subtitleNumberOfLines = 0
        if noContent {
            section.detailFont = UIFont.italicSystemFont(ofSize: 16)
        } else {
            section.detailFont = UIFont.systemFont(ofSize: 16)
        }
        section.detailNumberOfLines = 0
        section.style.backgroundColor = UI.secondaryBackgroundColor(theme)
        return section
    }
    
    public class func info2Section(_ theme: Theme, line: Int = #line) -> BasicSection {
        let section = BasicSection.defaultSection()
        section.identifier = "\(#function):\(line)"
        section.titleFont = UIFont.boldSystemFont(ofSize: 16)
        section.subtitleFont = UIFont.systemFont(ofSize: 16)
        section.detailFont = UIFont.systemFont(ofSize: 16)
        section.detailPadding.top = section.titlePadding.bottom - UIFont.boldSystemFont(ofSize: 16).lineHeight
        section.detailPadding.right = -175
        section.detailPadding.left = 175
        section.style.backgroundColor = UI.secondaryBackgroundColor(theme)
        return section
    }
    
    public class func info2shortSection(_ theme: Theme, line: Int = #line) -> BasicSection {
        let section = BasicSection.defaultSection()
        section.identifier = "\(#function):\(line)"
        section.contentPadding.top = 10
        section.contentPadding.bottom = 10
        section.titleFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        section.detailFont = UIFont.systemFont(ofSize: 14)
        section.style.backgroundColor = UI.tertiaryBackgroundColor(theme)
        return section
    }
    
    public class func separatorSection(_ theme: Theme, line: Int = #line) -> LYSection {
        let section = SeparatorSection()
        section.identifier = "\(#function):\(line)"
        section.style.backgroundColor = UI.backgroundColor(theme)
        return section
    }
    
    public class func thickSeparatorSection(_ theme: Theme, line: Int = #line) -> LYSection {
        let section = SeparatorSection()
        section.height = 3
        section.identifier = "\(#function):\(line)"
        section.style.backgroundColor = UI.backgroundColor(theme)
        return section
    }
    
    public class func headerSections(_ theme: Theme, line: Int = #line) -> [LYSection] {
        let section = SpacerSection(height: 0)
        section.identifier = "\(#function):\(line)"
        if theme.kind == .master || theme.kind == .detail {
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
        if theme.kind == .master || theme.kind == .detail {
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
    
    public class func spacerSection(_ theme: Theme, line: Int = #line) -> [LYSection] {
        let section = SpacerSection(height: 0)
        section.identifier = "\(#function):\(line)"
        if theme.kind == .master || theme.kind == .detail {
            section.height = 10
        } else if theme.kind == .modal {
            section.height = 25
        }
        return [section]
    }
    
    public class func smallSpacer(_ theme: Theme, line: Int = #line) -> SpacerSection {
        let section = SpacerSection(height: 10)
        section.identifier = "\(#function):\(line)"
        return section
    }
    
    public class func bottomSmallSpacer(_ theme: Theme, line: Int = #line) -> SpacerSection {
        let section = smallSpacer(theme, line: line)
        section.behavior = LYFixedBottomBehavior()
        section.style.backgroundColor = UI.backgroundColor(theme).withAlphaComponent(0.8)
        return section
    }
        
    public class func titleSection(_ theme: Theme, title: String, loading: Bool = false, background: Bool = true, line: Int = #line) -> [LYSection] {
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
        array.append(UI.separatorSection(theme))
        return array
    }
    
    public class func descriptionSection(_ theme: Theme, message: String, line: Int = #line) -> BasicSection {
        let section = BasicSection.defaultSection()
        section.titleText = message
        section.identifier = "\(#function):\(line)"
        section.contentPadding = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        section.titleFont = UIFont.systemFont(ofSize: 16)
        section.titleNumberOfLines = 0
        return section
    }
        
    public class func loadingSection(_ theme: Theme, line: Int = #line) -> [LYSection] {
        let section = LoadingSection()
        section.identifier = "\(#function):\(line)"
        return [section]
    }
    
    public class func noContentSection(_ theme: Theme, title: String, secondary: Bool = false, background: Bool = true, line: Int = #line) -> BasicSection {
        let section = BasicSection.defaultSection()
        section.identifier = "\(#function):\(line)"
        section.titleFont = UIFont.systemFont(ofSize: 18, weight: .regular)
        section.titleTextColor = UI.disabledLabelColor(theme)
        section.titleTextAlignment = .center
        section.titleText = title
        section.titleNumberOfLines = 0
        if !background {
            // no-op
        } else if secondary {
            section.style.backgroundColor = UI.tertiaryBackgroundColor(theme)
        } else {
            section.style.backgroundColor = UI.secondaryBackgroundColor(theme)
        }
        return section
    }
        
    public class func bannerSection(_ theme: Theme, line: Int = #line) -> BasicSection {
        let section = BasicSection.defaultSection()
        section.identifier = "\(#function):\(line)"
        section.titleFont = UIFont.boldSystemFont(ofSize: 16)
        section.titleTextColor = UI.backgroundColor(theme)
        section.titleTextAlignment = .center
        section.detailFont = UIFont.systemFont(ofSize: 14)
        section.detailTextColor = UI.backgroundColor(theme)
        section.detailTextAlignment = .center
        section.detailNumberOfLines = 0
        section.style.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.75)
        return section
    }
    
    public class func controlTitleSection(_ theme: Theme, title: String, line: Int = #line) -> BasicSection {
        let section = BasicSection.defaultSection()
        section.identifier = "\(#function):\(line)"
        section.contentPadding.bottom = 0
        section.titleText = title
        section.titleFont = UIFont.boldSystemFont(ofSize: 13)
        section.titleTextColor = UI.tintColor(theme)
        section.style.backgroundColor = UI.secondaryBackgroundColor(theme)
        return section
    }
    
    public class func controlSection(_ theme: Theme, line: Int = #line) -> BasicSection {
        let section = BasicSection.defaultSection()
        section.identifier = "\(#function):\(line)"
        section.titleFont = UIFont.systemFont(ofSize: 18)
        section.titleTextColor = UI.labelColor(theme)
        section.style.backgroundColor = UI.secondaryBackgroundColor(theme)
        return section
    }
    
    public class func headingSection(_ theme: Theme, title: String, line: Int = #line) -> BasicSection {
        let titleAttr: [NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 27, weight: .bold),
            .foregroundColor: UI.labelColor(theme),
        ]
        let newAttr: [NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 18, weight: .semibold),
            .foregroundColor: UIColor.systemOrange,
        ]
        let attrStr = NSMutableAttributedString(string: NSLocalizedString("New!", comment: "Info text marking a new feature"), attributes: newAttr)
        attrStr.append(NSAttributedString(string: "\n"))
        attrStr.append(NSAttributedString(string: title, attributes: titleAttr))
        
        let section = BasicSection.defaultSection()
        section.identifier = "\(#function):\(line)"
        section.titleAttributedText = attrStr
        section.titleNumberOfLines = 0
        section.contentPadding = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        return section
    }
}

extension UI {
    public class func settingsInfoSection(_ theme: Theme, secondary: Bool = false, line: Int = #line) -> BasicSection {
        let section = BasicSection.defaultSection()
        section.identifier = "\(#function):\(line)"
        section.titleFont = UIFont.systemFont(ofSize: 16)
        section.subtitleFont = UIFont.systemFont(ofSize: 16)
        section.subtitleTextColor = UI.secondaryLabelColor(theme)
        section.subtitleNumberOfLines = 0
        if secondary {
            section.style.backgroundColor = UI.tertiaryBackgroundColor(theme)
        } else {
            section.style.backgroundColor = UI.secondaryBackgroundColor(theme)
        }
        return section
    }
}

extension UI {
    public class func loadingPage(_ theme: Theme) -> [LYSection] {
        var array: [LYSection] = []
        array.append(contentsOf: UI.headerSections(theme))
        array.append(contentsOf: UI.loadingSection(theme))
        array.append(contentsOf: UI.footerSections(theme))
        return array
    }
}

extension UI {
    public class func configure(_ theme: Theme, textField: TextFieldSection) {
        textField.style.backgroundColor = UI.secondaryBackgroundColor(theme)
    }
    
    public class func configure(_ theme: Theme, picker: PickerSection) {
        picker.style.backgroundColor = UI.secondaryBackgroundColor(theme)
    }
    
    public class func configure(_ theme: Theme, switch section: SwitchSection) {
        section.contentPadding = UI.defaultContentPadding
        section.titleNumberOfLines = 0
        section.titleFont = UIFont.systemFont(ofSize: 16)
        section.switchPadding = UI.defaultTrailingImagePadding
        section.style.backgroundColor = UI.secondaryBackgroundColor(theme)
    }
    
    public class func configure(_ theme: Theme, stepper section: StepperSection) {
        section.contentPadding = UI.defaultContentPadding
        section.titleNumberOfLines = 0
        section.titleFont = UIFont.systemFont(ofSize: 16)
        section.stepperPadding = UI.defaultTrailingImagePadding
        section.style.backgroundColor = UI.secondaryBackgroundColor(theme)
    }
    
    public class func configure(picker: PickerSection, remoteNames: [String], remoteName: String?) {
        var titles = remoteNames
        var attributedTitles = remoteNames.map({ i in
            return NSAttributedString(string: i, attributes: [.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.label])
        })
        titles.insert("-", at: 0)
        attributedTitles.insert(NSAttributedString(string: NSLocalizedString("Remote Name", comment: "Picker title when selecting a remote"), attributes: [.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.placeholderText]), at: 0)
        
        picker.titles = titles
        picker.inputAttributedTitles = attributedTitles
        if remoteNames.count == 1 {
            picker.value = 1
        } else {
            picker.value = (remoteNames.firstIndex(where: { i in
                i == remoteName
            }) ?? -1) + 1
        }
    }
    
    public class func configure(_ theme: Theme, segmentedControl section: SegmentedControlSection) {
        if (theme.kind == .detail && UIDevice.current.userInterfaceIdiom == .phone) || theme.kind == .master {
            section.contentPadding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        }
    }
}
