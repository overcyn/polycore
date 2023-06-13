//
//  StepperSection.swift
//  PolyGit
//
//  Created by Kevin Dang on 6/3/20.
//  Copyright © 2020 Overcyn. All rights reserved.
//

import Foundation

public class StepperSection: NSObject, LYSection, ConfigurableSection {
    public var identifier: String?
    public var value: Double = 0
    public var minimumValue: Double = 0
    public var maximumValue: Double = 100
    public var stepValue: Double = 1
    public var stepperPadding: UIEdgeInsets = .zero // top = CGFloat.greatestFiniteMagnitude to center
    public var onChange: ((Double) -> ())? = nil
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
        return StepperSectionController(section: self)
    }
}

class StepperSectionController: NSObject, LYSectionController, UITextFieldDelegate {
    let section: StepperSection
    weak var delegate: LYSectionDelegate?
    var behavior: LYCollectionViewBehavior? {
        return section.behavior
    }
    
    required init(section: StepperSection) {
        self.section = section
    }
    
    func setup() {
        delegate?.section(self, register: StepperSectionCell.self, forCellWithReuseIdentifier: "StepperSectionCell")
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = delegate?.section(self, dequeueReusableCellWithReuseIdentifier: "StepperSectionCell", for: index) as! StepperSectionCell
        configureCell(cell, at: index)
        return cell
    }
    
    static let sizingCell = StepperSectionCell()
    func sizeForItem(at index: Int, thatFits size: CGSize) -> CGSize {
        let cell = StepperSectionController.sizingCell
        configureCell(cell, at: index)
        return cell.layoutInRect(CGRect(origin: CGPoint.zero, size: size))
    }
    
    func configureCell(_ cell: UICollectionViewCell, at index: Int) {
        guard let cell = cell as? StepperSectionCell else {
            return
        }
        cell.stepperView.value = section.value
        cell.stepperView.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
        cell.stepperView.minimumValue = section.minimumValue
        cell.stepperView.maximumValue = section.maximumValue
        cell.stepperPadding = section.stepperPadding
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
    
    @objc func valueChanged(_ stepperView: UIStepper) {
        section.value = stepperView.value
        section.onChange?(section.value)
    }
}

class StepperSectionCell: UICollectionViewCell {
    var stepperView: UIStepper
    var titleView: UILabel
    var contentPadding: UIEdgeInsets = .zero
    var titlePadding: UIEdgeInsets = .zero
    var stepperPadding: UIEdgeInsets = .zero
    
    override init(frame: CGRect) {
        stepperView = UIStepper()
        titleView = UILabel()
        super.init(frame: frame)
        contentView.addSubview(stepperView)
        contentView.addSubview(titleView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        stepperView.removeTarget(nil, action: nil, for: .allEvents)
    }
    
    func layoutInRect(_ r: CGRect) -> CGSize {
        let rect = r.inset(by: contentPadding)
        let minY = rect.minY
        var maxY = rect.minY
        let minX = rect.minX
        var maxX = rect.maxX
        do {
            stepperView.sizeToFit()
            var f = stepperView.frame
            f.origin.x = maxX - f.size.width - stepperPadding.right
            f.origin.y = minY + stepperPadding.top
            stepperView.frame = f
//            maxY = f.maxY + switchPadding.bottom
            maxX = f.minX - stepperPadding.left
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
        if stepperPadding.top == CGFloat.greatestFiniteMagnitude {
            var f = stepperView.frame
            f.origin.y = minY + round((maxY - minY - f.size.height)/2)
            stepperView.frame = f
        }
        return CGSize(width: rect.size.width + contentPadding.left + contentPadding.right, height: maxY - minY + contentPadding.top + contentPadding.bottom)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _ = layoutInRect(contentView.bounds)
    }
}
