//
//  SectionStyle.swift
//  GitApp
//
//  Created by Kevin Dang on 2/3/20.
//  Copyright © 2020 Overcyn. All rights reserved.
//

import Foundation
import SwipeCellKit

public protocol ConfigurableSection: LYSection {
    var contentPadding: UIEdgeInsets { get set }
    var behavior: LYCollectionViewBehavior? { get set }
    var style: SectionStyle { get set }
}

public struct SectionStyle {
    public var backgroundColor: UIColor? = nil
    public var alpha: CGFloat = 1.0
    public var contents: Any?
    public var clipsToBounds: Bool = false
    public var contentsGravity: CALayerContentsGravity = .resize
    public var cornerRadius: CGFloat = 0
    public var borderColor: UIColor? = nil
    public var borderWidth: CGFloat = 0
    public var maskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    public var configuredContentPadding: Bool = false // Internal flag for UI.configure()
    public var configuredCornerRadius: Bool = false // Internal flag for UI.configure()

    public init(backgroundColor: UIColor? = nil, alpha: CGFloat = 1.0, contents: Any? = nil, clipsToBounds: Bool = false, contentsGravity: CALayerContentsGravity = .resize, cornerRadius: CGFloat = 0, borderColor: UIColor? = nil, borderWidth: CGFloat = 0, maskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner], configuredContentPadding: Bool = false, configuredCornerRadius: Bool = false) {
        self.backgroundColor = backgroundColor
        self.alpha = alpha
        self.contents = contents
        self.clipsToBounds = clipsToBounds
        self.contentsGravity = contentsGravity
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.maskedCorners = maskedCorners
        self.configuredContentPadding = configuredContentPadding
        self.configuredCornerRadius = configuredCornerRadius
    }
    
    public func configure(_ view: UIView) {
        view.backgroundColor = backgroundColor
        view.alpha = alpha
        view.clipsToBounds = clipsToBounds
        view.layer.contents = contents
        view.layer.contentsGravity = contentsGravity
        view.layer.cornerRadius = cornerRadius
        view.layer.maskedCorners = maskedCorners
        view.layer.borderColor = borderColor?.cgColor
        view.layer.borderWidth = borderWidth
        view.setNeedsLayout()
    }
}

public struct SwipeItem {
    public var title: String = ""
    public var image: UIImage?
    public var style: SwipeActionStyle = .default
    public var backgroundColor: UIColor?
    public var action: Action?

    public init(title: String = "", image: UIImage? = nil, style: SwipeActionStyle = .default, backgroundColor: UIColor? = nil, action: Action? = nil) {
        self.title = title
        self.image = image
        self.style = style
        self.backgroundColor = backgroundColor
        self.action = action
    }
}
