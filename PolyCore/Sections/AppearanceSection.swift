//
//  AppearanceSection.swift
//  GitApp
//
//  Created by Kevin Dang on 2/6/20.
//  Copyright © 2020 Overcyn. All rights reserved.
//

import Foundation

public class AppearanceSection: NSObject, LYSection {
    public var onAppear: (() -> ())?
    public var didAppear: Bool = false

    public func newSectionController() -> LYSectionController {
        return AppearanceSectionController(section: self)
    }
}

class AppearanceSectionController: NSObject, LYSectionController {
    let section: AppearanceSection
    weak var delegate: LYSectionDelegate?
    
    required init(section: AppearanceSection) {
        self.section = section
    }
    
    func setup() {
        delegate?.section(self, register: AppearanceSectionCell.self, forCellWithReuseIdentifier: "AppearanceSectionCell")
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        if !section.didAppear {
            section.didAppear = true
            DispatchQueue.main.async {
                self.section.onAppear?()
            }
        }
        
        let cell = delegate?.section(self, dequeueReusableCellWithReuseIdentifier: "AppearanceSectionCell", for: index) as! AppearanceSectionCell
        configureCell(cell, at: index)
        return cell
    }
    
    func sizeForItem(at index: Int, thatFits size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: 1)
    }
    
    func configureCell(_ cell: UICollectionViewCell, at index: Int) {
        guard let cell = cell as? AppearanceSectionCell else {
            return
        }
        _ = cell
    }
}

class AppearanceSectionCell: UICollectionViewCell {
}
