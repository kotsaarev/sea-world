//
//  World.swift
//  Sea World
//
//  Created by User on 2/18/17.
//  Copyright © 2017 SeaWorld. All rights reserved.
//

import Cocoa

class World {
    
    var cells: [[Cell]]
    var population: [Animal]
    
    var step: Int
    
    init() {
        let numberOfColumns: Int = Constants.numberOfColumns
        let numberOfRows: Int = Constants.numberOfRows
        
        let percentOfOrcas: Int = Constants.percentOfOrcas
        let percentOfTuxes: Int = Constants.percentOfTuxes
        
        assert((percentOfOrcas + percentOfTuxes) <= 100, "wrong total ratio")
        assert(
            (numberOfColumns >= Constants.areaDimension) && (numberOfRows >= Constants.areaDimension),
            "table too small \"\(numberOfColumns)x\(numberOfRows)\", must be >= \"\(Constants.areaDimension)x\(Constants.areaDimension)\""
        )
        
        self.cells = [[Cell]]()
        self.population = [Animal]()
        
        self.step = 0
        
        for column in 0 ..< numberOfColumns {
            cells.append([Cell]())
            
            for _ in 0 ..< numberOfRows {
                cells[column].append(Cell())
            }
        }
        
        let numberOfСells: Int = numberOfColumns * numberOfRows
        let numberOfOrcas: Int = numberOfСells * percentOfOrcas / 100
        let numberOfTuxes: Int = numberOfСells * percentOfTuxes / 100
        
        // orcas
        for _ in 0 ..< numberOfOrcas {
            population.append(Orca())
        }
        
        // tuxes
        for _ in 0 ..< numberOfTuxes {
            population.append(Tux())
        }
        
        // for shuffle
        var cellOneDimension: [Cell] = [Cell]()
        
        for column in 0 ..< numberOfColumns {
            for row in 0 ..< numberOfRows {
                cellOneDimension.append(cells[column][row])
            }
        }
        
        cellOneDimension = cellOneDimension.sorted(by: { (_,_) in arc4random() < arc4random() })
        
        // set animals
        for i in 0 ..< population.count {
            cellOneDimension[i].animal = population[i]
            
            population[i].cell = cellOneDimension[i]
        }
        
        // set areas
        for column in 0 ..< numberOfColumns {
            for row in 0 ..< numberOfRows {
                for x in -1 ... 1 {
                    for y in -1 ... 1 {
                        let i: Int = (numberOfColumns + column + x) % numberOfColumns
                        let j: Int = (numberOfRows + row + y) % numberOfRows
                        
                        cells[column][row].area.append(cells[i][j])
                    }
                }
            }
        }
        
    }
    
    func live() {
        // shuffle
        population = population.sorted(by: { (_,_) in arc4random() < arc4random() })
        
        var babies: [Animal] = [Animal]()
        
        for animal in population {
            if let baby: Animal = animal.live() {
                babies.append(baby)
            }
        }
        
        // remove corpses
        population = population.filter( { $0.cell != nil } )
        
        // add babies
        for baby in babies {
            population.append(baby)
        }
        
        step += 1
    }
    
}
