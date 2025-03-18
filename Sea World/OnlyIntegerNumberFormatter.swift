//
//  OnlyIntegerNumberFormatter.swift
//  Sea World
//
//  Created by User on 2/18/17.
//  Copyright © 2017 SeaWorld. All rights reserved.
//

import Cocoa

class OnlyIntegerNumberFormatter: NumberFormatter, @unchecked Sendable {
    
    override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        if partialString.isEmpty {
            return true
        }
        
        if let value = Int(partialString) {
            return value >= 0
        }
        
        return false
    }
    
}
