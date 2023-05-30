//
//  UIImageExtensions.swift
//  GitApp
//
//  Created by Kevin Dang on 3/9/20.
//  Copyright © 2020 Overcyn. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    public static func image(systemName: String, configuration: UIImage.SymbolConfiguration, size: CGSize) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)

        if let img = UIImage(systemName: systemName)?.withConfiguration(configuration) {
            img.draw(in: CGRect(x: (rect.size.width - img.size.width) / 2, y: (rect.size.height - img.size.height) / 2, width: img.size.width, height: img.size.height))
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image?.withRenderingMode(.alwaysTemplate)
    }
    
    public static func composite(bottomImage: UIImage, topImage: UIImage, offset: CGPoint = CGPoint.zero) -> UIImage {
        let newSize = bottomImage.size
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        bottomImage.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        topImage.draw(in: CGRect(origin: offset, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    public static func image(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
