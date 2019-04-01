//
//  Category.swift
//  Todoey
//
//  Created by Walter Bennett on 3/28/19.
//  Copyright © 2019 Walter Bennett. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    
    // Create Forward Relationship (One to Many)
    let items = List<Item>()
    
}
