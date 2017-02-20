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
    
    var color: NSColor
    
    required init() {
        cell = Cell()
        
        name = ""
        image = NSImage()
        
        stepsWithoutReproduce = 1
        
        let r: CGFloat = CGFloat(arc4random_uniform(UInt32(255)))
        let g: CGFloat = CGFloat(arc4random_uniform(UInt32(255)))
        let b: CGFloat = CGFloat(arc4random_uniform(UInt32(255)))
        
        let a: CGFloat = CGFloat(arc4random_uniform(UInt32(100)))
        
        color = NSColor(calibratedRed: r/255, green: g/255, blue: b/255, alpha: a/100)
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
        
        var freeArea: [Cell?] = cell.area.filter{ $0?.animal == nil }
        
        if freeArea.count == 0 {
            return
        }
        
        let randIndex: Int = Int(arc4random_uniform(UInt32(freeArea.count)))
        
        if let freeCell: Cell = freeArea[randIndex] {
            freeCell.animal = self
            
            cell.animal = nil
            self.cell = freeCell
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
