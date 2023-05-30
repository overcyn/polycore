//
//  ButtonGroupSection.swift
//  PolyGit
//
//  Created by Kevin Dang on 6/27/20.
//  Copyright © 2020 Overcyn. All rights reserved.
//

import Foundation

public class ButtonGroupSection: NSObject, LYSection, ConfigurableSection {
    public var identifier: String?
    public var style: SectionStyle = SectionStyle()
    public var behavior: LYCollectionViewBehavior?
    public var contentPadding: UIEdgeInsets = .zero
    
    public var buttonSections: [ButtonSection] = []
    public var widths: [CGFloat?] = []
    public var spacing: CGFloat = 12.0
    
    public func newSectionController() -> LYSectionController {
        return ButtonGroupSectionController(section: self)
    }
}

class ButtonGroupSectionController: NSObject, LYSectionController {
    let section: ButtonGroupSection
    weak var delegate: LYSectionDelegate?
    var behavior: LYCollectionViewBehavior? {
        return section.behavior
    }
    
    required init(section: ButtonGroupSection) {
        self.section = section
    }
    
    func setup() {
        delegate?.section(self, register: ButtonGroupSectionCell.self, forCellWithReuseIdentifier: "ButtonGroupSectionCell")
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = delegate?.section(self, dequeueReusableCellWithReuseIdentifier: "ButtonGroupSectionCell", for: index) as! ButtonGroupSectionCell
        configureCell(cell, at: index)
        return cell
    }
    
    func configureCell(_ cell: UICollectionViewCell, at index: Int) {
        guard let cell = cell as? ButtonGroupSectionCell else {
            return
        }
        
        let viewController = delegate?.parentViewController(forSection: self)
        let buttons: [BasicButton] = section.buttonSections.map({ i in
            let action = i.action
            let button = BasicButton()
            button.buttonSection = i
            button.actionFunc = { button in
                guard let viewController = viewController else {
                    return
                }
                if let viewAction = action as? ViewAction {
                    viewAction.perform(with: viewController, view: button)
                } else {
                    action?.perform(with: viewController)
                }
            }
            button.isHighlighted = false
            button.update()
            return button
        })
        cell.buttons = buttons
        cell.widths = section.widths
        cell.spacing = section.spacing
        cell.contentPadding = section.contentPadding
        section.style.configure(cell)
    }
    
    static let sizingCell = ButtonGroupSectionCell()
    func sizeForItem(at index: Int, thatFits size: CGSize) -> CGSize {
        let cell = ButtonGroupSectionController.sizingCell
        configureCell(cell, at: index)
        return cell.layoutInRect(CGRect(origin: CGPoint.zero, size: size))
    }
}

class ButtonGroupSectionCell: UICollectionViewCell {
    var spacing: CGFloat = 12
    var widths: [CGFloat?] = []
    var buttons: [BasicButton] = [] {
        didSet {
            for i in oldValue {
                i.removeFromSuperview()
            }
            for i in buttons {
                contentView.addSubview(i)
            }
        }
    }
    var contentPadding: UIEdgeInsets = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _ = layoutInRect(contentView.bounds)
    }
    
    func layoutInRect(_ rect: CGRect) -> CGSize {
        var widths = self.widths
        if widths.count != buttons.count {
            widths = buttons.map({ _ in
                return nil
            })
        }
        
        var flexibleCount = 0
        var availableWidth = rect.size.width - contentPadding.left - contentPadding.right - spacing * CGFloat(buttons.count - 1)
        for i in widths {
            if let width = i {
                availableWidth -= width
            } else {
                flexibleCount += 1
            }
        }
        let flexibleWidth = availableWidth / CGFloat(flexibleCount)
        
        var minX = rect.minX + contentPadding.left
        let minY = rect.minY + contentPadding.top
        var maxY = minY
        for i in 0..<buttons.count {
            let button = buttons[i]
            let width = widths[i] ?? flexibleWidth
            var f = CGRect.zero
            f.origin.x = minX
            f.origin.y = minY
            f.size = button.layoutInRect(CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
            button.frame = f
            minX = f.maxX + spacing
            maxY = max(maxY, f.maxY)
        }
        return CGSize(width: rect.width, height: maxY - minY + contentPadding.top + contentPadding.bottom)
    }
}
