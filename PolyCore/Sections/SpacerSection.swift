//
//  SeparatorSection.swift
//  GitApp
//
//  Created by Kevin Dang on 10/1/19.
//  Copyright © 2019 Overcyn. All rights reserved.
//

import Foundation

public class SpacerSection: NSObject, LYSection, ConfigurableSection {
    public var identifier: String?
    public var height: CGFloat = 0
    public var contentPadding: UIEdgeInsets = .zero // no-op
    public var style: SectionStyle = SectionStyle()
    public var behavior: LYCollectionViewBehavior?
    
    public init(height: CGFloat) {
        self.height = height
    }
    
    public func newSectionController() -> LYSectionController {
        return SpacerSectionController(section: self)
    }
}

class SpacerSectionController: NSObject, LYSectionController {
    let section: SpacerSection
    var behavior: LYCollectionViewBehavior? {
        return section.behavior
    }
    weak var delegate: LYSectionDelegate?
    
    required init(section: SpacerSection) {
        self.section = section
    }
    
    func setup() {
        delegate?.section(self, register: SpacerSectionCell.self, forCellWithReuseIdentifier: "SpacerSectionCell")
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = (delegate?.section(self, dequeueReusableCellWithReuseIdentifier: "SpacerSectionCell", for: index))!
        configureCell(cell, at: 0)
        return cell
    }
    
    func sizeForItem(at index: Int, thatFits size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: section.height)
    }
    
    func configureCell(_ cell: UICollectionViewCell, at index: Int) {
        guard let cell = cell as? SpacerSectionCell else {
            return
        }
        cell.isUserInteractionEnabled = false
        section.style.configure(cell)
    }
}

class SpacerSectionCell: UICollectionViewCell {
    
}
