//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Tuyetanh Vu on 1/8/18.
//  Copyright © 2018 Tuyetanh Vu. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject {
    
    var text = ""
    var checked = false
    
    func toggleChecked(){
        checked = !checked
    }
    
    
}
