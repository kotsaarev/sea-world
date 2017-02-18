//
//  Cell.swift
//  Sea World
//
//  Created by User on 2/17/17.
//  Copyright © 2017 SeaWorld. All rights reserved.
//

import Cocoa

class Cell {
    
    var animal: Animal?
    var area: [Cell?]
    
    init() {
        self.area = [Cell?]()
    }
    
}
