//
//  Errors.swift
//  PolyCore
//
//  Created by overcyn on 5/29/23.
//

import Foundation

public struct StringError: LocalizedError {
    public let errorDescription: String?
    
    public init(_ string: String) {
        errorDescription = string
    }
}
