//
//  ViewController.swift
//  Checklists
//
//  Created by Tuyetanh Vu on 12/30/17.
//  Copyright © 2017 Tuyetanh Vu. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
	var items: [ChecklistItem]  // Data source for table

    func itemDetailViewControllerDidCancel(_ controller: ItemDetailV) {
        navigationController?.popViewController(animated: true)
    }
	
	func saveChecklistItemsToUserStorage() {
		let userDefaults = UserDefaults.standard // get a connection object to store data by a key name
		let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: items) // loads items from user default object with lookup name
		userDefaults.set(encodedData, forKey: "checklistArchive") // Save the archive from the prepared variable
		userDefaults.synchronize()
		
		print("SAVED CHECKLIST")
	}
	
	func loadChecklistItemsFromUserStorage() {
		 items = [ChecklistItem]()
		let userDefaults = UserDefaults.standard // get a connection object to load data by a key name
		
		// check and guard against using the archive. If nothing is there for the key name checklistArchive the return
		guard userDefaults.object(forKey: "checklistArchive") != nil else {
			return
		}
		
		let decoded  = userDefaults.object(forKey: "checklistArchive") as! Data // gets items from user default object by lookup name
		items = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [ChecklistItem] // load the archive to our local variable
		
		print("LOADED CHECKLIST")

	}
    
    func itemDetailViewController(_controller: ItemDetailV, didFinishEditing item: ChecklistItem) {
        if let index = items.index(of: item) {
            let indexPath = IndexPath(row: index, section:0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
		saveChecklistItemsToUserStorage() // saves after user edits
    }
    
    func itemDetailViewController(_controller: ItemDetailV, didFinishAdding item: ChecklistItem) {
        
        let newRowIndex = items.count
        items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        //let indexPaths = [indexPath]
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        navigationController?.popViewController(animated: true)
		saveChecklistItemsToUserStorage() // saves after user adds
    }
    

    @IBAction func addItem(_ sender: Any) {
        let newRowIndex = items.count
        
        let item = ChecklistItem(text: "", checked: false) // add an empty item
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
		
		/*
		// add some items for testing
		// commented out so the table doesnt have anything in it when it loads
		
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
		
		*/
        super .init(coder: aDecoder)

		loadChecklistItemsFromUserStorage() // load what the user stored before in UserDefaults
		
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemDetailV
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as!ItemDetailV
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
            controller.itemToEdit = items[indexPath.row]
            
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.navigationBar.prefersLargeTitles = true

		loadChecklistItemsFromUserStorage() // loads what user stored in UserDefaults on app launch
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
        
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }

}

