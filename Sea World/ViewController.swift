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
    
    @IBOutlet weak var numberOfColumnsField: NSTextField!
    @IBOutlet weak var numberOfRowsField: NSTextField!
    
    fileprivate var numberOfColumns: Int = Constants.numberOfColumns
    fileprivate var numberOfRows: Int = Constants.numberOfRows
    
    fileprivate var world: World!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.action = #selector(tapOnTableView(_:))
        tableView.target = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        numberOfColumnsField.integerValue = numberOfColumns
        numberOfRowsField.integerValue = numberOfRows
        
        setUpWorld()
        setUpTable()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        NotificationCenter.default.addObserver(self, selector: #selector(windowDidResize), name: NSWindow.didResizeNotification, object: nil)
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        
        NotificationCenter.default.removeObserver(self, name: NSWindow.didResizeNotification, object: nil)
    }
    
    // MARK: - IBAction
    @IBAction func restart(_ sender: Any) {
        if numberOfColumnsField.integerValue >= Constants.areaDimension {
            numberOfColumns = numberOfColumnsField.integerValue
        } else {
            numberOfColumnsField.integerValue = numberOfColumns
        }
        
        if numberOfRowsField.integerValue >= Constants.areaDimension {
            numberOfRows = numberOfRowsField.integerValue
        } else {
            numberOfRowsField.integerValue = numberOfRows
        }
        
        setUpWorld()
        setUpTable()
        updateLables()
    }
    
    @IBAction func tapOnTableView(_ sender: Any) {
        updateWorld()
    }
    
    // MARK: - SetUp
    private func setUpTable() {
        for tableColimn in tableView.tableColumns {
            tableView.removeTableColumn(tableColimn)
        }
        tableView.reloadData() // apply changes immediately

        for _ in 0 ..< numberOfColumns {
            let tableColumn: NSTableColumn = NSTableColumn()
            
            tableColumn.minWidth = Constants.minCellWidth
            
            tableView.addTableColumn(tableColumn)
        }
        
        tableView.sizeToFit()
    }
    
    private func setUpWorld() {
        world = World(numberOfColumns: numberOfColumns, numberOfRows: numberOfRows)
    }
    
    // MARK: - Life cycle
    private func updateWorld() {
        guard world.live() else {
            return
        }
        
        tableView.reloadData()
        
        updateLables()
    }
    
    // MARK: - Support
    private func updateLables() {
        let numberOfCells: Int = numberOfColumns * numberOfRows
        
        let numberOfOrcas: Int = world.population.filter( { $0 is Orca } ).count
        let numberOfTuxes: Int = world.population.filter( { $0 is Tux } ).count
        let numberOfAnimals: Int = numberOfOrcas + numberOfTuxes
        
        let percentOfOrcas: Double = Double(numberOfOrcas) * 100 / Double(numberOfCells)
        let percentOfTuxes: Double = Double(numberOfTuxes) * 100 / Double(numberOfCells)
        let percentOfAnimals: Double = percentOfOrcas + percentOfTuxes
        
        stepLabel.stringValue = String(world.step)
        
        orcasLabel.stringValue = "\(numberOfOrcas) (\(String(format:"%.0f", percentOfOrcas))%)"
        tuxesLabel.stringValue = "\(numberOfTuxes) (\(String(format:"%.0f", percentOfTuxes))%)"
        animalsLabel.stringValue = "\(numberOfAnimals) (\(String(format:"%.0f", percentOfAnimals))%)"
    }
    
    // MARK: - Notifications
    @objc func windowDidResize() {
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 0
        tableView.noteHeightOfRows(withIndexesChanged: IndexSet(integersIn: 0..<numberOfRows))
        NSAnimationContext.endGrouping()
    }
    
}

// MARK: - NSTableViewDataSource
extension ViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return numberOfRows
    }
    
}

// MARK: - NSTableViewDelegate
extension ViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let identifier = NSUserInterfaceItemIdentifier(rawValue: "cellView")
        guard
            let cell = tableView.makeView(withIdentifier: identifier, owner: nil) as? NSTableCellView,
            let tableColumn = tableColumn,
            let column = tableView.tableColumns.firstIndex(of: tableColumn) else
        {
            return nil
        }
        
        if let animal: Animal = world.cells[column][row].animal {
            cell.imageView?.image = animal.image
            cell.toolTip = animal.name
        } else {
            cell.imageView?.image = nil
            cell.toolTip = nil
        }
        
        return cell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let minCellHeight: CGFloat = max(#imageLiteral(resourceName: "tux").size.height, #imageLiteral(resourceName: "orca").size.height)
        
        if let scrollView = tableView.enclosingScrollView {
            let height: CGFloat = scrollView.bounds.size.height / CGFloat(numberOfRows)
            
            return height >= minCellHeight ? height : minCellHeight
        }
        
        return minCellHeight
    }
    
}
