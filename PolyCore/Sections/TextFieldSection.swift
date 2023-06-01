//
//  TextFieldSection.swift
//  GitApp
//
//  Created by Kevin Dang on 9/30/19.
//  Copyright © 2019 Overcyn. All rights reserved.
//

import Foundation
import PolyCore

public class TextFieldSection: NSObject, LYSection, ConfigurableSection {
    public var identifier: String?
    public var text: String?
    public var placeholder: String?
    public var keyboardType: UIKeyboardType = .default
    public var adjustsFontSizeToFitWidth: Bool = false
    public var autocorrectionType: UITextAutocorrectionType = .default
    public var autocapitalizationType: UITextAutocapitalizationType = .sentences
    public var isSecureTextEntry: Bool = false
    public var isEnabled: Bool = true
    public var textColor: UIColor = UIColor.label
    public var font: UIFont = UIFont.systemFont(ofSize: 18)
    public var contentPadding: UIEdgeInsets = .zero // no-op
    public var style: SectionStyle = SectionStyle()
    public var behavior: LYCollectionViewBehavior?
    public var onChange: ((String?) -> ())?
//    public var onFocus: ((String?) -> ())?
    public var onBlur: ((Bool, String?) -> ())?

    public func newSectionController() -> LYSectionController {
        return TextFieldSectionController(section: self)
    }
}

class TextFieldSectionController: NSObject, LYSectionController, UITextFieldDelegate {
    let section: TextFieldSection
    weak var delegate: LYSectionDelegate?
    var behavior: LYCollectionViewBehavior? {
        return section.behavior
    }
    
    required init(section: TextFieldSection) {
        self.section = section
    }
    
    func setup() {
        delegate?.section(self, register: TextFieldSectionCell.self, forCellWithReuseIdentifier: "TextFieldSectionCell")
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = delegate?.section(self, dequeueReusableCellWithReuseIdentifier: "TextFieldSectionCell", for: index) as! TextFieldSectionCell
        configureCell(cell, at: index)
        return cell
    }
    
    func configureCell(_ c: UICollectionViewCell, at index: Int) {
        let cell = c as! TextFieldSectionCell
        cell.textField.text = section.text
        cell.textField.keyboardType = section.keyboardType
        cell.textField.placeholder = section.placeholder
        cell.textField.adjustsFontSizeToFitWidth = section.adjustsFontSizeToFitWidth
        cell.textField.autocorrectionType = section.autocorrectionType
        cell.textField.autocapitalizationType = section.autocapitalizationType
        cell.textField.isSecureTextEntry = section.isSecureTextEntry
        cell.textField.delegate = self
        cell.textField.adjustsFontSizeToFitWidth = true
        cell.textField.minimumFontSize = 10
        cell.textField.isEnabled = section.isEnabled
        cell.textField.textColor = section.textColor
        cell.textField.font = section.font
        section.style.configure(cell)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextField.textDidChangeNotification, object: cell.textField)
    }
    
    func sizeForItem(at index: Int, thatFits size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: 45)
    }
    
    @objc func textDidChange() {
        let cell = delegate?.section(self, cellForItemAt: 0) as! TextFieldSectionCell
        if section.text != cell.textField.text {
            section.text = cell.textField.text
            section.onChange?(section.text)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        section.text = textField.text
        section.onBlur?(reason == .committed, section.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

class TextFieldSectionCell: UICollectionViewCell {
    var textField: UITextField
    
    override init(frame: CGRect) {
        textField = UITextField()
        super.init(frame: frame)
        contentView.addSubview(textField)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        if let sectionController = textField.delegate {
            NotificationCenter.default.removeObserver(sectionController, name: UITextField.textDidChangeNotification, object: textField)
            textField.delegate = nil
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _ = layoutInRect(contentView.bounds)
    }
    
    func layoutInRect(_ rect: CGRect) -> CGSize {
        do {
            textField.sizeToFit()
            var f = textField.frame
            f.size.height += 15
            f.origin.y = rect.origin.y
            f.origin.x = rect.origin.x + 15
            f.size.width = rect.size.width - 30
            textField.frame = f
        }
        return rect.size
    }
}
