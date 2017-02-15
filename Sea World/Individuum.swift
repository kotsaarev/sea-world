//
//  Individuum.swift
//  Sea World
//
//  Created by User on 2/11/17.
//  Copyright © 2017 SeaWorld. All rights reserved.
//

import Cocoa

class Individuum {
    
    var area: [Individuum?]
    
    var name: String
    var image: NSImage
    
    var stepsToReproduction: Int
    
    init() {
        name = ""
        image = NSImage()
        
        area = [Individuum?](repeating: nil, count: 8)
        
        stepsToReproduction = 0
    }
    
}

// MARK: - Interface
extension Individuum {
    
    func move(from position: Int) {
        
    }
    
}
