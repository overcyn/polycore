//
//  ProButtonSection.swift
//  PolyGit
//
//  Created by Kevin Dang on 6/23/20.
//  Copyright © 2020 Overcyn. All rights reserved.
//

import Foundation

public class ProButtonSection: NSObject, LYSection, ConfigurableSection {
    public var identifier: String?
    public var title: String?
    public var subtitle: String?
    public var detail: String?
    public var selected: Bool = false
    public var action: Action?
    public var contentPadding: UIEdgeInsets = .zero // no-op
    public var style: SectionStyle = SectionStyle()
    public var behavior: LYCollectionViewBehavior?

    public func newSectionController() -> LYSectionController {
        return ProButtonSectionController(section: self)
    }
}

class ProButtonSectionController: NSObject, LYSectionController {
    let section: ProButtonSection
    weak var delegate: LYSectionDelegate?
    var behavior: LYCollectionViewBehavior? {
        return section.behavior
    }
    
    required init(section: ProButtonSection) {
        self.section = section
    }
    
    func setup() {
        delegate?.section(self, register: ProButtonSectionCell.self, forCellWithReuseIdentifier: "ProButtonSectionCell")
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = delegate?.section(self, dequeueReusableCellWithReuseIdentifier: "ProButtonSectionCell", for: index) as! ProButtonSectionCell
        configureCell(cell, at: index)
        return cell
    }
    
    func configureCell(_ cell: UICollectionViewCell, at index: Int) {
        guard let cell = cell as? ProButtonSectionCell else {
            return
        }
        cell.button.removeTarget(nil, action: nil, for: .touchUpInside)
        cell.button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        cell.button.isSelected = section.selected
        cell.button.proTitleLabel.text = section.title
        cell.button.proDetailLabel.text = section.detail
        cell.button.proSubtitleLabel.text = section.subtitle
        if section.action != nil {
            cell.button.isEnabled = true
        } else {
            cell.button.isEnabled = false
        }
        cell.button.isHighlighted = false
        section.style.configure(cell)
    }
    
    let sizingCell = ProButtonSectionCell()
    func sizeForItem(at index: Int, thatFits size: CGSize) -> CGSize {
        return sizingCell.layoutInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
    }
    
    @objc func buttonAction() {
        if let viewController = delegate?.parentViewController(forSection: self) {
            section.action?.perform(with: viewController)
        }
    }
}

class ProButtonSectionCell: UICollectionViewCell {
    var button: ProButton
    
    override init(frame: CGRect) {
        button = ProButton(type: .custom)
        super.init(frame: frame)
        contentView.addSubview(button)
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
        f.size = button.layoutInRect(f)
        button.frame = f
        return CGSize(width: rect.size.width, height: f.size.height)
    }
}

class ProButton: UIButton, ThemeControllerObserver {
    let proBackgroundImageView: UIImageView = UIImageView()
    let proTitleLabel: UILabel = UILabel()
    let proSubtitleLabel: UILabel = UILabel()
    let proDetailLabel: UILabel = UILabel()
    let proImageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        proBackgroundImageView.contentMode = .scaleAspectFill
        addSubview(proBackgroundImageView)
        proTitleLabel.text = " "
        proTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        addSubview(proTitleLabel)
        proSubtitleLabel.text = " "
        proSubtitleLabel.font = UIFont.italicSystemFont(ofSize: 15)
        addSubview(proSubtitleLabel)
        proDetailLabel.text = " "
        proDetailLabel.font = UIFont.systemFont(ofSize: 16)
        addSubview(proDetailLabel)
        addSubview(proImageView)
        isSelected = false
        
        ThemeController.shared.observers.append(WeakThemeControllerObserver(self))
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _ = layoutInRect(bounds)
    }
    
    override var isSelected: Bool {
        didSet {
            update()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            update()
        }
    }
        
    func layoutInRect(_ rect1: CGRect) -> CGSize {
        let contentPadding = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        let subtitlePadding = UIEdgeInsets(top: 12, left: 10, bottom: 0, right: 0)
        let titlePadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let detailPadding = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        let leadingImagePadding = UIEdgeInsets(top: CGFloat.greatestFiniteMagnitude, left: -3, bottom: 0, right: 10-3)
        
        let rect = rect1.inset(by: contentPadding)
        let minY = rect.minY
        var maxY = rect.minY
        var minX = rect.minX
        let maxX = rect.maxX
        do {
            var f = CGRect()
            if leadingImagePadding.top != CGFloat.greatestFiniteMagnitude {
                f.origin.y = minY + leadingImagePadding.top
            }
            f.origin.x = minX + leadingImagePadding.left
            f.size = proImageView.image?.size ?? CGSize.zero
            proImageView.frame = f
            minX = f.maxX + leadingImagePadding.right
            if leadingImagePadding.top != CGFloat.greatestFiniteMagnitude {
                maxY = max(maxY, f.maxY + leadingImagePadding.bottom)
            }
        }
        var subtitleMaxY = minY
        _ = subtitleMaxY
        var titleMaxX = maxX
        do {
            proSubtitleLabel.sizeToFit()
            let maxWidth = maxX - minX - subtitlePadding.left - subtitlePadding.right - titlePadding.left - titlePadding.right - 100
            
            var f = proSubtitleLabel.frame
            f.origin.y = minY + subtitlePadding.top
            f.size = proSubtitleLabel.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
            f.size.width = min(maxWidth, f.size.width)
            f.origin.x = maxX - f.size.width - subtitlePadding.right
            proSubtitleLabel.frame = f
            titleMaxX = f.minX - subtitlePadding.left
            subtitleMaxY = f.maxY + subtitlePadding.bottom
        }
        do {
            var f = rect
            f.origin.x = minX + titlePadding.left
            f.origin.y = minY + titlePadding.top
            f.size.width = titleMaxX - titlePadding.right - f.origin.x
            f.size.height = CGFloat.greatestFiniteMagnitude
            f.size.height = proTitleLabel.sizeThatFits(f.size).height
            proTitleLabel.frame = f
            maxY = max(maxY, f.maxY + titlePadding.bottom)
        }
        do {
            var f = CGRect()
            f.origin.x = minX + detailPadding.left
            f.origin.y = maxY + detailPadding.top
            f.size.width = titleMaxX - detailPadding.right - f.origin.x
            f.size.height = CGFloat.greatestFiniteMagnitude
            f.size.height = proDetailLabel.sizeThatFits(f.size).height
            proDetailLabel.frame = f
            maxY = max(maxY, f.maxY + detailPadding.bottom)
        }
        if leadingImagePadding.top == CGFloat.greatestFiniteMagnitude {
            var f = proImageView.frame
            f.origin.y = minY + round((maxY - minY - f.size.height)/2)
            proImageView.frame = f
        }
        proBackgroundImageView.frame = rect1
        return CGSize(width: rect.size.width + contentPadding.left + contentPadding.right, height: maxY - minY + contentPadding.top + contentPadding.bottom)
    }
    
    // MARK: ThemeControllerObserver
    
    func themeControllerOnUpdate(_: ThemeController) {
        update()
    }
    
    // MARK: Internal
    
    func update() {
        let theme = ThemeController.shared.theme(kind: .modal)
        if isSelected {
            let bottomImage = UIImage.image(systemName: "circle.fill", configuration: UIImage.SymbolConfiguration(pointSize: 23, weight: .medium), size: CGSize(width:30, height: 50))!.withTintColor(.white).withRenderingMode(.alwaysOriginal)
            let topImage = UIImage.image(systemName: "checkmark", configuration: UIImage.SymbolConfiguration(pointSize: 26, weight: .semibold), size: CGSize(width: 30, height: 50))!.withTintColor(.systemGreen).withRenderingMode(.alwaysOriginal)
            let image = UIImage.composite(bottomImage: bottomImage, topImage: topImage, offset: CGPoint(x: 3, y: -5)).withRenderingMode(.alwaysOriginal)
            
            proBackgroundImageView.image = UIImage(named: "background", in: Bundle.current, with: nil)
            proTitleLabel.textColor = .white
            proSubtitleLabel.textColor = .white
            proDetailLabel.textColor = .white
            proImageView.image = image
            proImageView.tintColor = .white
            backgroundColor = UI.secondaryBackgroundColor(theme)
        } else if isHighlighted {
            let theme = ThemeController.shared.theme(kind: .modal)
            let image = UIImage.image(systemName: "circle", configuration: UIImage.SymbolConfiguration(pointSize: 23, weight: .medium), size: CGSize(width:30, height: 50))!.withTintColor(UI.chevronColor(theme)).withRenderingMode(.alwaysOriginal)
            
            proBackgroundImageView.image = nil
            proTitleLabel.textColor = .label
            proSubtitleLabel.textColor = .secondaryLabel
            proDetailLabel.textColor = .label
            proImageView.image = image
            backgroundColor = UI.highlightedButtonColor(theme)
        } else {
            let theme = ThemeController.shared.theme(kind: .modal)
            let image = UIImage.image(systemName: "circle", configuration: UIImage.SymbolConfiguration(pointSize: 23, weight: .medium), size: CGSize(width:30, height: 50))!.withTintColor(UI.chevronColor(theme)).withRenderingMode(.alwaysOriginal)
            
            proBackgroundImageView.image = nil
            proTitleLabel.textColor = .label
            proSubtitleLabel.textColor = .secondaryLabel
            proDetailLabel.textColor = .label
            proImageView.image = image
            backgroundColor = UI.secondaryBackgroundColor(theme)
        }
    }

}
