//
//  CheckboxSection.swift
//  GitApp
//
//  Created by Kevin Dang on 11/25/19.
//  Copyright © 2019 Overcyn. All rights reserved.
//

import Foundation
import PolyCore

public class SwitchSection: NSObject, LYSection, ConfigurableSection {
    public var identifier: String?
    public var value: Bool = false
    public var switchPadding: UIEdgeInsets = .zero // top = CGFloat.greatestFiniteMagnitude to center
    public var onChange: ((Bool) -> ())? = nil
    public var titleText: String?
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 14)
    public var titleTextColor: UIColor = .label
    public var titleAttributedText: NSAttributedString?
    public var titlePadding: UIEdgeInsets = .zero
    public var titleNumberOfLines: Int = 1
    public var titleTextAlignment: NSTextAlignment = .natural
    public var contentPadding: UIEdgeInsets = .zero
    public var style: SectionStyle = SectionStyle()
    public var behavior: LYCollectionViewBehavior?

    public func newSectionController() -> LYSectionController {
        return SwitchSectionController(section: self)
    }
}

class SwitchSectionController: NSObject, LYSectionController, UITextFieldDelegate {
    let section: SwitchSection
    weak var delegate: LYSectionDelegate?
    var behavior: LYCollectionViewBehavior? {
        return section.behavior
    }
    
    required init(section: SwitchSection) {
        self.section = section
    }
    
    func setup() {
        delegate?.section(self, register: SwitchSectionCell.self, forCellWithReuseIdentifier: "SwitchSectionCell")
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = delegate?.section(self, dequeueReusableCellWithReuseIdentifier: "SwitchSectionCell", for: index) as! SwitchSectionCell
        configureCell(cell, at: index)
        return cell
    }
    
    static let sizingCell = SwitchSectionCell()
    func sizeForItem(at index: Int, thatFits size: CGSize) -> CGSize {
        let cell = SwitchSectionController.sizingCell
        configureCell(cell, at: index)
        return cell.layoutInRect(CGRect(origin: CGPoint.zero, size: size))
    }
    
    func configureCell(_ cell: UICollectionViewCell, at index: Int) {
        guard let cell = cell as? SwitchSectionCell else {
            return
        }
        cell.switchView.isOn = section.value
        cell.switchView.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
        cell.switchPadding = section.switchPadding
        cell.titleView.text = section.titleText
        cell.titleView.font = section.titleFont
        cell.titleView.textColor = section.titleTextColor
        cell.titleView.numberOfLines = section.titleNumberOfLines
        cell.titleView.textAlignment = section.titleTextAlignment
        if section.titleAttributedText != nil {
            cell.titleView.attributedText = section.titleAttributedText
        }
        cell.titlePadding = section.titlePadding
        cell.contentPadding = section.contentPadding
        section.style.configure(cell)
    }
    
    @objc func valueChanged(_ switchView: UISwitch) {
        section.value = switchView.isOn
        section.onChange?(section.value)
    }
}

class SwitchSectionCell: UICollectionViewCell {
    var switchView: UISwitch
    var titleView: UILabel
    var contentPadding: UIEdgeInsets = .zero
    var titlePadding: UIEdgeInsets = .zero
    var switchPadding: UIEdgeInsets = .zero
    
    override init(frame: CGRect) {
        switchView = UISwitch()
        titleView = UILabel()
        super.init(frame: frame)
        contentView.addSubview(switchView)
        contentView.addSubview(titleView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        switchView.removeTarget(nil, action: nil, for: .allEvents)
    }
    
    func layoutInRect(_ r: CGRect) -> CGSize {
        let rect = r.inset(by: contentPadding)
        let minY = rect.minY
        var maxY = rect.minY
        let minX = rect.minX
        var maxX = rect.maxX
        do {
            switchView.sizeToFit()
            var f = switchView.frame
            f.origin.x = maxX - f.size.width - switchPadding.right
            f.origin.y = minY + switchPadding.top
            switchView.frame = f
//            maxY = f.maxY + switchPadding.bottom
            maxX = f.minX - switchPadding.left
        }
        do {
            var f = rect
            f.origin.x = minX + titlePadding.left
            f.origin.y = minY + titlePadding.top
            f.size.width = maxX - titlePadding.right - f.origin.x
            f.size.height = CGFloat.greatestFiniteMagnitude
            f.size.height = titleView.sizeThatFits(f.size).height
            titleView.frame = f
            maxY = max(maxY, f.maxY + titlePadding.bottom)
        }
        if switchPadding.top == CGFloat.greatestFiniteMagnitude {
            var f = switchView.frame
            f.origin.y = minY + round((maxY - minY - f.size.height)/2)
            switchView.frame = f
        }
        return CGSize(width: rect.size.width + contentPadding.left + contentPadding.right, height: maxY - minY + contentPadding.top + contentPadding.bottom)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _ = layoutInRect(contentView.bounds)
    }
}
