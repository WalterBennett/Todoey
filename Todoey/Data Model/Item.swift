//
//  Item.swift
//  Todoey
//
//  Created by Walter Bennett on 3/28/19.
//  Copyright © 2019 Walter Bennett. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    // Specify INVERSE relationship to link each item back to a PARENT category
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
