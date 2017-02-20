//
//  ViewController.swift
//  Sea World
//
//  Created by User on 2/11/17.
//  Copyright © 2017 SeaWorld. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet weak var stepLabel: NSTextField!
    @IBOutlet weak var orcasLabel: NSTextField!
    @IBOutlet weak var tuxesLabel: NSTextField!
    @IBOutlet weak var animalsLabel: NSTextField!
    
    fileprivate var world: World!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.action = #selector(tapOnTableView(_:))
        tableView.target = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setUpTable()
        setUpWorld()
        
        NotificationCenter.default.addObserver(self, selector: #selector(windowDidResize), name: .NSWindowDidResize, object: nil)
    }
    
    // MARK: - IBAction
    @IBAction func restart(_ sender: Any) {
        setUpWorld()
    }
    
    @IBAction func tapOnTableView(_ sender: Any) {
        updateWorld()
    }
    
    // MARK: - SetUp
    private func setUpTable() {
        for tableColimn in tableView.tableColumns {
            tableView.removeTableColumn(tableColimn)
        }
        
        for _ in 0 ..< Constants.numberOfColumns {
            let tableColumn: NSTableColumn = NSTableColumn()
            
            tableColumn.minWidth = Constants.minCellWidth
            
            tableView.addTableColumn(tableColumn)
        }
        
        tableView.sizeToFit()
    }
    
    private func setUpWorld() {
        world = World()
        
        tableView.reloadData()
        
        updateLables()
    }
    
    // MARK: - Life cycle
    private func updateWorld() {
        world.live()
        
        tableView.reloadData()
        
        updateLables()
    }
    
    // MARK: - Support
    private func updateLables() {
        let numberOfCells: Int = Constants.numberOfColumns * Constants.numberOfRows
        
        let numberOfOrcas: Int = world.population.filter( { $0 is Orca } ).count
        let numberOfTuxes: Int = world.population.filter( { $0 is Tux } ).count
        let numberOfAnimals: Int = numberOfOrcas + numberOfTuxes
        
        let percentOfOrcas: Double = Double(numberOfOrcas) * 100 / Double(numberOfCells)
        let percentOfTuxes: Double = Double(numberOfTuxes) * 100 / Double(numberOfCells)
        let percentOfAnimals: Double = percentOfOrcas + percentOfTuxes
        
        stepLabel.stringValue = "Day: \(world.step)"
        
        orcasLabel.stringValue = "Orcas: \(numberOfOrcas) (\(percentOfOrcas)%)"
        tuxesLabel.stringValue = "Tuxes: \(numberOfTuxes) (\(percentOfTuxes)%)"
        animalsLabel.stringValue = "Animals: \(numberOfAnimals) (\(percentOfAnimals)%)"
    }
    
    // MARK: - Notifications
    func windowDidResize() {
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current().duration = 0
        tableView.noteHeightOfRows(withIndexesChanged: IndexSet(integersIn: 0..<Constants.numberOfRows))
        NSAnimationContext.endGrouping()
    }
    
}

// MARK: - NSTableViewDataSource
extension ViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return Constants.numberOfRows
    }
    
}

// MARK: - NSTableViewDelegate
extension ViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard
            let cell = tableView.make(withIdentifier: "cellView", owner: nil) as? NSTableCellView,
            let tableColumn = tableColumn,
            let column = tableView.tableColumns.index(of: tableColumn) else
        {
            return nil
        }
        
        if let animal: Animal = world.cells[column][row].animal {
            cell.imageView?.image = animal.image
            cell.toolTip = animal.name
            
            cell.wantsLayer = true
            cell.layer?.backgroundColor = animal.color.cgColor
        } else {
            cell.imageView?.image = nil
            cell.toolTip = nil
            
            cell.wantsLayer = true
            cell.layer?.backgroundColor = nil
        }
        
        return cell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let minCellHeight: CGFloat = max(#imageLiteral(resourceName: "tux").size.height, #imageLiteral(resourceName: "orca").size.height)
        
        if let scrollView = tableView.enclosingScrollView {
            let height: CGFloat = scrollView.bounds.size.height / CGFloat(Constants.numberOfRows)
            
            return height >= minCellHeight ? height : minCellHeight
        }
        
        return minCellHeight
    }
    
}
