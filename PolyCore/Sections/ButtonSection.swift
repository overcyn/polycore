//
//  ButtonSection2.swift
//  PolyGit
//
//  Created by Kevin Dang on 6/26/20.
//  Copyright © 2020 Overcyn. All rights reserved.
//

import Foundation

public class ButtonSection: NSObject, LYSection, ConfigurableSection {
    public var identifier: String?
    public var contentPadding: UIEdgeInsets = .zero
    public var style: SectionStyle = SectionStyle()
    public var behavior: LYCollectionViewBehavior?
    
    // Component
    public var action: Action?
    public var enabled: Bool = true
    public var buttonPadding: UIEdgeInsets = .zero
    
    public var titleComponent: LabelComponent = LabelComponent()
    public var subtitleComponent: LabelComponent = LabelComponent()
    public var detailComponent: LabelComponent = LabelComponent()
    public var leadingImageComponent: ImageComponent = ImageComponent()
    public var trailingImageComponent: ImageComponent = ImageComponent()
    public var buttonStyle: SectionStyle = SectionStyle()
    
    public var highlightedTitleComponent: LabelComponent?
    public var highlightedSubtitleComponent: LabelComponent?
    public var highlightedDetailComponent: LabelComponent?
    public var highlightedLeadingImageComponent: ImageComponent?
    public var highlightedTrailingImageComponent: ImageComponent?
    public var highlightedStyle: SectionStyle?

    public var disabledTitleComponent: LabelComponent?
    public var disabledSubtitleComponent: LabelComponent?
    public var disabledDetailComponent: LabelComponent?
    public var disabledLeadingImageComponent: ImageComponent?
    public var disabledTrailingImageComponent: ImageComponent?
    public var disabledStyle: SectionStyle?
    
    public var title: String? {
        set {
            let val = newValue
            titleComponent.text = val
            highlightedTitleComponent?.text = val
            disabledTitleComponent?.text = val
        }
        get {
            return titleComponent.text
        }
    }
    
    public var detailTitle: String? {
        set {
            let val = newValue
            detailComponent.text = val
            highlightedDetailComponent?.text = val
            disabledDetailComponent?.text = val
        }
        get {
            return detailComponent.text
        }
    }
    
    public func newSectionController() -> LYSectionController {
        return ButtonSectionController(section: self)
    }
}

class ButtonSectionController: NSObject, LYSectionController {
    let section: ButtonSection
    weak var delegate: LYSectionDelegate?
    var behavior: LYCollectionViewBehavior? {
        return section.behavior
    }
    
    required init(section: ButtonSection) {
        self.section = section
    }
    
    func setup() {
        delegate?.section(self, register: ButtonSectionCell.self, forCellWithReuseIdentifier: "ButtonSectionCell")
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = delegate?.section(self, dequeueReusableCellWithReuseIdentifier: "ButtonSectionCell", for: index) as! ButtonSectionCell
        configureCell(cell, at: index)
        return cell
    }
    
    func configureCell(_ cell: UICollectionViewCell, at index: Int) {
        guard let cell = cell as? ButtonSectionCell else {
            return
        }
        
        let viewController = delegate?.parentViewController(forSection: self)
        let action = section.action
        
        cell.button.buttonSection = section
        cell.button.actionFunc = { button in
            guard let viewController = viewController else {
                return
            }
            if let viewAction = action as? ViewAction {
                viewAction.perform(with: viewController, view: button)
            } else {
                action?.perform(with: viewController)
            }
        }
        cell.button.isHighlighted = false
        cell.button.update()
        cell.contentPadding = section.contentPadding
        section.style.configure(cell)
    }
    
    static let sizingCell = ButtonSectionCell()
    func sizeForItem(at index: Int, thatFits size: CGSize) -> CGSize {
        let cell = ButtonSectionController.sizingCell
        configureCell(cell, at: index)
        return cell.layoutInRect(CGRect(origin: CGPoint.zero, size: size))
    }
}

class ButtonSectionCell: UICollectionViewCell {
    let button: BasicButton
    var contentPadding: UIEdgeInsets = .zero
    
    override init(frame: CGRect) {
        button = BasicButton(type: .custom)
        super.init(frame: frame)
        contentView.addSubview(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = contentView.bounds.inset(by: contentPadding)
    }
    
    func layoutInRect(_ rect: CGRect) -> CGSize {
        var childBounds = rect.inset(by: contentPadding)
        childBounds.origin = .zero
        var f = rect.inset(by: contentPadding)
        f.size = button.layoutInRect(childBounds)
        button.frame = f
        let invertedPadding = UIEdgeInsets(top: -contentPadding.top, left: -contentPadding.left, bottom: -contentPadding.bottom, right: -contentPadding.right)
        return f.inset(by: invertedPadding).size
    }
}
