//
//  ImageSection.swift
//  PolyGit
//
//  Created by Kevin Dang on 9/16/20.
//  Copyright © 2020 Overcyn. All rights reserved.
//

import Foundation

public class ImageSection: NSObject, LYSection, ConfigurableSection {
    public var identifier: String?
    public var image: UIImage?
    public var ratio: CGFloat = 1.0
    public var contentPadding: UIEdgeInsets = .zero // no-op
    public var style: SectionStyle = SectionStyle()
    public var behavior: LYCollectionViewBehavior?
    
    public func newSectionController() -> LYSectionController {
        return ImageSectionController(section: self)
    }
}

class ImageSectionController: NSObject, LYSectionController {
    let section: ImageSection
    var behavior: LYCollectionViewBehavior? {
        return section.behavior
    }
    weak var delegate: LYSectionDelegate?
    
    required init(section: ImageSection) {
        self.section = section
    }
    
    func setup() {
        delegate?.section(self, register: ImageSectionCell.self, forCellWithReuseIdentifier: "ImageSectionCell")
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = (delegate?.section(self, dequeueReusableCellWithReuseIdentifier: "ImageSectionCell", for: index))!
        configureCell(cell, at: 0)
        return cell
    }
    
    func sizeForItem(at index: Int, thatFits size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: size.width * section.ratio)
    }
    
    func configureCell(_ cell: UICollectionViewCell, at index: Int) {
        guard let cell = cell as? ImageSectionCell else {
            return
        }
        cell.isUserInteractionEnabled = false
        cell.imageView.image = section.image
        cell.imageView.clipsToBounds = true
        cell.imageView.contentMode = .scaleAspectFill
        section.style.configure(cell)
    }
}

class ImageSectionCell: UICollectionViewCell {
    var imageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        imageView.frame = bounds
    }
}
