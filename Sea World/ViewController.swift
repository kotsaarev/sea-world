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
    @IBOutlet weak var totalLabel: NSTextField!
    
    fileprivate let numberOfColumns: Int = 10
    fileprivate let numberOfRows: Int = 15
    
    fileprivate let percentOfOrcas: Int = 5
    fileprivate let percentOfTuxes: Int = 50
    
    fileprivate let minCellHeight: CGFloat = max(#imageLiteral(resourceName: "tux").size.height, #imageLiteral(resourceName: "orca").size.height)
    fileprivate let minCellWidth: CGFloat = max(#imageLiteral(resourceName: "tux").size.width, #imageLiteral(resourceName: "orca").size.width)
    
    fileprivate var step = 0
    
    fileprivate var population: [[Individuum?]] = [[]]
    
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
    
}

// MARK: - SetUp
extension ViewController {
    
    fileprivate func setUpTable() {
        assert((numberOfColumns >= 3) && (numberOfRows >= 3), "table too small \"\(numberOfColumns)x\(numberOfRows)\", must be >= \"3x3\"")
        
        for tableColimn in tableView.tableColumns {
            tableView.removeTableColumn(tableColimn)
        }
        
        for i in 0 ..< numberOfColumns {
            let tableColumn: NSTableColumn = NSTableColumn(identifier: "\(i)")
            
            tableColumn.minWidth = minCellWidth
            
            tableView.addTableColumn(tableColumn)
        }
        
        tableView.sizeToFit()
    }
    
    fileprivate func setUpWorld() {
        assert((percentOfOrcas + percentOfTuxes) <= 100, "wrong total ratio")
        
        let numberOfСells: Int = numberOfColumns * numberOfRows
        let numberOfOrcas: Int = numberOfСells * percentOfOrcas / 100
        let numberOfTuxes: Int = numberOfСells * percentOfTuxes / 100
        let numberOfEmpty: Int = numberOfСells - numberOfOrcas - numberOfTuxes
        
        var total: [Individuum?] = []
        let orcas: [Individuum?] = [Orca](repeating: Orca(), count: numberOfOrcas)
        let tuxes: [Individuum?] = [Tux](repeating: Tux(), count: numberOfTuxes)
        let empty: [Individuum?] = [Individuum?](repeating: nil, count: numberOfEmpty)
        
        step = 0
        
        total.append(contentsOf: orcas)
        total.append(contentsOf: tuxes)
        total.append(contentsOf: empty)
        
        total = total.sorted(by: { (_,_) in arc4random() < arc4random() })
        
        population = [[Individuum?]](repeating: [Individuum?](repeating: nil, count: numberOfColumns), count: numberOfRows)
        
        for i in 0 ..< numberOfRows {
            for j in 0 ..< numberOfColumns {
                let index: Int = i * numberOfColumns + j
                
                population[i][j] = total[index]
            }
        }
        
        updateLables()
    }
    
    fileprivate func updateWorld() {
        step += 1
        
        updateLables()
    }
    
}

// MARK: - Support
extension ViewController {
    
    fileprivate func updateLables() {
        let numberOfСells: Int = numberOfColumns * numberOfRows
        let numberOfOrcas: Int = numberOfСells * percentOfOrcas / 100
        let numberOfTuxes: Int = numberOfСells * percentOfTuxes / 100
        
        stepLabel.stringValue = "Step: \(step)"
        
        orcasLabel.stringValue = "Orcas: \(numberOfOrcas) (\(percentOfOrcas)%)"
        tuxesLabel.stringValue = "Tuxes: \(numberOfTuxes) (\(percentOfTuxes)%)"
        totalLabel.stringValue = "Total: \(numberOfOrcas + numberOfTuxes) (\(percentOfOrcas + percentOfTuxes)%)"
    }
    
}

// MARK: - Notifications
extension ViewController {
    
    func windowDidResize() {
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current().duration = 0
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
        guard
            let cell = tableView.make(withIdentifier: "cellView", owner: nil) as? NSTableCellView,
            let tableColumn = tableColumn,
            let column = Int(tableColumn.identifier) else
        {
            return nil
        }
        
        let index: Int = row * numberOfColumns + column
        
        if let individuum = population[row][column] {
            cell.imageView?.image = individuum.image
            cell.toolTip = individuum.name
        } else {
            cell.imageView?.image = nil
            cell.toolTip = nil
        }
        
//        print("i = \(column)")
//        print("j = \(row)")
        print("k = \(index)")
//        print("")
        
        return cell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        if let scrollView = tableView.enclosingScrollView {
            let height: CGFloat = scrollView.bounds.size.height / CGFloat(numberOfRows(in: tableView))
            
            return height >= minCellHeight ? height : minCellHeight
        }
        
        return minCellHeight
    }
    
}
