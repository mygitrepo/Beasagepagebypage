//
//  ScripturePages.swift
//  baspbp-final
//
//  Created by nikul on 2/2/17.
//  Copyright © 2017 isv. All rights reserved.
//

import UIKit

class ScripturePages: NSObject, NSCoding {
    
    init(name: String, pagesread: Int, totalpages: Int, slokasread: Int, totalslokas: Int) {
        super.init()
        self.name = name
        self.pagesread = pagesread
        self.totalpages = totalpages
        self.slokasread = slokasread
        self.totalslokas = totalslokas
    }
    
    var uuid: String = NSUUID().uuidString
    var name: String = ""
    var pagesread: Int = 0
    var totalpages: Int = 0
    var slokasread: Int = 0
    var totalslokas: Int = 0
    var inScripturePagesList = false
    
    func encode(with coder: NSCoder) {
        coder.encode(uuid, forKey: "uuid")
        coder.encode(name, forKey: "name")
        coder.encode(pagesread, forKey: "pagesread")
        coder.encode(totalpages, forKey: "totalpages")
        coder.encode(slokasread, forKey: "slokasread")
        coder.encode(totalslokas, forKey: "totalslokas")
        coder.encode(inScripturePagesList, forKey: "inScripturePagesList")
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
        
        if let archivedPagesRead = decoder.decodeObject(forKey: "pagesread") as? Int {
            pagesread = archivedPagesRead
        }
        
        if let archivedTotalPages = decoder.decodeObject(forKey: "totalpages") as? Int {
            totalpages = archivedTotalPages
        }
        
        if let archivedSlokasRead = decoder.decodeObject(forKey: "slokasread") as? Int {
            slokasread = archivedSlokasRead
        }
        
        if let archivedTotalSlokas = decoder.decodeObject(forKey: "totalslokas") as? Int {
            totalslokas = archivedTotalSlokas
        }
        
        inScripturePagesList = decoder.decodeBool(forKey: "inScripturePagesList")
    }
}

