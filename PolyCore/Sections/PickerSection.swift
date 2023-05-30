//
//  PickerSection.swift
//  GitApp
//
//  Created by Kevin Dang on 11/26/19.
//  Copyright © 2019 Overcyn. All rights reserved.
//

import Foundation

public class PickerSection: NSObject, LYSection, ConfigurableSection {
    public var identifier: String?
    public var value: Int = 0
    public var titles: [String] = [""]
    public var inputAttributedTitles: [NSAttributedString]?
    public var onChange: ((Int) -> ())?
    public var contentPadding: UIEdgeInsets = .zero // no-op
    public var style: SectionStyle = SectionStyle()
    public var behavior: LYCollectionViewBehavior?

    public func newSectionController() -> LYSectionController {
        return PickerSectionController(section: self)
    }
}

class PickerSectionController: NSObject, LYSectionController, UIPickerViewDelegate, UIPickerViewDataSource {
    let section: PickerSection
    weak var delegate: LYSectionDelegate?
    var behavior: LYCollectionViewBehavior? {
        return section.behavior
    }
    
    required init(section: PickerSection) {
        self.section = section
    }
    
    func setup() {
        delegate?.section(self, register: PickerSectionCell.self, forCellWithReuseIdentifier: "PickerSectionCell")
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = delegate?.section(self, dequeueReusableCellWithReuseIdentifier: "PickerSectionCell", for: index) as! PickerSectionCell
        configureCell(cell, at: index)
        return cell
    }
    
    func configureCell(_ cell: UICollectionViewCell, at index: Int) {
        guard let cell = cell as? PickerSectionCell else {
            return
        }
        cell.pickerView.dataSource = self
        cell.pickerView.delegate = self
        if cell.pickerView.selectedRow(inComponent: 0) != section.value {
            cell.pickerView.selectRow(section.value, inComponent: 0, animated: false)
        }
        if let inputAttributedTitles = section.inputAttributedTitles {
            cell.textField.attributedText = inputAttributedTitles[section.value]
        } else {
            cell.textField.text = section.titles[section.value]
        }
        section.style.configure(cell)
    }
    
    func sizeForItem(at index: Int, thatFits size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: 45)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return section.titles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return section.titles[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let cell = delegate?.section(self, cellForItemAt: 0) as! PickerSectionCell
        if let inputAttributedTitles = section.inputAttributedTitles {
            cell.textField.attributedText = inputAttributedTitles[row]
        } else {
            cell.textField.text = section.titles[row]
        }
        section.value = row
        section.onChange?(row)
    }
}

class PickerSectionCell: UICollectionViewCell {
    var textField: PickerTextField
    var pickerView: UIPickerView
    var toolBar: UIToolbar
    var titles: [String] = []
    
    override init(frame: CGRect) {
        textField = PickerTextField()
        pickerView = UIPickerView()
        toolBar = UIToolbar()
        super.init(frame: frame)
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: UIBarButtonItem.Style.done, target: self, action: #selector(doneAction))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.sizeToFit()
        toolBar.setItems([spaceButton, doneButton], animated: false)
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.inputView = pickerView
        textField.inputAccessoryView = toolBar
        contentView.addSubview(textField)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        pickerView.delegate = nil
        pickerView.dataSource = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _ = layoutInRect(contentView.bounds)
    }
    
    func layoutInRect(_ rect: CGRect) -> CGSize {
        textField.sizeToFit()
        var f = textField.frame
        f.size.height += 15
        f.origin.y = rect.origin.y
        f.origin.x = rect.origin.x + 15
        f.size.width = rect.size.width - 30
        textField.frame = f
        return rect.size
    }
    
    @objc func doneAction() {
        textField.resignFirstResponder()
    }
}

class PickerTextField: UITextField {
    override func caretRect(for position: UITextPosition) -> CGRect {
      return .zero
    }

    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
      return []
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
      return false
    }
}
