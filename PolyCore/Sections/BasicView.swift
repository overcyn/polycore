//
//  BasicView.swift
//  PolyGit
//
//  Created by Kevin Dang on 6/26/20.
//  Copyright © 2020 Overcyn. All rights reserved.
//

import Foundation
import AlamofireImage

public struct LabelComponent {
    public var padding: UIEdgeInsets = .zero
    public var text: String?
    public var font: UIFont = UIFont.systemFont(ofSize: 14)
    public var textColor: UIColor = .label
    public var attributedText: NSAttributedString?
    public var numberOfLines: Int = 1
    public var textAlignment: NSTextAlignment = .natural
    public var lineBreakMode: NSLineBreakMode = .byTruncatingTail
    public var adjustsFontSizeToFitWidth: Bool = false

    public init(padding: UIEdgeInsets = .zero,
        text: String? = nil,
        font: UIFont = UIFont.systemFont(ofSize: 14),
        textColor: UIColor = .label,
        attributedText: NSAttributedString? = nil,
        numberOfLines: Int = 1,
        textAlignment: NSTextAlignment = .natural,
        lineBreakMode: NSLineBreakMode = .byTruncatingTail,
        adjustsFontSizeToFitWidth: Bool = false) {
        self.padding = padding
        self.text = text
        self.font = font
        self.textColor = textColor
        self.attributedText = attributedText
        self.numberOfLines = numberOfLines
        self.textAlignment = textAlignment
        self.lineBreakMode = lineBreakMode
        self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
    }
    
    public func configure(_ label: UILabel) {
        label.text = text
        label.font = font
        label.textColor = textColor
        label.numberOfLines = numberOfLines
        label.textAlignment = textAlignment
        label.lineBreakMode = lineBreakMode
        label.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        if attributedText != nil {
            label.attributedText = attributedText
        }
    }
}

public struct LoadingComponent {
    public var padding: UIEdgeInsets = UIEdgeInsets(top: CGFloat.greatestFiniteMagnitude, left: 0, bottom: 0, right: 0) // top = CGFloat.greatestFiniteMagnitude to center text
    public var size: CGSize? = CGSize(width: 25, height: 25)
    
    public init(padding: UIEdgeInsets = UIEdgeInsets(top: CGFloat.greatestFiniteMagnitude, left: 0, bottom: 0, right: 0), size: CGSize? = CGSize(width: 25, height: 25)) {
        self.padding = padding
        self.size = size
    }
}

public struct ImageComponent {
    public var padding: UIEdgeInsets = .zero // top = CGFloat.greatestFiniteMagnitude to center text
    public var image: UIImage?
    public var imageURL: URL?
    public var size: CGSize?
    public var tintColor: UIColor?

    public init(padding: UIEdgeInsets = .zero, image: UIImage? = nil, imageURL: URL? = nil, size: CGSize? = nil, tintColor: UIColor? = nil) {
        self.padding = padding
        self.image = image
        self.imageURL = imageURL
        self.size = size
        self.tintColor = tintColor
    }
    
    public func configure(_ imageView: UIImageView, _ button: UIButton) {
        imageView.af.cancelImageRequest()
        imageView.tintColor = tintColor
        if let imageURL = imageURL {
            imageView.af.setImage(withURL: imageURL, placeholderImage: image, filter: CircleFilter())
        } else {
            imageView.image = image
        }
        button.tintColor = tintColor
    }
}

public class BasicView: UIView {
    public var titleView: UILabel
    public var subtitleView: UILabel
    public var subtitleButton: UIButton = BasicSectionButton(type: .custom)
    public var detailView: UILabel
    public var leadingImageView: UIImageView
    public var leadingImageButton: UIButton = UIButton(type: .custom)
    public var trailingImageView: UIImageView
    public var trailingImageButton: UIButton = UIButton(type: .custom)
    public var trailingLoadingView: UIActivityIndicatorView?
    public var titleComponent: LabelComponent = LabelComponent()
    public var subtitleComponent: LabelComponent = LabelComponent()
    public var detailComponent: LabelComponent = LabelComponent()
    public var leadingImageComponent: ImageComponent = ImageComponent()
    public var trailingImageComponent: ImageComponent = ImageComponent()
    public var trailingLoadingComponent: LoadingComponent?
    public var contentPadding: UIEdgeInsets = .zero
    public let buttonInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    public let buttonInsetsInverted = UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20)
    
    override init(frame: CGRect) {
        titleView = UILabel()
        subtitleView = UILabel()
        detailView = UILabel()
        leadingImageView = UIImageView()
        trailingImageView = UIImageView()
        super.init(frame: frame)
        addSubview(titleView)
        addSubview(subtitleView)
        subtitleButton.contentHorizontalAlignment = .left
        subtitleButton.contentVerticalAlignment = .top
        subtitleButton.contentEdgeInsets = buttonInsets
        addSubview(subtitleButton)
        addSubview(detailView)
        leadingImageButton.contentHorizontalAlignment = .fill
        leadingImageButton.contentVerticalAlignment = .fill
        leadingImageButton.contentEdgeInsets = buttonInsets
        leadingImageView.contentMode = .scaleAspectFit
        addSubview(leadingImageView)
        addSubview(leadingImageButton)
        trailingImageView.contentMode = .scaleAspectFit
        addSubview(trailingImageView)
        trailingImageButton.contentHorizontalAlignment = .fill
        trailingImageButton.contentVerticalAlignment = .fill
        trailingImageButton.contentEdgeInsets = buttonInsets
        addSubview(trailingImageButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        _ = layoutInRect(bounds)
    }
    
    func layoutInRect(_ rect1: CGRect) -> CGSize {
        let rect = rect1.inset(by: contentPadding)
        let minY = rect.minY
        var maxY = rect.minY
        var minX = rect.minX
        var maxX = rect.maxX
        let titlePadding = titleComponent.padding
        let subtitlePadding = subtitleComponent.padding
        let detailPadding = detailComponent.padding
        let leadingImagePadding = leadingImageComponent.padding
        let trailingImagePadding = trailingImageComponent.padding
        let leadingImageSize = leadingImageComponent.size
        let trailingImageSize = trailingImageComponent.size
        
        if let image = leadingImageView.image {
            var f = CGRect()
            if leadingImagePadding.top != CGFloat.greatestFiniteMagnitude {
                f.origin.y = minY + leadingImagePadding.top
            }
            f.origin.x = minX + leadingImagePadding.left
            f.size = leadingImageSize ?? image.size
            leadingImageView.frame = f
            leadingImageView.isHidden = false
            minX = f.maxX + leadingImagePadding.right
            if leadingImagePadding.top != CGFloat.greatestFiniteMagnitude {
                maxY = max(maxY, f.maxY + leadingImagePadding.bottom)
            }
            leadingImageButton.frame = f.inset(by: buttonInsetsInverted)
            leadingImageButton.imageView?.contentMode = .scaleAspectFit
            leadingImageButton.isHidden = leadingImageButton.image(for: .normal) == nil
        } else {
            leadingImageView.isHidden = true
            leadingImageButton.isHidden = true
        }
        if let image = trailingImageView.image {
            var f = CGRect()
            if trailingImagePadding.top != CGFloat.greatestFiniteMagnitude {
                f.origin.y = minY + trailingImagePadding.top
            }
            f.size = trailingImageSize ?? image.size
            f.origin.x = maxX - f.size.width - trailingImagePadding.right
            trailingImageView.frame = f
            trailingImageView.isHidden = false
            maxX = f.minX - trailingImagePadding.left
            if trailingImagePadding.top != CGFloat.greatestFiniteMagnitude {
                maxY = max(maxY, f.maxY + trailingImagePadding.bottom)
            }
            trailingImageButton.frame = f.inset(by: buttonInsetsInverted)
            trailingImageButton.imageView?.contentMode = .scaleAspectFit
            trailingImageButton.isHidden = trailingImageButton.image(for: .normal) == nil
        } else {
            trailingImageView.isHidden = true
            trailingImageButton.isHidden = true
        }
        if let component = trailingLoadingComponent {
            let view: UIActivityIndicatorView
            if let v = trailingLoadingView {
                view = v
            } else {
                view = UIActivityIndicatorView(style: .medium)
                addSubview(view)
                view.startAnimating()
                trailingLoadingView = view
            }
            view.sizeToFit()
            let ubiquitousButtonPadding = component.padding
            var f = view.frame
            f.size = component.size ?? f.size
            f.origin.x = maxX - f.size.width - ubiquitousButtonPadding.right
            if ubiquitousButtonPadding.top != CGFloat.greatestFiniteMagnitude {
                f.origin.y = minY + ubiquitousButtonPadding.top
            }
            view.frame = f
            maxX = f.minX - ubiquitousButtonPadding.left
        } else {
            trailingLoadingView?.stopAnimating()
            trailingLoadingView?.removeFromSuperview()
            trailingLoadingView = nil
        }
        var subtitleMaxY = minY
        var titleMaxX = maxX
        if subtitleView.text != nil {
            subtitleView.sizeToFit()
            let maxWidth = maxX - minX - subtitlePadding.left - subtitlePadding.right - titlePadding.left - titlePadding.right - 100
            
            var f = subtitleView.frame
            f.origin.y = minY + subtitlePadding.top
            f.size = subtitleView.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
            f.size.width = min(maxWidth, f.size.width)
            f.origin.x = maxX - f.size.width - subtitlePadding.right
            subtitleView.frame = f
            subtitleView.isHidden = subtitleButton.allTargets.count != 0
            titleMaxX = f.minX - subtitlePadding.left
            subtitleMaxY = f.maxY + subtitlePadding.bottom
            subtitleButton.frame = f.inset(by: buttonInsetsInverted)
            subtitleButton.isHidden = subtitleButton.allTargets.count == 0
        } else {
            subtitleView.isHidden = true
            subtitleButton.isHidden = true
        }
        do {
            var f = rect
            f.origin.x = minX + titlePadding.left
            f.origin.y = minY + titlePadding.top
            f.size.width = titleMaxX - titlePadding.right - f.origin.x
            f.size.height = CGFloat.greatestFiniteMagnitude
            f.size.height = titleView.sizeThatFits(f.size).height
            titleView.frame = f
            maxY = max(max(maxY, f.maxY + titlePadding.bottom), subtitleMaxY)
        }
        if detailView.text != nil {
            var f = CGRect()
            f.origin.x = minX + detailPadding.left
            f.origin.y = maxY + detailPadding.top
            f.size.width = maxX - detailPadding.right - f.origin.x
            f.size.height = CGFloat.greatestFiniteMagnitude
            f.size.height = detailView.sizeThatFits(f.size).height
            detailView.frame = f
            maxY = max(maxY, f.maxY + detailPadding.bottom)
        }
        if leadingImageView.image != nil, leadingImagePadding.top == CGFloat.greatestFiniteMagnitude {
            var f = leadingImageView.frame
            f.origin.y = minY + round((maxY - minY - f.size.height)/2)
            leadingImageView.frame = f
            leadingImageButton.frame = f.inset(by: buttonInsetsInverted)
            leadingImageButton.imageView?.contentMode = .scaleAspectFit
        }
        if trailingImageView.image != nil, trailingImagePadding.top == CGFloat.greatestFiniteMagnitude {
            var f = trailingImageView.frame
            f.origin.y = minY + round((maxY - minY - f.size.height)/2)
            trailingImageView.frame = f
            trailingImageButton.frame = f.inset(by: buttonInsetsInverted)
        }
        if let component = self.trailingLoadingComponent, component.padding.top == CGFloat.greatestFiniteMagnitude, let view = trailingLoadingView {
            var f = view.frame
            f.origin.y = minY + round((maxY - minY - f.size.height)/2)
            view.frame = f
        }
        return CGSize(width: rect.size.width + contentPadding.left + contentPadding.right, height: maxY - minY + contentPadding.top + contentPadding.bottom)
    }
    
    func updateHighlight() {
        titleComponent.configure(titleView)
        subtitleComponent.configure(subtitleView)
        detailComponent.configure(detailView)
        leadingImageComponent.configure(leadingImageView, leadingImageButton)
        trailingImageComponent.configure(trailingImageView, trailingImageButton)
    }
}

public class BasicButton: UIButton {
    public let basicView: BasicView = BasicView()
    public var buttonSection: ButtonSection = ButtonSection()
    public var actionFunc: ((UIButton) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        basicView.isUserInteractionEnabled = false
        addSubview(basicView)
        addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonAction() {
        actionFunc?(self)
    }
    
    public override var isHighlighted: Bool {
        didSet {
            update()
        }
    }
    
    public func update() {
        isEnabled = buttonSection.enabled && buttonSection.action != nil
        if !isEnabled {
            basicView.titleComponent = buttonSection.disabledTitleComponent ?? buttonSection.titleComponent
            basicView.subtitleComponent = buttonSection.disabledSubtitleComponent ?? buttonSection.subtitleComponent
            basicView.detailComponent = buttonSection.disabledDetailComponent ?? buttonSection.detailComponent
            basicView.leadingImageComponent = buttonSection.disabledLeadingImageComponent ?? buttonSection.leadingImageComponent
            basicView.trailingImageComponent = buttonSection.disabledTrailingImageComponent ?? buttonSection.trailingImageComponent
            (buttonSection.disabledStyle ?? buttonSection.buttonStyle).configure(basicView)
        } else if isHighlighted {
            basicView.titleComponent = buttonSection.highlightedTitleComponent ?? buttonSection.titleComponent
            basicView.subtitleComponent = buttonSection.highlightedSubtitleComponent ?? buttonSection.subtitleComponent
            basicView.detailComponent = buttonSection.highlightedDetailComponent ?? buttonSection.detailComponent
            basicView.leadingImageComponent = buttonSection.highlightedLeadingImageComponent ?? buttonSection.leadingImageComponent
            basicView.trailingImageComponent = buttonSection.highlightedTrailingImageComponent ?? buttonSection.trailingImageComponent
            (buttonSection.highlightedStyle ?? buttonSection.buttonStyle).configure(basicView)
        } else {
            basicView.titleComponent = buttonSection.titleComponent
            basicView.subtitleComponent = buttonSection.subtitleComponent
            basicView.detailComponent = buttonSection.detailComponent
            basicView.leadingImageComponent = buttonSection.leadingImageComponent
            basicView.trailingImageComponent = buttonSection.trailingImageComponent
            buttonSection.buttonStyle.configure(basicView)
        }
        basicView.contentPadding = buttonSection.buttonPadding
        basicView.updateHighlight()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        basicView.frame = bounds
    }
    
    public func layoutInRect(_ rect: CGRect) -> CGSize {
        var f = CGRect.zero
        f.size = basicView.layoutInRect(rect)
        basicView.frame = f
        return f.size
    }
}
