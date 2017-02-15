//
//  Tux.swift
//  Sea World
//
//  Created by User on 2/11/17.
//  Copyright © 2017 SeaWorld. All rights reserved.
//

import Cocoa

class Tux: Individuum {
    
    override init() {
        super.init()
        
        self.name = "Tux"
        self.image = #imageLiteral(resourceName: "tux")
        
        self.stepsToReproduction = 3
    }
    
}
