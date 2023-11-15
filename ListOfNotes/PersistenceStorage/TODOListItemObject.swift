//
//  TODOListItemObject.swift
//  ListOfNotes
//
//  Created by Pavel Shymanski on 15.11.23.
//

import Foundation
import RealmSwift

class TODOListItemObject: Object {
    @Persisted var title: String
    @Persisted var body: String
    @Persisted var lastUpdatedDate: Date
    @Persisted var createdDate: Date
    @Persisted(primaryKey: true) var identifier: String
    
    convenience init(with item: TODOListItem) {
        self.init()
        self.title = item.title
        self.body = item.body
        self.lastUpdatedDate = item.lastUpdatedDate
        self.createdDate = item.createdDate
        self.identifier = String(createdDate.timeIntervalSince1970)
        
    }
    
    var item: TODOListItem {
        TODOListItem(title: title, body: body, lastUpdatedDate: lastUpdatedDate, createdDate: createdDate)
    }
    
}
