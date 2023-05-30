//
//  BasicSection.swift
//  GitApp
//
//  Created by Kevin Dang on 9/30/19.
//  Copyright © 2019 Overcyn. All rights reserved.
//

import Foundation
import SwipeCellKit

public class BasicSection: NSObject, LYSection, ConfigurableSection {
    public var identifier: String?
    public var titleText: String?
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 14)
    public var titleTextColor: UIColor = .label
    public var titleAttributedText: NSAttributedString?
    public var titlePadding: UIEdgeInsets = .zero
    public var titleNumberOfLines: Int = 1
    public var titleTextAlignment: NSTextAlignment = .natural
    public var titleLineBreakMode: NSLineBreakMode = .byTruncatingTail
    public var titleAdjustsFontSizeToFitWidth: Bool = false
    public var subtitleText: String?
    public var subtitleFont: UIFont = UIFont.systemFont(ofSize: 14)
    public var subtitleTextColor: UIColor = .label
    public var subtitleAttributedText: NSAttributedString?
    public var subtitlePadding: UIEdgeInsets = .zero
    public var subtitleNumberOfLines: Int = 1
    public var subtitleTextAlignment: NSTextAlignment = .natural
    public var subtitleLineBreakMode: NSLineBreakMode = .byTruncatingTail
    public var subtitleAdjustsFontSizeToFitWidth: Bool = false
    public var subtitleAction: Action?
    public var detailText: String?
    public var detailFont: UIFont = UIFont.systemFont(ofSize: 14)
    public var detailTextColor: UIColor = .label
    public var detailAttributedText: NSAttributedString?
    public var detailPadding: UIEdgeInsets = .zero
    public var detailNumberOfLines: Int = 1
    public var detailTextAlignment: NSTextAlignment = .natural
    public var detailLineBreakMode: NSLineBreakMode = .byTruncatingTail
    public var leadingImage: UIImage?
    public var leadingImageURL: URL?
    public var leadingImageAction: Action?
    public var leadingImageSize: CGSize?
    public var leadingImagePadding: UIEdgeInsets = .zero // top = CGFloat.greatestFiniteMagnitude to center text
    public var leadingImageTintColor: UIColor?
    public var trailingImage: UIImage?
    public var trailingImageURL: URL?
    public var trailingImageAction: Action?
    public var trailingImageSize: CGSize?
    public var trailingImagePadding: UIEdgeInsets = .zero // top = CGFloat.greatestFiniteMagnitude to center text
    public var trailingImageTintColor: UIColor?
    public var trailingLoadingComponent: LoadingComponent?
    public var contentPadding: UIEdgeInsets = .zero
    public var action: Action?
    public var contextMenu: ContextMenu?
    public var swipeMenu: [SwipeItem]?
    public var behavior: LYCollectionViewBehavior?
    public var style: SectionStyle = SectionStyle()
    
    public func newSectionController() -> LYSectionController {
        return BasicSectionController(section: self)
    }
}

class BasicSectionController: NSObject, LYSectionController, SwipeCollectionViewCellDelegate {
    let section: BasicSection
    weak var delegate: LYSectionDelegate?
    var behavior: LYCollectionViewBehavior? {
        return section.behavior
    }
    
    required init(section: BasicSection) {
        self.section = section
    }
    
    func setup() {
        delegate?.section(self, register: BasicSectionCell.self, forCellWithReuseIdentifier: "BasicSectionCell")
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = delegate?.section(self, dequeueReusableCellWithReuseIdentifier: "BasicSectionCell", for: index) as! BasicSectionCell
        configureCell(cell, at: index)
        return cell
    }
    
    static let sizingCell = BasicSectionCell()
    func sizeForItem(at index: Int, thatFits size: CGSize) -> CGSize {
        let cell = BasicSectionController.sizingCell
        configureCell(cell, at: index)
        return cell.layoutInRect(CGRect(origin: CGPoint.zero, size: size))
    }
    
    func selectItem(at index: Int) {
        guard let viewController = delegate?.parentViewController(forSection: self) else {
            return
        }
        if let viewAction = section.action as? ViewAction, let view = delegate?.section(self, cellForItemAt: index) {
            viewAction.perform(with: viewController, view: view)
        } else {
            section.action?.perform(with: viewController)
        }
    }
    
    func configureCell(_ cell: UICollectionViewCell, at index: Int) {
        guard let cell = cell as? BasicSectionCell else {
            return
        }
        cell.shouldHighlight = section.action != nil
        
        var titleComponent = LabelComponent()
        titleComponent.text = section.titleText
        titleComponent.font = section.titleFont
        titleComponent.textColor = section.titleTextColor
        titleComponent.numberOfLines = section.titleNumberOfLines
        titleComponent.textAlignment = section.titleTextAlignment
        titleComponent.lineBreakMode = section.titleLineBreakMode
        titleComponent.adjustsFontSizeToFitWidth = section.titleAdjustsFontSizeToFitWidth
        titleComponent.attributedText = section.titleAttributedText
        titleComponent.padding = section.titlePadding
        cell.titleComponent = titleComponent
        
        var subtitleComponent = LabelComponent()
        subtitleComponent.text = section.subtitleText
        subtitleComponent.font = section.subtitleFont
        subtitleComponent.textColor = section.subtitleTextColor
        subtitleComponent.numberOfLines = section.subtitleNumberOfLines
        subtitleComponent.textAlignment = section.subtitleTextAlignment
        subtitleComponent.lineBreakMode = section.subtitleLineBreakMode
        subtitleComponent.adjustsFontSizeToFitWidth = section.subtitleAdjustsFontSizeToFitWidth
        subtitleComponent.attributedText = section.subtitleAttributedText
        subtitleComponent.padding = section.subtitlePadding
        cell.subtitleComponent = subtitleComponent
        
        if section.subtitleAction != nil {
            cell.basicView.subtitleButton.setTitle(section.subtitleText, for: .normal)
            cell.basicView.subtitleButton.setTitleColor(section.subtitleTextColor, for: .normal)
            cell.basicView.subtitleButton.titleLabel?.font = section.subtitleFont
            if section.subtitleAttributedText != nil {
                cell.basicView.subtitleButton.setAttributedTitle(section.subtitleAttributedText, for: .normal)
            }
            cell.basicView.subtitleButton.titleLabel?.lineBreakMode = section.subtitleLineBreakMode
            cell.basicView.subtitleButton.removeTarget(nil, action: nil, for: .allEvents)
            cell.basicView.subtitleButton.addTarget(self, action: #selector(subtitleAction(_:)), for: .touchUpInside)
        } else {
            cell.basicView.subtitleButton.removeTarget(nil, action: nil, for: .allEvents)
        }
        
        var detailComponent = LabelComponent()
        detailComponent.text = section.detailText
        detailComponent.font = section.detailFont
        detailComponent.textColor = section.detailTextColor
        detailComponent.numberOfLines = section.detailNumberOfLines
        detailComponent.textAlignment = section.detailTextAlignment
        detailComponent.attributedText = section.detailAttributedText
        detailComponent.lineBreakMode = section.detailLineBreakMode
        detailComponent.padding = section.detailPadding
        cell.detailComponent = detailComponent
        
        var leadingImageComponent = ImageComponent()
        leadingImageComponent.padding = section.leadingImagePadding
        leadingImageComponent.image = section.leadingImage
        leadingImageComponent.size = section.leadingImageSize
        leadingImageComponent.tintColor = section.leadingImageTintColor
        leadingImageComponent.imageURL = section.leadingImageURL
        cell.leadingImageComponent = leadingImageComponent
        
        if section.leadingImageAction != nil {
            cell.basicView.leadingImageButton.setImage(section.leadingImage, for: .normal)
            cell.basicView.leadingImageButton.removeTarget(nil, action: nil, for: .allEvents)
            cell.basicView.leadingImageButton.addTarget(self, action: #selector(leadingImageAction(_:)), for: .touchUpInside)
        } else {
            cell.basicView.leadingImageButton.setImage(nil, for: .normal)
            cell.basicView.leadingImageButton.removeTarget(nil, action: nil, for: .allEvents)
        }
        
        var trailingImageComponent = ImageComponent()
        trailingImageComponent.padding = section.trailingImagePadding
        trailingImageComponent.image = section.trailingImage
        trailingImageComponent.size = section.trailingImageSize
        trailingImageComponent.tintColor = section.trailingImageTintColor
        trailingImageComponent.imageURL = section.trailingImageURL
        cell.trailingImageComponent = trailingImageComponent
        
        cell.trailingLoadingComponent = section.trailingLoadingComponent
        
        if section.trailingImageAction != nil {
            cell.basicView.trailingImageButton.setImage(section.trailingImage, for: .normal)
            cell.basicView.trailingImageButton.removeTarget(nil, action: nil, for: .allEvents)
            cell.basicView.trailingImageButton.addTarget(self, action: #selector(trailingImageAction(_:)), for: .touchUpInside)
        } else {
            cell.basicView.trailingImageButton.setImage(nil, for: .normal)
            cell.basicView.trailingImageButton.removeTarget(nil, action: nil, for: .allEvents)
        }
        cell.basicView.contentPadding = section.contentPadding
        cell.delegate = self
        cell.updateHighlight()
        section.style.configure(cell)
    }
    
    func contextMenu(at index: Int) -> UIContextMenuConfiguration? {
        if section.contextMenu == nil {
            return nil
        }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { [weak self] suggestedActions in
            guard let self = self else {
                return nil
            }
            guard let viewController = self.delegate?.parentViewController(forSection: self) else {
                return nil
            }
            guard let view = self.delegate?.section(self, cellForItemAt: index) else {
                return nil
            }
            return self.section.contextMenu?.menu(viewController: viewController, view: view)
        })
    }
    
    @objc func leadingImageAction(_ button: UIButton) {
        guard let viewController = delegate?.parentViewController(forSection: self) else {
            return
        }
        if let viewAction = section.leadingImageAction as? ViewAction {
            viewAction.perform(with: viewController, view: button)
        } else {
            section.leadingImageAction?.perform(with: viewController)
        }
    }
    
    @objc func trailingImageAction(_ button: UIButton) {
        guard let viewController = delegate?.parentViewController(forSection: self) else {
            return
        }
        if let viewAction = section.trailingImageAction as? ViewAction {
            viewAction.perform(with: viewController, view: button)
        } else {
            section.trailingImageAction?.perform(with: viewController)
        }
    }
    
    @objc func subtitleAction(_ button: UIButton) {
        guard let viewController = delegate?.parentViewController(forSection: self) else {
            return
        }
        if let viewAction = section.subtitleAction as? ViewAction {
            viewAction.perform(with: viewController, view: button)
        } else {
            section.subtitleAction?.perform(with: viewController)
        }
    }
    
    // MARK: SwipeCollectionViewCellDelegate
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else {
            return nil
        }
        let swipeActions = section.swipeMenu?.map({ i -> SwipeAction in
            let action = SwipeAction(style: i.style, title: i.title, handler: { [weak self] (_, _) in
                guard let self = self, let viewController = self.delegate?.parentViewController(forSection: self) else {
                    return
                }
                let cell = collectionView.cellForItem(at: indexPath) as? SwipeCollectionViewCell
                cell?.hideSwipe(animated: true)
                if let viewAction = i.action as? ViewAction, let view = cell {
                    viewAction.perform(with: viewController, view: view)
                } else {
                    i.action?.perform(with: viewController)
                }
            })
            action.backgroundColor = i.backgroundColor
            return action
        })
        return swipeActions
    }
}

class BasicSectionCell: SwipeCollectionViewCell {
    var shouldHighlight: Bool = true
    var titleComponent: LabelComponent = LabelComponent()
    var subtitleComponent: LabelComponent = LabelComponent()
    var detailComponent: LabelComponent = LabelComponent()
    var leadingImageComponent: ImageComponent = ImageComponent()
    var trailingImageComponent: ImageComponent = ImageComponent()
    var trailingLoadingComponent: LoadingComponent?
    var basicView: BasicView = BasicView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(basicView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _ = layoutInRect(contentView.bounds)
    }
    
    func layoutInRect(_ rect: CGRect) -> CGSize {
        var f = CGRect.zero
        f.size = basicView.layoutInRect(rect)
        basicView.frame = f
        return f.size
    }
    
    override var isHighlighted: Bool {
        didSet {
            updateHighlight()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            updateHighlight()
        }
    }
    
    func updateHighlight() {
        let highlight = (isHighlighted && shouldHighlight) || (isSelected && shouldHighlight)
//        contentView.backgroundColor = highlight ? UI.defaultSelectionColor : .clear
        contentView.backgroundColor = highlight ? UIColor.systemBlue.withAlphaComponent(0.7) : .clear
        
        var titleConfig = self.titleComponent
        var subtitleConfig = self.subtitleComponent
        var detailConfig = self.detailComponent
        var leadingImageConfig = self.leadingImageComponent
        var trailingImageConfig = self.trailingImageComponent
        if highlight {
            titleConfig.textColor = .white
            subtitleConfig.textColor = .white
            detailConfig.textColor = .white
            leadingImageConfig.tintColor = .white
            trailingImageConfig.tintColor = .white
            if let attrText = titleConfig.attributedText {
                let mutAttrText = NSMutableAttributedString(attributedString: attrText)
                mutAttrText.addAttributes([.foregroundColor: UIColor.white], range: NSRange(location: 0, length: mutAttrText.length))
                titleConfig.attributedText = mutAttrText
            }
            if let attrText = subtitleConfig.attributedText {
                let mutAttrText = NSMutableAttributedString(attributedString: attrText)
                mutAttrText.addAttributes([.foregroundColor: UIColor.white], range: NSRange(location: 0, length: mutAttrText.length))
                subtitleConfig.attributedText = mutAttrText
            }
            if let attrText = detailConfig.attributedText {
                let mutAttrText = NSMutableAttributedString(attributedString: attrText)
                mutAttrText.addAttributes([.foregroundColor: UIColor.white], range: NSRange(location: 0, length: mutAttrText.length))
                detailConfig.attributedText = mutAttrText
            }
        }
        basicView.titleComponent = titleConfig
        basicView.subtitleComponent = subtitleConfig
        basicView.detailComponent = detailConfig
        basicView.leadingImageComponent = leadingImageConfig
        basicView.trailingImageComponent = trailingImageConfig
        basicView.trailingLoadingComponent = trailingLoadingComponent
        basicView.updateHighlight()
    }
}

class BasicSectionButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            guard oldValue != isHighlighted else {
                return
            }
            UIView.animate(withDuration: 0.1, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                self.alpha = self.isHighlighted ? 0.3 : 1
            }, completion: nil)
        }
    }
}
