//
//  BundleExtensions.swift
//  PolyCore
//
//  Created by overcyn on 5/29/23.
//

import Foundation

extension Bundle {
    static var current: Bundle {
        class __ { }
        return Bundle(for: __.self)
    }
}
