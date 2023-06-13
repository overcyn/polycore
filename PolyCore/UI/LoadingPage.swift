//
//  LoadingPage.swift
//  GitApp
//
//  Created by Kevin Dang on 11/26/19.
//  Copyright © 2019 Overcyn. All rights reserved.
//

import Foundation

public class LoadingPage: NSObject, LYPage {
    let loadingSection = LoadingSection()
    let titleSection = BasicSection.default()
    
    public init(showProgress: Bool = true) {
        self.showProgress = showProgress
    }
    
    public var progress: PolyCore.Progress = PolyCore.Progress() {
        didSet {
            if oldValue != progress {
                self.delegate?.pageDidUpdate(self)
            }
        }
    }
    public var delegate: LYPageDelegate?
    public var showProgress = true
    
    public func render(_ input: LYPageInput) -> LYPageOutput {
        let theme = Theme(kind: .modal)
        let output = LYPageOutput()
        
        var array: [LYSection] = []
        if showProgress {
            array.append(SpacerSection(height: 170))
        }
        array.append(loadingSection)
        if showProgress {
            var percentage = (progress.percentage ?? 0)
            if percentage.isNaN || percentage.isInfinite {
                percentage = 0
            }
            let p = max(min(Int(percentage * 1000), 1000), 0)
            let progressInteger = Int(p/10)
            let progressDecimal = p % 10
            
            let color = UI.secondaryLabelColor(theme)
            let percentColor = UIColor.quaternaryLabel
            let attributedString = NSMutableAttributedString()
            attributedString.append(NSAttributedString(string: "\(progressInteger)", attributes: [.font: UIFont.monospacedDigitSystemFont(ofSize: 60, weight: .bold), .foregroundColor: color]))
            attributedString.append(NSAttributedString(string: ".", attributes: [.font: UIFont.boldSystemFont(ofSize: 60), .foregroundColor: color]))
            attributedString.append(NSAttributedString(string: "\(progressDecimal)", attributes: [.font: UIFont.monospacedDigitSystemFont(ofSize: 60, weight: .bold), .foregroundColor: color]))
            attributedString.append(NSAttributedString(string: "%", attributes: [.font: UIFont.boldSystemFont(ofSize: 40), .foregroundColor: percentColor]))
            
            let section = titleSection
            section.titleAttributedText = attributedString
            section.titleTextAlignment = .center
            section.detailText = progress.description ?? NSLocalizedString("Loading...", comment: "")
            section.detailTextColor = UIColor.tertiaryLabel
            section.detailFont = UIFont.boldSystemFont(ofSize: 20)
            section.detailTextAlignment = .center
            array.append(section)
        }
        output.sections = array
        UI.configure(theme, input: input, output: output)
        return output
    }
}
