//
//  OrderLine.swift
//  SuperMarket
//
//  Created by Орлов Максим on 13.06.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//

import Foundation

struct OrderLine {
    
    var orderLineId: Int
    var itemId: Int
    var qty: Int
    var customerId: Int
    var itemPrice: Int
    var itemName: String
    
    init(orderLineId: Int, itemId: Int, itemName: String, itemPrice: Int, qty: Int, customerId: Int) {
        self.qty = qty
        self.orderLineId = orderLineId
        self.itemId = itemId
        self.customerId = customerId
        self.itemName = itemName
        self.itemPrice = itemPrice
    }
    
    init?(mo: OrderLineMO) {
        self.qty = Int(mo.qty)
        self.orderLineId = Int(mo.orderLineId)
        self.itemId = Int(mo.itemId)
        self.customerId = Int(mo.customerId)
        self.itemName = mo.itemName ?? ""
        self.itemPrice = Int(mo.itemPrice)
    }
}
