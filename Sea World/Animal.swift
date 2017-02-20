//
//  Animal.swift
//  Sea World
//
//  Created by User on 2/11/17.
//  Copyright © 2017 SeaWorld. All rights reserved.
//

import Cocoa

class Animal {
    
    var cell: Cell?
    
    var name: String
    var image: NSImage
    
    var stepsToReproduce: Int {
        return 0
    }
    var stepsWithoutReproduce: Int
    
    required init() {
        cell = Cell()
        
        name = ""
        image = NSImage()
        
        stepsWithoutReproduce = 1
    }
    
    func live() -> Animal? {
        if isTimeToReproduce() {
            stepsWithoutReproduce = 1
            
            return reproduce()
        } else {
            stepsWithoutReproduce += 1
            
            move()
        }
        
        return nil
    }
    
    // MARK: - Life cycle
    func die() {
        cell?.animal = nil
        cell = nil
    }
    
    func move() {
        guard let cell = cell else {
            return
        }
        
        let randIndex: Int = Int(arc4random_uniform(UInt32(cell.area.count)))
        
        if let targetCell: Cell = cell.area[randIndex], targetCell.animal == nil {
            targetCell.animal = self
            
            cell.animal = nil
            self.cell = targetCell
        }
    }
    
    func reproduce() -> Animal? {
        guard let cell = cell else {
            return nil
        }
        
        var freeArea: [Cell?] = cell.area.filter{ $0?.animal == nil }
        
        if freeArea.count == 0 {
            return nil
        }
        
        let randIndex: Int = Int(arc4random_uniform(UInt32(freeArea.count)))
        
        if let freeCell: Cell = freeArea[randIndex] {
            let animal = type(of: self).init()
            
            animal.cell = freeCell
            
            freeCell.animal = animal
            
            return animal
        }
        
        return nil
    }
    
    // MARK: - Support
    func isTimeToReproduce() -> Bool {
        return stepsWithoutReproduce == stepsToReproduce
    }
    
}
