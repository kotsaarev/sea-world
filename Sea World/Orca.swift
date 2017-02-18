//
//  Orca.swift
//  Sea World
//
//  Created by User on 2/11/17.
//  Copyright © 2017 SeaWorld. All rights reserved.
//

import Cocoa

class Orca: Animal {
    
    var stepsWithoutEat: Int
    var stepsToDie: Int {
        return 3
    }
    
    override var stepsToReproduce: Int {
        return 8
    }
    
    required init() {
        self.stepsWithoutEat = 0
        
        super.init()
        
        self.name = "Orca"
        self.image = #imageLiteral(resourceName: "orca")
    }
    
    override func live() -> Animal? {
        if isTimeToDie() {
            die()
            return nil
        } else {
            stepsWithoutEat += 1
        }
        
        if isTimeToReproduce(), let baby = reproduce() {
            stepsWithoutReproduce = 0
            
            return baby
        } else {
            stepsWithoutReproduce += 1
        }
        
        if eatTux() {
            stepsWithoutEat = 0
            
            return nil
        } else {
            move()
        }
        
        return nil
    }
    
    // MARK: - Life cicle
    func eatTux() -> Bool {
        guard let cell = cell else {
            return false
        }
        
        var tuxArea: [Cell?] = cell.area.filter{ $0?.animal is Tux }
        
        if tuxArea.count == 0 {
            return false
        }
        
        let randIndex: Int = Int(arc4random_uniform(UInt32(tuxArea.count)))
        
        if let tuxCell: Cell = tuxArea[randIndex] {
            tuxCell.animal?.die()
            tuxCell.animal = self
            
            cell.animal = nil
            self.cell = tuxCell
            
            return true
        }
        
        return false
    }
    
    // MARK: - Support
    func isTimeToDie() -> Bool {
        return stepsWithoutEat == stepsToDie
    }
    
}
