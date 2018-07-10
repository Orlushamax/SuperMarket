//
//  OrderLineMO+CoreDataClass.swift
//  SuperMarket
//
//  Created by Орлов Максим on 13.06.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//
//

import Foundation
import CoreData


public class OrderLineMO: NSManagedObject {

}

extension OrderLineMO {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrderLineMO> {
        return NSFetchRequest<OrderLineMO>(entityName: "OrderLine")
    }
    
    @NSManaged public var itemId: Int16
    @NSManaged public var customerId: Int16
    @NSManaged public var qty: Int16
    @NSManaged public var orderLineId: Int16
    @NSManaged public var itemPrice: Int16
    @NSManaged public var itemName: String?}

extension OrderLineMO {
    
    func fillFrom(orderLine: OrderLine) {
        self.orderLineId = Int16(orderLine.orderLineId)
        self.qty = Int16(orderLine.qty)
        self.itemId = Int16(orderLine.itemId)
        self.customerId = Int16(orderLine.customerId)
        self.itemPrice = Int16(orderLine.itemPrice)
        self.itemName = orderLine.itemName
    }
    
    static func insert(orderLine: OrderLine, context: NSManagedObjectContext) -> OrderLineMO {
        let resource = CoreDataResource<OrderLineMO>(entity: .orderLine, predicate: NSPredicate(format: "orderLineId = %@ AND customerId = %@", String(orderLine.orderLineId), String(orderLine.customerId)), sortDescriptors: nil)
        if let orderLineMO = CoreDataStack.sharedInstance.fetchEntity(entity: resource, context: context) {
            orderLineMO.fillFrom(orderLine: orderLine)
            return orderLineMO
        } else {
            let entityDescription = NSEntityDescription.entity(forEntityName: EntityName.orderLine.rawValue, in: context)
            let orderLineMO = OrderLineMO(entity: entityDescription!, insertInto: context)
            orderLineMO.fillFrom(orderLine: orderLine)
            return orderLineMO
        }
    }
}
