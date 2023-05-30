//
//  File.swift
//  GitApp
//
//  Created by Kevin Dang on 3/18/20.
//  Copyright © 2020 Overcyn. All rights reserved.
//

import Foundation
import UIKit

extension UI {
    public static let errorIcon = UIImage(systemName: "exclamationmark.triangle")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
}

// Tab Bar Icon
extension UI {
    public static let repositoryTabBarIcon = UIImage(systemName: "folder")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
    public static let statusTabBarIcon = UIImage(systemName: "plusminus.circle")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
    public static let commitsTabBarIcon = UIImage(systemName: "grid")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
    public static let referencesTabBarIcon = UIImage(systemName: "arrow.branch")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
    public static let searchTabBarIcon = UIImage(systemName: "magnifyingglass")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
}

// Leading Icon
extension UI {
    public static let deleteLeadingIcon = UIImage.image(systemName: "trash", configuration: UIImage.SymbolConfiguration(pointSize: 16, weight: .medium), size: CGSize(width: 25, height: 25))!
    public static let moveLeadingIcon = UIImage.image(systemName: "folder", configuration: UIImage.SymbolConfiguration(pointSize: 16, weight: .medium), size: CGSize(width: 25, height: 25))!
    public static let safariLeadingIcon = UIImage.image(systemName: "safari", configuration: UIImage.SymbolConfiguration(pointSize: 17, weight: .medium), size: CGSize(width: 25, height: 25))!
    public static let renameLeadingIcon = UIImage.image(systemName: "pencil", configuration: UIImage.SymbolConfiguration(pointSize: 17, weight: .medium), size: CGSize(width: 25, height: 25))!
    public static let shareLeadingIcon = UIImage.image(systemName: "square.and.arrow.up", configuration: UIImage.SymbolConfiguration(pointSize: 17, weight: .medium), size: CGSize(width: 25, height: 25))!
    public static let addLeadingIcon = UIImage.image(systemName: "plus", configuration: UIImage.SymbolConfiguration(pointSize: 17, weight: .medium), size: CGSize(width: 25, height: 25))!
    public static let browseLeadingIcon = UIImage.image(systemName: "folder", configuration: UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold), size: CGSize(width: 25, height: 25))!
    public static let checkoutLeadingIcon = UIImage.image(systemName: "arrow.turn.down.right", configuration: UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold), size: CGSize(width: 25, height: 25))!
    public static let ellipsisLeadingIcon = UIImage.image(systemName: "ellipsis", configuration: UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold), size: CGSize(width: 25, height: 25))!
    public static let repositoryLeadingIcon = UIImage.image(systemName: "archivebox", configuration: UIImage.SymbolConfiguration(pointSize: 20, weight: .light), size: CGSize(width: 25, height: 25))!
    public static let folderLeadingIcon = UIImage.image(systemName: "folder", configuration: UIImage.SymbolConfiguration(pointSize: 16, weight: .regular), size: CGSize(width: 25, height: 25))!
    public static let folderOpenLeadingIcon = UIImage.image(systemName: "folder.fill", configuration: UIImage.SymbolConfiguration(pointSize: 16, weight: .regular), size: CGSize(width: 25, height: 25))!
    public static let currentLeadingIcon = UIImage.image(systemName: "asterisk.circle", configuration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular), size: CGSize(width: 25, height: 25))!
    public static let arrowRightCircleLeadingIcon = UIImage.image(systemName: "arrow.right.circle", configuration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular), size: CGSize(width: 25, height: 25))!
    public static let fileLeadingIcon = UIImage.image(systemName: "doc.plaintext", configuration: UIImage.SymbolConfiguration(pointSize: 16, weight: .regular), size: CGSize(width: 25, height: 25))!
    public static let sidewaysEllipsisLeadingIcon: UIImage = {
        let image = UIImage.image(systemName: "ellipsis", configuration: UIImage.SymbolConfiguration(pointSize: 20, weight: .light), size: CGSize(width: 25, height: 25))!
        return UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: .right).withRenderingMode(.alwaysTemplate)
    }()
    public static let circleLeadingIcon = UIImage.image(systemName: "circle", configuration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular), size: CGSize(width: 25, height: 25))!
    public static let checkmarkCircleLeadingIcon = UIImage.image(systemName: "checkmark.circle.fill", configuration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular), size: CGSize(width: 25, height: 25))!
    public static let checkmarkLeadingIcon = UIImage.image(systemName: "checkmark", configuration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold), size: CGSize(width: 25, height: 25))!
    public static let mailLeadingIcon = UIImage.image(systemName: "envelope.fill", configuration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular), size: CGSize(width: 25, height: 25))!
    public static let twitterLeadingIcon = UIImage(named: "twitter", in: Bundle.current, with: nil)!.withRenderingMode(.alwaysTemplate)
    public static let githubLeadingIcon = UIImage(named: "github", in: Bundle.current, with: nil)!.withRenderingMode(.alwaysTemplate)
    public static let gitlabLeadingIcon = UIImage(named: "gitlab", in: Bundle.current, with: nil)!
    public static let bitbucketLeadingIcon = UIImage(named: "bitbucket", in: Bundle.current, with: nil)!
    public static let linkLeadingIcon = UIImage.image(systemName: "safari.fill", configuration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold), size: CGSize(width: 25, height: 25))!
    public static let docsLeadingIcon = UIImage.image(systemName: "book.fill", configuration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold), size: CGSize(width: 25, height: 25))!
    public static let changelogLeadingIcon = UIImage.image(systemName: "square.stack.3d.up.fill", configuration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold), size: CGSize(width: 25, height: 25))!
    public static let chevronRightLeadingIcon = UIImage.image(systemName: "chevron.right", configuration: UIImage.SymbolConfiguration(pointSize: 16, weight: .medium), size: CGSize(width: 25, height: 25))!
    public static let chevronDownLeadingIcon = UIImage.image(systemName: "chevron.down", configuration: UIImage.SymbolConfiguration(pointSize: 16, weight: .medium), size: CGSize(width: 25, height: 25))!
    public static let disclosureClosedLeadingIcon = UIImage.image(systemName: "chevron.right", configuration: UIImage.SymbolConfiguration(pointSize: 18, weight: .medium), size: CGSize(width: 25, height: 25))!
    public static let disclosureOpenLeadingIcon = UIImage.image(systemName: "chevron.down", configuration: UIImage.SymbolConfiguration(pointSize: 18, weight: .medium), size: CGSize(width: 25, height: 25))!
    public static let credentialLeadingIcon = UIImage.image(systemName: "lock", configuration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold), size: CGSize(width: 25, height: 25))!
    public static let emptyLeadingIcon: UIImage = {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 25, height: 25), false, 0)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }()
}

// Trailing Icon
extension UI {
    public static let favoriteTrailingIcon = UIImage.image(systemName: "star", configuration: UIImage.SymbolConfiguration(pointSize: 16, weight: .regular), size: CGSize(width: 25, height: 25))!
    public static let favoriteSelectedTrailingIcon = UIImage.image(systemName: "star.fill", configuration: UIImage.SymbolConfiguration(pointSize: 16, weight: .regular), size: CGSize(width: 25, height: 25))!
    public static let chevronRightTrailingIcon = UIImage.image(systemName: "chevron.right", configuration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular), size: CGSize(width: 25, height: 25))!
    public static let chevronDownTrailingIcon = UIImage.image(systemName: "chevron.down", configuration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular), size: CGSize(width: 25, height: 25))!
    public static let iCloudDownloadTrailingIcon = UIImage.image(systemName: "icloud.and.arrow.down", configuration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular), size: CGSize(width: 25, height: 25))!
    public static let fileTrailingIcon = UIImage.image(systemName: "doc.plaintext", configuration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular), size: CGSize(width: 25, height: 25))!
    public static let conflictTrailingIcon = UIImage.image(systemName: "exclamationmark.triangle", configuration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular), size: CGSize(width: 25, height: 25))!
    public static let checkmarkTrailingIcon = UIImage.image(systemName: "checkmark", configuration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold), size: CGSize(width: 25, height: 25))!
    public static let xTrailingIcon = UIImage.image(systemName: "xmark", configuration: UIImage.SymbolConfiguration(pointSize: 12, weight: .regular), size: CGSize(width: 25, height: 25))!
    public static let pinTrailingIcon = UIImage.image(systemName: "pin.fill", configuration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular), size: CGSize(width: 25, height: 25))!
    public static let emptyTrailingIcon: UIImage = {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 25, height: 25), false, 0)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }()
    
    public class func ellipsisCircleTrailingIcon(_ theme: Theme) -> UIImage {
        let bottomImage = UIImage.image(systemName: "circle.fill", configuration: UIImage.SymbolConfiguration(pointSize: 24, weight: .medium), size: CGSize(width: 25, height: 25))!.withTintColor(UI.buttonColor(theme)).withRenderingMode(.alwaysOriginal)
        let topImage = UIImage.image(systemName: "ellipsis", configuration: UIImage.SymbolConfiguration(pointSize: 16, weight: .medium), size: CGSize(width: 25, height: 25))!.withTintColor(UI.tintColor(theme)).withRenderingMode(.alwaysOriginal)
        return UIImage.composite(bottomImage: bottomImage, topImage: topImage).withRenderingMode(.alwaysOriginal)
    }
}

// Context menu
extension UI {
    public static let copyPathContextMenuIcon = UIImage(systemName: "text.cursor")!
    public static let copyContextMenuIcon = UIImage(systemName: "doc.on.doc")!
    public static let moveContextMenuIcon = UIImage(systemName: "folder")!
    public static let renameContextMenuIcon = UIImage(systemName: "pencil")!
    public static let duplicateContextMenuIcon = UIImage(systemName: "plus.square.on.square")!
    public static let evictContextMenuIcon = UIImage(systemName: "arrow.up.bin")!
    public static let deleteContextMenuIcon = UIImage(systemName: "trash")!
    public static let safariContextMenuIcon = UIImage(systemName: "safari")!
    public static let shareContextMenuIcon = UIImage(systemName: "square.and.arrow.up")!
    public static let iCloudDownloadContextMenuIcon = UIImage(systemName: "icloud.and.arrow.down")!
    public static let saveStashContextMenuIcon = UIImage(systemName: "tray.and.arrow.down")!
    public static let popStashContextMenuIcon = UIImage(systemName: "tray.and.arrow.up")!
    public static let stashListContextMenuIcon = UIImage(systemName: "tray.2")!
    public static let newFileContextMenuIcon = UIImage(systemName: "square.and.pencil")!
    public static let newFolderContextMenuIcon = UIImage(systemName: "folder.badge.plus")!
    public static let importFileContextMenuIcon = UIImage(systemName: "square.and.arrow.down")!
    public static let addContextMenuIcon = UIImage(systemName: "plus")!
    public static let stageChangesContextMenuIcon = UIImage(systemName: "text.badge.plus")!
    public static let discardChangesContextMenuIcon = UIImage(systemName: "text.badge.minus")!
    public static let trackFileContextMenuIcon = UIImage(systemName: "plus.slash.minus")!
    public static let untrackFileContextMenuIcon = UIImage(systemName: "minus.slash.plus")!
    public static let markResolvedContextMenuIcon = UIImage(systemName: "text.badge.checkmark")!
    public static let useOursContextMenuIcon = UIImage(systemName: "person.badge.plus")!
    public static let useTheirsContextMenuIcon = UIImage(systemName: "person.badge.minus")!
    public static let browseContextMenuIcon = UIImage(systemName: "folder")!
    public static let checkoutContextMenuIcon = UIImage(systemName: "arrow.turn.down.right")!
    public static let pushContextMenuIcon = UIImage(systemName: "paperplane")!
    public static let sortContextMenuIcon = UIImage(systemName: "arrow.up.arrow.down")
}

// Bar button items
extension UI {
    public static let addTabViewIcon = UIImage(systemName: "plus")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 16, weight: .medium))
    public static let closeTabViewIcon = UIImage(systemName: "xmark")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 14, weight: .medium))
    public static let chevronBarIcon = UIImage(systemName: "chevron.down")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 13, weight: .bold))
    public static let plusBarIcon = UIImage(systemName: "plus")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
    public static let cloneBarIcon = UIImage(systemName: "plus")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
    public static let repositoriesBarIcon = UIImage(systemName: "line.horizontal.3")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
    public static let sidebarBarIcon = UIImage(systemName: "sidebar.left")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
    public static let forwardsBarIcon = UIImage(systemName: "chevron.right")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
    public static let backwardsBarIcon = UIImage(systemName: "chevron.left")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))

    public class func stashIcon(_ theme: Theme) -> UIImage {
        let bottomImage = UIImage.image(systemName: "circle.fill", configuration: UIImage.SymbolConfiguration(pointSize: 28, weight: .medium), size: CGSize(width: 30, height: 30))!.withTintColor(UI.buttonColor(theme)).withRenderingMode(.alwaysOriginal)
        let topImage = UIImage.image(systemName: "tray", configuration: UIImage.SymbolConfiguration(pointSize: 16, weight: .medium), size: CGSize(width: 30, height: 30))!.withTintColor(UI.tintColor(theme)).withRenderingMode(.alwaysOriginal)
        return UIImage.composite(bottomImage: bottomImage, topImage: topImage).withRenderingMode(.alwaysOriginal)
    }
    
    public class func fileContentsIcon(_ theme: Theme, enabled: Bool) -> UIImage {
        let image = UIImage(systemName: "doc.text")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
        let color = enabled ? UIColor.systemBlue : UIColor.systemBlue.withAlphaComponent(0.3)
        return image.withTintColor(color).withRenderingMode(.alwaysOriginal)
    }
    
    public class func fileDiffIcon(_ theme: Theme, enabled: Bool) -> UIImage {
        let image = UIImage(systemName: "plusminus")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
        let color = enabled ? UIColor.systemBlue : UIColor.systemBlue.withAlphaComponent(0.3)
        return image.withTintColor(color).withRenderingMode(.alwaysOriginal)
    }
    
    public class func fileInfoIcon(_ theme: Theme, enabled: Bool) -> UIImage {
        let image = UIImage(systemName: "info")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
        let color = enabled ? UIColor.systemBlue : UIColor.systemBlue.withAlphaComponent(0.3)
        return image.withTintColor(color).withRenderingMode(.alwaysOriginal)
    }
    
    public class func addIcon(_ theme: Theme) -> UIImage {
        let bottomImage = UIImage.image(systemName: "circle.fill", configuration: UIImage.SymbolConfiguration(pointSize: 28, weight: .medium), size: CGSize(width: 30, height: 30))!.withTintColor(UI.buttonColor(theme)).withRenderingMode(.alwaysOriginal)
        let topImage = UIImage.image(systemName: "plus", configuration: UIImage.SymbolConfiguration(pointSize: 16, weight: .medium), size: CGSize(width: 30, height: 30))!.withTintColor(UI.tintColor(theme)).withRenderingMode(.alwaysOriginal)
        return UIImage.composite(bottomImage: bottomImage, topImage: topImage).withRenderingMode(.alwaysOriginal)
    }
    
    public class func infoIcon(_ theme: Theme) -> UIImage {
        let bottomImage = UIImage.image(systemName: "circle.fill", configuration: UIImage.SymbolConfiguration(pointSize: 28, weight: .medium), size: CGSize(width: 30, height: 30))!.withTintColor(UI.buttonColor(theme)).withRenderingMode(.alwaysOriginal)
        let topImage = UIImage.image(systemName: "info", configuration: UIImage.SymbolConfiguration(pointSize: 16, weight: .medium), size: CGSize(width: 30, height: 30))!.withTintColor(UI.tintColor(theme)).withRenderingMode(.alwaysOriginal)
        return UIImage.composite(bottomImage: bottomImage, topImage: topImage).withRenderingMode(.alwaysOriginal)
    }
    
    public class func newFileIcon(_ theme: Theme) -> UIImage {
        let bottomImage = UIImage.image(systemName: "circle.fill", configuration: UIImage.SymbolConfiguration(pointSize: 28, weight: .medium), size: CGSize(width: 30, height: 30))!.withTintColor(UI.tintColor(theme)).withRenderingMode(.alwaysOriginal)
        let topImage = UIImage.image(systemName: "square.and.pencil", configuration: UIImage.SymbolConfiguration(pointSize: 16, weight: .medium), size: CGSize(width: 30, height: 30))!.withTintColor(UI.secondaryBackgroundColor(theme)).withRenderingMode(.alwaysOriginal)
        return UIImage.composite(bottomImage: bottomImage, topImage: topImage, offset: CGPoint(x: 0.5, y: -0.5)).withRenderingMode(.alwaysOriginal)
    }
}

// TextInputAssitantItem

extension UI {
    public static let undoTextInputAssitantIcon = UIImage(systemName: "arrow.uturn.left")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 15, weight: .regular))
    public static let redoTextInputAssitantIcon = UIImage(systemName: "arrow.uturn.right")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 15, weight: .regular))
    public static let indentTextInputAssitantIcon = UIImage(systemName: "arrow.right.to.line")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 15, weight: .regular))
    public static let unindentTextInputAssitantIcon = UIImage(systemName: "arrow.left.to.line")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 15, weight: .regular))
    public static let moveUpTextInputAssitantIcon = UIImage(systemName: "arrow.up.to.line")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 15, weight: .regular))
    public static let moveDownTextInputAssitantIcon = UIImage(systemName: "arrow.down.to.line")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 15, weight: .regular))
    public static let searchTextInputAssitantIcon = UIImage(systemName: "magnifyingglass")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 15, weight: .regular))
    public static let dismissKeyboardInputAssistantIcon = UIImage.image(systemName: "keyboard.chevron.compact.down", configuration: UIImage.SymbolConfiguration(pointSize: 18, weight: .regular), size: CGSize(width: 30, height: 30))!
    public static let deleteLineTextInputAssitantIcon: UIImage = {
       let topImage = UIImage.image(systemName: "chevron.left", configuration: UIImage.SymbolConfiguration(pointSize: 16.5, weight: .regular), size: CGSize(width: 30, height: 30))!
       let bottomImage = UIImage.image(systemName: "delete.left", configuration: UIImage.SymbolConfiguration(pointSize: 17, weight: .regular), size: CGSize(width: 30, height: 30))!
       return UIImage.composite(bottomImage: bottomImage, topImage: topImage, offset: CGPoint(x: -10.5, y: 0))
    }()
}

// InputAccessoryView

extension UI {
    public static let undoAccessoryIcon = accessoryIcon(systemName: "arrow.uturn.left")
    public static let redoAccessoryIcon = accessoryIcon(systemName: "arrow.uturn.right")
    public static let indentAccessoryIcon = accessoryIcon(systemName: "arrow.right.to.line")
    public static let unindentAccessoryIcon = accessoryIcon(systemName: "arrow.left.to.line")
    public static let moveUpAccessoryIcon = accessoryIcon(systemName: "arrow.up.to.line")
    public static let moveDownAccessoryIcon = accessoryIcon(systemName: "arrow.down.to.line")
    public static let leftAccessoryIcon = accessoryIcon(systemName: "chevron.left")
    public static let rightAccessoryIcon = accessoryIcon(systemName: "chevron.right")
    public static let upAccessoryIcon = accessoryIcon(systemName: "chevron.up")
    public static let downAccessoryIcon = accessoryIcon(systemName: "chevron.down")
    public static let searchAccessoryIcon = accessoryIcon(systemName: "magnifyingglass")
    public static let doneAccessoryIcon = accessoryIcon(systemName: "xmark")
    public static let nextResultAccessoryIcon = accessoryIcon(systemName: "chevron.right.2")
    public static let previousResultAccessoryIcon = accessoryIcon(systemName: "chevron.left.2")
    public static let replaceAccessoryIcon = UIImage(named: "Replace", in: Bundle.current, with: nil)!.withRenderingMode(.alwaysTemplate)
    public static let replaceAllAccessoryIcon: UIImage = {
        let topImage = UI.textAccessoryIcon(string: "All")
        let bottomImage = UIImage(named: "ReplaceAll", in: Bundle.current, with: nil)!.withRenderingMode(.alwaysTemplate)
        return UIImage.composite(bottomImage: bottomImage, topImage: topImage, offset: CGPoint(x: 11, y: 20))
    }()
    
    public static let optionsIgnoringCaseAccessoryIcon: UIImage = {
        return UIImage.image(systemName: "ellipsis", configuration: UIImage.SymbolConfiguration(pointSize: 16.5, weight: .regular), size: CGSize(width: 30, height: 30))!
    }()
    
    public static let optionsMatchingCaseAccessoryIcon: UIImage = {
        let topImage = UI.textAccessoryIcon(string: "Case")
        let bottomImage = UIImage.image(systemName: "ellipsis", configuration: UIImage.SymbolConfiguration(pointSize: 16.5, weight: .regular), size: CGSize(width: 30, height: 30))!
        return UIImage.composite(bottomImage: bottomImage, topImage: topImage, offset: CGPoint(x: 5, y: 20))
    }()
    
    public static let optionsRegexAccessoryIcon: UIImage = {
        let topImage = UI.textAccessoryIcon(string: "Regex")
        let bottomImage = UIImage.image(systemName: "ellipsis", configuration: UIImage.SymbolConfiguration(pointSize: 16.5, weight: .regular), size: CGSize(width: 30, height: 30))!
        return UIImage.composite(bottomImage: bottomImage, topImage: topImage, offset: CGPoint(x: 3, y: 20))
    }()
    
    public static let deleteLineAccessoryIcon: UIImage = {
        let topImage = UIImage.image(systemName: "chevron.left", configuration: UIImage.SymbolConfiguration(pointSize: 16.5, weight: .regular), size: CGSize(width: 30, height: 30))!
        let bottomImage = UIImage.image(systemName: "delete.left", configuration: UIImage.SymbolConfiguration(pointSize: 17, weight: .regular), size: CGSize(width: 30, height: 30))!
        return UIImage.composite(bottomImage: bottomImage, topImage: topImage, offset: CGPoint(x: -10.5, y: 0))
    }()
    
    public class func accessoryIcon(systemName: String) -> UIImage {
        return UIImage.image(systemName: systemName, configuration: UIImage.SymbolConfiguration(pointSize: 20, weight: .light), size: CGSize(width: 30, height: 30))!
    }
    
    public class func textAccessoryIcon(string: String) -> UIImage {
        let scale = UIScreen.main.scale
        let rect = CGRect(x: 0, y: 0, width: 30*scale, height: 30*scale)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 1)
        
        // Draw text
        UIColor.black.set()
        let string = NSAttributedString(string: string, attributes: [.font: UIFont.systemFont(ofSize: 8.5*scale, weight: .medium), .foregroundColor: UIColor(white: 0.0, alpha: 1.0)])
        string.draw(at: CGPoint(x: 0*scale, y: 0*scale))
        
        // Get text image
        let textImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return textImage
    }
}

// Inline icon

extension UI {
    public class func proInlineIcon(_ theme: Theme) -> UIImage {
        let scale = UIScreen.main.scale
        let rect = CGRect(x: 0, y: 0, width: 33*scale, height: 19*scale)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 1)
        
        // Draw text background
        UIColor.white.setFill()
        let path = UIBezierPath(rect: rect)
        path.fill()
        
        // Draw text
        UIColor.black.set()
        let string = NSAttributedString(string: "Pro", attributes: [.font: UIFont.systemFont(ofSize: 12.5*scale, weight: .bold), .foregroundColor: UIColor(white: 0.0, alpha: 1.0)])
        string.draw(at: CGPoint(x: 7*scale, y: 2*scale))
        
        // Get text image
        let textImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Convert text to mask
        let maskRef = textImage.cgImage!
        let mask = CGImage(
            maskWidth: maskRef.width,
            height: maskRef.height,
            bitsPerComponent: maskRef.bitsPerComponent,
            bitsPerPixel: maskRef.bitsPerPixel,
            bytesPerRow: maskRef.bytesPerRow,
            provider: maskRef.dataProvider!,
            decode: nil,
            shouldInterpolate: false)!
        
        // Create gradient to be masked
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 1)
        UIImage(named: "smallBackground", in: Bundle.current, with: nil)!.draw(in: CGRect(x: (-25+15)*scale, y: (-25+9)*scale, width: 50*scale, height: 50*scale))
        let iconImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Mask the gradient with the mask
        let maskedImage = UIImage(cgImage: iconImage.cgImage!.masking(mask)!)
        
        // Add rounded grey background to image
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 1)
        UI.buttonColor(theme).setFill()
        UIBezierPath(roundedRect: rect, cornerRadius: 3*scale).fill()
        maskedImage.draw(in: rect)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return UIImage(cgImage: finalImage!.cgImage!, scale: scale, orientation: .up)
    }
    
    public class func proIcon(_ theme: Theme) -> UIImage {
        let scale = UIScreen.main.scale
        let rect = CGRect(x: 0, y: 0, width: 100*scale, height: 33*scale)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 1)
        
        // Draw text background
        UIColor.white.setFill()
        let path = UIBezierPath(rect: rect)
        path.fill()
        
        // Draw text
        UIColor.black.set()
        let string = NSAttributedString(string: "PolyGit Pro", attributes: [.font: UIFont.systemFont(ofSize: 16*scale, weight: .bold), .foregroundColor: UIColor(white: 0.0, alpha: 1.0)])
        string.draw(at: CGPoint(x: 9*scale, y: 6.5*scale))
        
        // Get text image
        let textImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Convert text to mask
        let maskRef = textImage.cgImage!
        let mask = CGImage(
            maskWidth: maskRef.width,
            height: maskRef.height,
            bitsPerComponent: maskRef.bitsPerComponent,
            bitsPerPixel: maskRef.bitsPerPixel,
            bytesPerRow: maskRef.bytesPerRow,
            provider: maskRef.dataProvider!,
            decode: nil,
            shouldInterpolate: false)!
        
        // Create gradient to be masked
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 1)
        UIImage(named: "smallBackground", in: Bundle.current, with: nil)!.draw(in: CGRect(x: (0)*scale, y: (-25+9)*scale, width: 130*scale, height: 100*scale))
        let iconImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Mask the gradient with the mask
        let maskedImage = UIImage(cgImage: iconImage.cgImage!.masking(mask)!)
        
        // Add rounded grey background to image
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 1)
        UI.secondaryBackgroundColor(theme).setFill()
        UIBezierPath(roundedRect: rect, cornerRadius: 5*scale).fill()
        maskedImage.draw(in: rect)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return UIImage(cgImage: finalImage!.cgImage!, scale: scale, orientation: .up)
    }
}

// Activity icon

extension UI {
    public static let exportHTMLActivityIcon: UIImage = UIImage(systemName: "doc.on.clipboard")!
}
