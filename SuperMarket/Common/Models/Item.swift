//
//  Item.swift
//  SuperMarket
//
//  Created by Орлов Максим on 13.06.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//

import Foundation

struct Item {
    var id: Int
    var name: String
    var price: Int
    var itemDescription: String
    
    init(id: Int, name: String, price: Int, itemDescription: String)  {
        self.id = id
        self.name = name
        self.price = price
        self.itemDescription = itemDescription
    }
    
    init?(mo: ItemMO) {
        self.id = Int(mo.id)
        self.name = mo.name ?? ""
        self.price = Int(mo.price)
        self.itemDescription = mo.itemDescription ?? ""
    }
}

