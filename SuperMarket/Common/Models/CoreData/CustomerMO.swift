//
//  CustomerMO+CoreDataClass.swift
//  SuperMarket
//
//  Created by Орлов Максим on 13.06.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//
//

import Foundation
import CoreData


public class CustomerMO: NSManagedObject {

}

extension CustomerMO {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomerMO> {
        return NSFetchRequest<CustomerMO>(entityName: "Customer")
    }
    
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var orderLine: NSSet?
    
}

// MARK: Generated accessors for order
extension CustomerMO {
    
    @objc(addOrderLineObject:)
    @NSManaged public func addToOrderLine(_ value: OrderLineMO)
    
    @objc(removeOrderLineObject:)
    @NSManaged public func removeFromOrderLine(_ value: OrderLineMO)
    
    @objc(addOrderLine:)
    @NSManaged public func addToOrderLine(_ values: NSSet)
    
    @objc(removeOrderLine:)
    @NSManaged public func removeFromOrderLine(_ values: NSSet)

    
}

extension CustomerMO {
    
    func fillFrom(customer: Customer) {
        self.id = Int16(customer.id)
        self.name = customer.name
    }
    
    static func insert(customer: Customer, context: NSManagedObjectContext) -> CustomerMO {
        let resource = CoreDataResource<CustomerMO>(entity: .customer, predicate: NSPredicate(format: "id = %@", String(customer.id)), sortDescriptors: nil)
        if let customerMO = CoreDataStack.sharedInstance.fetchEntity(entity: resource, context: context) {
            customerMO.fillFrom(customer: customer)
            guard let orderLineList = customer.orderLineList else { return customerMO }
            for orderLine in orderLineList {
                let orderLineMO = OrderLineMO.insert(orderLine: orderLine, context: context)
                customerMO.addToOrderLine(orderLineMO)
            }
            return customerMO
        } else {
            let entityDescription = NSEntityDescription.entity(forEntityName: EntityName.customer.rawValue, in: context)
            let customerMO = CustomerMO(entity: entityDescription!, insertInto: context)
            customerMO.fillFrom(customer: customer)
            guard let orderLineList = customer.orderLineList else { return customerMO }
            for orderLine in orderLineList {
                let orderLineMO = OrderLineMO.insert(orderLine: orderLine, context: context)
                customerMO.addToOrderLine(orderLineMO)
            }
            return customerMO
        }
    }
}
