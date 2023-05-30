//
//  SeparatorSection.swift
//  GitApp
//
//  Created by Kevin Dang on 10/1/19.
//  Copyright © 2019 Overcyn. All rights reserved.
//

import Foundation

public class LoadingSection: NSObject, LYSection, ConfigurableSection {
    public var identifier: String?
    public var contentPadding: UIEdgeInsets = .zero // no-op
    public var style: SectionStyle = SectionStyle()
    public var behavior: LYCollectionViewBehavior?
    
    public func newSectionController() -> LYSectionController {
        return LoadingSectionController(section: self)
    }
}

class LoadingSectionController: NSObject, LYSectionController {
    let section: LoadingSection
    weak var delegate: LYSectionDelegate?
    var behavior: LYCollectionViewBehavior? {
        return section.behavior
    }
    
    required init(section: LoadingSection) {
        self.section = section
    }
    
    func setup() {
        delegate?.section(self, register: LoadingSectionCell.self, forCellWithReuseIdentifier: "LoadingSectionCell")
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = delegate?.section(self, dequeueReusableCellWithReuseIdentifier: "LoadingSectionCell", for: index) as! LoadingSectionCell
        cell.loadingIndicator.startAnimating()
        configureCell(cell, at: index)
        return cell
    }
    
    let sizingCell = LoadingSectionCell()
    func sizeForItem(at index: Int, thatFits size: CGSize) -> CGSize {
        return sizingCell.layoutInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
    }
    
    func configureCell(_ cell: UICollectionViewCell, at index: Int) {
        guard let cell = cell as? LoadingSectionCell else {
            return
        }
        section.style.configure(cell)
    }
}

class LoadingSectionCell: UICollectionViewCell {
    var loadingIndicator: UIActivityIndicatorView
    
    override init(frame: CGRect) {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        super.init(frame: frame)
        contentView.addSubview(loadingIndicator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _ = layoutInRect(contentView.bounds)
    }
    
    func layoutInRect(_ rect: CGRect) -> CGSize {
        loadingIndicator.sizeToFit()
        var f = loadingIndicator.frame
        f.origin.y = rect.origin.y
        f.origin.x = rect.origin.x
        f.size.width = bounds.size.width
        f.size.height += 40
        loadingIndicator.frame = f
        return CGSize(width: rect.width, height: loadingIndicator.frame.height)
    }

}
