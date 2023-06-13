//
//  TitleSection.swift
//  GitApp
//
//  Created by Kevin Dang on 4/14/20.
//  Copyright © 2020 Overcyn. All rights reserved.
//

import Foundation

public class TitleSection: NSObject, LYSection, ConfigurableSection {
    public var identifier: String?
    public var contentPadding: UIEdgeInsets = .zero
    public var titleText: String?
    public var titleTextColor: UIColor?
    public var loading: Bool = false
    public var behavior: LYCollectionViewBehavior?
    public var style: SectionStyle = SectionStyle()
    
    public func newSectionController() -> LYSectionController {
        return TitleSectionController(section: self)
    }
}

class TitleSectionController: NSObject, LYSectionController {
    let section: TitleSection
    weak var delegate: LYSectionDelegate?
    var behavior: LYCollectionViewBehavior? {
        return section.behavior
    }
    
    required init(section: TitleSection) {
        self.section = section
    }
    
    func setup() {
        delegate?.section(self, register: TitleSectionCell.self, forCellWithReuseIdentifier: "TitleSectionCell")
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = delegate?.section(self, dequeueReusableCellWithReuseIdentifier: "TitleSectionCell", for: index) as! TitleSectionCell
        configureCell(cell, at: index)
        return cell
    }
    
    static let sizingCell = TitleSectionCell()
    func sizeForItem(at index: Int, thatFits size: CGSize) -> CGSize {
        let cell = TitleSectionController.sizingCell
        configureCell(cell, at: index)
        return cell.layoutInRect(CGRect(origin: CGPoint.zero, size: size))
    }
        
    func configureCell(_ cell: UICollectionViewCell, at index: Int) {
        guard let cell = cell as? TitleSectionCell else {
            return
        }
        cell.contentPadding = section.contentPadding
        cell.titleView.text = section.titleText
        cell.titleView.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        cell.titleView.textColor = section.titleTextColor
        if section.loading {
            cell.loadingIndicator.startAnimating()
        } else {
            cell.loadingIndicator.stopAnimating()
        }
        section.style.configure(cell)
    }
}

class TitleSectionCell: UICollectionViewCell {
    var titleView: UILabel
    var loadingIndicator: UIActivityIndicatorView
    var contentPadding: UIEdgeInsets = .zero
        
    override init(frame: CGRect) {
        titleView = UILabel()
        loadingIndicator = UIActivityIndicatorView(style: .medium)
        super.init(frame: frame)
        contentView.addSubview(titleView)
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
        var f = rect
        f.origin.x = rect.minX + contentPadding.left
        f.origin.y = rect.minY + contentPadding.top
        f.size.width = rect.width - contentPadding.left - contentPadding.right
        f.size.height = titleView.sizeThatFits(rect.size).height
        titleView.frame = f
        
        let r = CGSize(width: rect.size.width, height: f.maxY - rect.minY + contentPadding.bottom)
        
        loadingIndicator.sizeToFit()
        var f2 = loadingIndicator.frame
        f2.origin.y = rect.minY + (r.height / 2) - (f2.size.height / 2)
        f2.origin.x = rect.maxX - contentPadding.right - f2.size.width
        loadingIndicator.frame = f2
        return r
    }
}
