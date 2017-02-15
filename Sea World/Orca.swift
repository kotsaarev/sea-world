//
//  Orca.swift
//  Sea World
//
//  Created by User on 2/11/17.
//  Copyright © 2017 SeaWorld. All rights reserved.
//

import Cocoa

class Orca: Individuum {
    
    override init() {
        super.init()
        
        self.name = "Orca"
        self.image = #imageLiteral(resourceName: "orca")
        
        self.stepsToReproduction = 8
    }
    
}
