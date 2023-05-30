//
//  SliderSection.swift
//  GitApp
//
//  Created by Kevin Dang on 3/12/20.
//  Copyright © 2020 Overcyn. All rights reserved.
//

/*
import Foundation
import PolyCore
import StepSlider

class SliderSection: NSObject, LYSection, ConfigurableSection {
    var identifier: String?
    var value: Int = 0
    var maxValue: Int = 1
    var leadingImage: UIImage?
    var trailingImage: UIImage?
    var leadingImageSize: CGSize?
    var trailingImageSize: CGSize?
    var leadingImagePadding: UIEdgeInsets = .zero
    var trailingImagePadding: UIEdgeInsets = .zero
    var contentPadding: UIEdgeInsets = .zero
    var style: SectionStyle = SectionStyle()
    var behavior: LYCollectionViewBehavior?
    var onChange: ((Int) -> ())?
    
    func newSectionController() -> LYSectionController {
        return SliderSectionController(section: self)
    }
}

class SliderSectionController: NSObject, LYSectionController {
    let section: SliderSection
    weak var delegate: LYSectionDelegate?
    var behavior: LYCollectionViewBehavior? {
        return section.behavior
    }
    
    required init(section: SliderSection) {
        self.section = section
    }
    
    func setup() {
        delegate?.section(self, register: SliderSectionCell.self, forCellWithReuseIdentifier: "SliderSectionCell")
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = delegate?.section(self, dequeueReusableCellWithReuseIdentifier: "SliderSectionCell", for: index) as! SliderSectionCell
        configureCell(cell, at: index)
        return cell
    }
    
    func configureCell(_ c: UICollectionViewCell, at index: Int) {
        let cell = c as! SliderSectionCell
        cell.slider.removeTarget(nil, action: nil, for: .allEvents)
        if cell.slider.maxCount != UInt(section.maxValue + 1) {
            cell.slider.maxCount = UInt(section.maxValue + 1)
        }
        if cell.slider.index != UInt(section.value) {
            cell.slider.index = UInt(section.value)
        }
        cell.contentPadding = section.contentPadding
        cell.leadingImageView.image = section.leadingImage
        cell.trailingImageView.image = section.trailingImage
        cell.leadingImageSize = section.leadingImageSize
        cell.trailingImageSize = section.trailingImageSize
        cell.leadingImagePadding = section.leadingImagePadding
        cell.trailingImagePadding = section.trailingImagePadding
        cell.slider.addTarget(self, action: #selector(valueDidChange(_:)), for: .valueChanged)
        section.style.configure(cell)
    }
    
    static let sizingCell = SliderSectionCell()
    func sizeForItem(at index: Int, thatFits size: CGSize) -> CGSize {
        let sizingCell = SliderSectionController.sizingCell
        configureCell(sizingCell, at: index)
        return sizingCell.layoutInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
    }
    
    @objc func valueDidChange(_ slider: StepSlider) {
        guard Int(slider.index) != section.value else {
            return
        }
        section.value = Int(slider.index)
        section.onChange?(section.value)
    }
}

class SliderSectionCell: UICollectionViewCell {
    var slider: StepSlider
    var leadingImageView: UIImageView
    var trailingImageView: UIImageView
    var leadingImageSize: CGSize?
    var trailingImageSize: CGSize?
    var leadingImagePadding: UIEdgeInsets = .zero
    var trailingImagePadding: UIEdgeInsets = .zero
    var contentPadding: UIEdgeInsets = .zero
    
    override init(frame: CGRect) {
        slider = StepSlider()
        slider.sliderCircleColor = .systemGray3
        slider.trackColor = .systemGray2
//        slider.tintColor = .systemGray2
        leadingImageView = UIImageView()
        trailingImageView = UIImageView()
        super.init(frame: frame)
        contentView.addSubview(slider)
        contentView.addSubview(leadingImageView)
        contentView.addSubview(trailingImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutInRect(_ rect1: CGRect) -> CGSize {
        let rect = rect1.inset(by: contentPadding)
        let minY = rect.minY
        var maxY = rect.minY
        var minX = rect.minX
        var maxX = rect.maxX
        if let image = leadingImageView.image {
            var f = CGRect()
            if leadingImagePadding.top != CGFloat.greatestFiniteMagnitude {
                f.origin.y = minY + leadingImagePadding.top
            }
            f.origin.x = minX + leadingImagePadding.left
            f.size = leadingImageSize ?? image.size
            leadingImageView.frame = f
            leadingImageView.isHidden = false
            minX = f.maxX + leadingImagePadding.right
            if leadingImagePadding.top != CGFloat.greatestFiniteMagnitude {
                maxY = max(maxY, f.maxY + leadingImagePadding.bottom)
            }
        } else {
            leadingImageView.isHidden = true
        }
        if let image = trailingImageView.image {
            var f = CGRect()
            if trailingImagePadding.top != CGFloat.greatestFiniteMagnitude {
                f.origin.y = minY + trailingImagePadding.top
            }
            f.size = trailingImageSize ?? image.size
            f.origin.x = maxX - f.size.width - trailingImagePadding.right
            trailingImageView.frame = f
            trailingImageView.isHidden = false
            maxX = f.minX - trailingImagePadding.left
            if trailingImagePadding.top != CGFloat.greatestFiniteMagnitude {
                maxY = max(maxY, f.maxY + trailingImagePadding.bottom)
            }
        } else {
            trailingImageView.isHidden = true
        }
        do {
            var f = slider.frame
            f.origin.x = minX
            f.origin.y = minY
            f.size.width = maxX - minX
            slider.frame = f
            maxY = max(maxY, f.minY + 25)
        }
        if leadingImageView.image != nil, leadingImagePadding.top == CGFloat.greatestFiniteMagnitude {
            var f = leadingImageView.frame
            f.origin.y = minY + round((maxY - minY - f.size.height)/2)
            leadingImageView.frame = f
        }
        if trailingImageView.image != nil, trailingImagePadding.top == CGFloat.greatestFiniteMagnitude {
            var f = trailingImageView.frame
            f.origin.y = minY + round((maxY - minY - f.size.height)/2)
            trailingImageView.frame = f
        }
        return CGSize(width: rect1.size.width, height: maxY + contentPadding.bottom)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _ = layoutInRect(contentView.bounds)
    }
}
*/
