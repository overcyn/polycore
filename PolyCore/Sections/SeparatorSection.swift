//
//  SeparatorSection.swift
//  GitApp
//
//  Created by Kevin Dang on 10/1/19.
//  Copyright © 2019 Overcyn. All rights reserved.
//

import Foundation

public class SeparatorSection: NSObject, LYSection, ConfigurableSection {
    public var identifier: String?
    public var padding: CGFloat = 0
    public var height: CGFloat = 1
    public var contentPadding: UIEdgeInsets = .zero // no-op
    public var style: SectionStyle = SectionStyle()
    public var behavior: LYCollectionViewBehavior?
    
    public func newSectionController() -> LYSectionController {
        return SeparatorSectionController(section: self)
    }
}

class SeparatorSectionController: NSObject, LYSectionController {
    let section: SeparatorSection
    weak var delegate: LYSectionDelegate?
    var behavior: LYCollectionViewBehavior? {
        return section.behavior
    }
    
    required init(section: SeparatorSection) {
        self.section = section
    }
    
    func setup() {
        delegate?.section(self, register: SeparatorSectionCell.self, forCellWithReuseIdentifier: "SeparatorSectionCell")
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = delegate?.section(self, dequeueReusableCellWithReuseIdentifier: "SeparatorSectionCell", for: index) as! SeparatorSectionCell
        configureCell(cell, at: index)
        return cell
    }
    
    func sizeForItem(at index: Int, thatFits size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: section.height)
    }
    
    func configureCell(_ cell: UICollectionViewCell, at index: Int) {
        guard let cell = cell as? SeparatorSectionCell else {
            return
        }
        cell.padding = section.padding
        cell.isUserInteractionEnabled = false
        section.style.configure(cell)
    }
}

class SeparatorSectionCell: UICollectionViewCell {
    var separator: UIView
    var padding: CGFloat = 0
    
    override init(frame: CGRect) {
        separator = UIView()
        super.init(frame: frame)
        contentView.addSubview(separator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _ = layoutInRect(contentView.bounds)
    }
    
    func layoutInRect(_ rect: CGRect) -> CGSize {
        do {
            var f = CGRect.zero
            f.size.height = rect.size.height
            f.origin.y = rect.origin.y
            f.origin.x = rect.origin.x + padding
            f.size.width = rect.size.width - padding
            separator.frame = f
        }
        return rect.size
    }
}
