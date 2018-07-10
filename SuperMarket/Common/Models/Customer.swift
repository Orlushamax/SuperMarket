//
//  Customer.swift
//  SuperMarket
//
//  Created by Орлов Максим on 13.06.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//

import Foundation

struct Customer {
    var id: Int
    var name: String
    var orderLineList: [OrderLine]?
    
    init(id: Int, name: String, orderLineList: [OrderLine]?) {
        self.id = id
        self.name = name
        self.orderLineList = orderLineList
    }
    
    init?(mo: CustomerMO) {
        self.id = Int(mo.id)
        self.name = mo.name ?? ""
        self.orderLineList = Array(mo.orderLine!).compactMap({ return OrderLine(mo: $0 as! OrderLineMO )})
    }
}
