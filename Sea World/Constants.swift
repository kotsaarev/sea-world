//
//  Constants.swift
//  Sea World
//
//  Created by User on 2/17/17.
//  Copyright © 2017 SeaWorld. All rights reserved.
//

import Cocoa

class Constants: NSObject {
    
    static let areaDimension: Int = 3
    
    static let numberOfColumns: Int = 10
    static let numberOfRows: Int = 15
    
    static let percentOfOrcas: Int = 5
    static let percentOfTuxes: Int = 50
    
    static let minCellHeight: CGFloat = max(#imageLiteral(resourceName: "tux").size.height, #imageLiteral(resourceName: "orca").size.height)
    static let minCellWidth: CGFloat = max(#imageLiteral(resourceName: "tux").size.width, #imageLiteral(resourceName: "orca").size.width)
    
}
