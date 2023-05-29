//
//  CollectionExtensions.swift
//  GitApp
//
//  Created by Kevin Dang on 4/10/20.
//  Copyright © 2020 Overcyn. All rights reserved.
//

import Foundation

extension Collection {
    // Returns the element at the specified index if it is within bounds, otherwise nil.
    public subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
