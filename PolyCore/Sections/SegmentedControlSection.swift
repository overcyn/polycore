//
//  SegmentedControlSection.swift
//  GitApp
//
//  Created by Kevin Dang on 1/6/20.
//  Copyright © 2020 Overcyn. All rights reserved.
//

import Foundation

public class SegmentedControlSection: NSObject, LYSection, ConfigurableSection {
    public var identifier: String?
    public var value: Int = 0
    public var titles: [String] = []
    public var onChange: ((Int) -> ())?
    public var contentPadding: UIEdgeInsets = .zero
    public var style: SectionStyle = SectionStyle()
    public var behavior: LYCollectionViewBehavior?
    
    public func newSectionController() -> LYSectionController {
        return SegmentedControlSectionController(section: self)
    }
}

class SegmentedControlSectionController: NSObject, LYSectionController, UITextViewDelegate {
    let section: SegmentedControlSection
    var behavior: LYCollectionViewBehavior? {
        return section.behavior
    }
    weak var delegate: LYSectionDelegate?
    
    required init(section: SegmentedControlSection) {
        self.section = section
    }
    
    func setup() {
        delegate?.section(self, register: SegmentedControlSectionCell.self, forCellWithReuseIdentifier: "SegmentedControlSectionCell")
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = delegate?.section(self, dequeueReusableCellWithReuseIdentifier: "SegmentedControlSectionCell", for: index) as! SegmentedControlSectionCell
        configureCell(cell, at: 0)
        return cell
    }
    
    func sizeForItem(at index: Int, thatFits size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: 32 + section.contentPadding.top + section.contentPadding.bottom)
    }
    
    func configureCell(_ c: UICollectionViewCell, at index: Int) {
        let cell = c as! SegmentedControlSectionCell
        cell.segmentedControl.removeAllSegments()
        for (idx, i) in section.titles.enumerated() {
            cell.segmentedControl.insertSegment(withTitle: i, at: idx, animated: false)
        }
        cell.segmentedControl.selectedSegmentIndex = section.value
        cell.segmentedControl.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
        cell.contentPadding = section.contentPadding
        section.style.configure(cell)
    }
    
    @objc func valueChanged(_ segmentedControl: UISegmentedControl) {
        section.value = segmentedControl.selectedSegmentIndex
        section.onChange?(segmentedControl.selectedSegmentIndex)
    }
}

class SegmentedControlSectionCell: UICollectionViewCell {
    var segmentedControl: UISegmentedControl = UISegmentedControl()
    var contentPadding: UIEdgeInsets = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(segmentedControl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _ = layoutInRect(contentView.bounds)
    }
    
    func layoutInRect(_ rect: CGRect) -> CGSize {
        segmentedControl.frame = rect.inset(by: contentPadding)
        return rect.size
    }
}
