//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Tuyetanh Vu on 1/8/18.
//  Copyright © 2018 Tuyetanh Vu. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject,NSCoding { // nscoding and the required functions below needs to be added to store this custom class to UserDefaults
    
    var text = ""
    var checked = false
    
    func toggleChecked(){
        checked = !checked
    }

	// used to load from UserDefaults.. required by NSCoding
	init(text: String, checked: Bool) {
		self.text = text
		self.checked = checked
	}
	// used to load from UserDefaults.. required by NSCoding
	required convenience init(coder aDecoder: NSCoder) {
		let text = aDecoder.decodeObject(forKey: "text") as? String
		let checked = aDecoder.decodeBool(forKey: "checked")
		self.init(text: text!, checked: checked)
	}
	
	// used to save to UserDefaults.. required by NSCoding
	func encode(with aCoder: NSCoder) {
		aCoder.encode(text, forKey: "text")
		aCoder.encode(checked, forKey: "checked")
	}
}
