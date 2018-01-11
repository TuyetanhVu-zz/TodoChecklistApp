//
//  ViewController.swift
//  Checklists
//
//  Created by Tuyetanh Vu on 12/30/17.
//  Copyright © 2017 Tuyetanh Vu. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var items: [ChecklistItem]

    @IBAction func addItem(_ sender: Any) {
        let newRowIndex = items.count
        
        let item = ChecklistItem()
        //item.text = "I am a new row"
        var titles = ["Empty todo item", "Generic todo item", "First todo: fill me out", "I need something todo",
                      "Much todo about nothing"]
        let randomNumber = arc4random_uniform(UInt32(titles.count))
        let title = titles[Int(randomNumber)]
        item.text = title
        
        item.checked = true
        
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        items = [ChecklistItem]()
        
        let row0Item = ChecklistItem()
        row0Item.text  = "Walk the dog"
        row0Item.checked = false
        items.append(row0Item)
        
        let row1Item = ChecklistItem()
        row1Item.text  = "Brush my teeth"
        row1Item.checked = false
        items.append(row1Item)

        let row2Item = ChecklistItem()
        row2Item.text  = "Learn iOS development"
        row2Item.checked = false
        items.append(row2Item)

        let row3Item = ChecklistItem()
        row3Item.text  = "Soccer practice"
        row3Item.checked = false
        items.append(row3Item)

        let row4Item = ChecklistItem()
        row4Item.text  = "Eat ice cream"
        row4Item.checked = false
        items.append(row4Item)
        
        let row5Item = ChecklistItem()
        row5Item.text  = "Watch Game of Thrones"
        row5Item.checked = true
        items.append(row5Item)
        
        let row6Item = ChecklistItem()
        row6Item.text  = "Read iOS Apprentice"
        row6Item.checked = true
        items.append(row6Item)
        
        let row7Item = ChecklistItem()
        row7Item.text  = "Make coffe"
        row7Item.checked = false
        items.append(row7Item)

        super .init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        items.remove(at: indexPath.row)
        //let indexPaths = [indexPath]
        //tableView.deleteRows(at: indexPaths, with: .automatic)
        
        tableView.reloadData()
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            
            let item = items[indexPath.row]
            item.toggleChecked()
            
            configureCheckmark(for: cell, with: item)
        }
            tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        let item = items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
         let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        
        if item.checked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    

    

}

