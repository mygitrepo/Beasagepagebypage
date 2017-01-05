//
//  Item.swift
//  baspbp-final
//
//  Created by nikul on 12/30/16.
//  Copyright © 2016 isv. All rights reserved.
//

import UIKit

class Item: NSObject, NSCoding {
    
    //var items = [Item]()
    
    init(name: String) {
        super.init()
        self.name = name
    }
    
    var uuid: String = NSUUID().uuidString
    var name: String = ""
    var inScriptureList = false
    
    func encode(with coder: NSCoder) {
        coder.encode(uuid, forKey: "uuid")
        coder.encode(name, forKey: "name")
        coder.encode(inScriptureList, forKey: "inScriptureList")
    }
    
    // MARK: -
    // MARK: Initialization
    required init?(coder decoder: NSCoder) {
        super.init()
        
        // Load Items
        // loadItems()
        
        if let archivedUuid = decoder.decodeObject(forKey: "uuid") as? String {
            uuid = archivedUuid
        }
        
        if let archivedName = decoder.decodeObject(forKey: "name") as? String {
            name = archivedName
        }
        
        inScriptureList = decoder.decodeBool(forKey: "inScriptureList")
    }
}
