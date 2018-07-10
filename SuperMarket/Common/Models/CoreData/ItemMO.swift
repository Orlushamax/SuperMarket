//
//  ItemMO+CoreDataClass.swift
//  SuperMarket
//
//  Created by Орлов Максим on 13.06.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//
//

import Foundation
import CoreData


public class ItemMO: NSManagedObject {

}

extension ItemMO {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemMO> {
        return NSFetchRequest<ItemMO>(entityName: "Item")
    }
    
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var price: Int16
    @NSManaged public var itemDescription: String?
}

extension ItemMO {
    
    func fillFrom(item: Item) {
        self.id = Int16(item.id)
        self.name = item.name
        self.price = Int16(item.price)
        self.itemDescription = item.itemDescription
    }
    
    static func insert(item: Item, context: NSManagedObjectContext) -> ItemMO? {
        let resourse = CoreDataResource<ItemMO>(entity: .item, predicate: NSPredicate(format: "id = %@", String(item.id)), sortDescriptors: nil)
        if let itemMO = CoreDataStack.sharedInstance.fetchEntity(entity: resourse, context: context) {
            itemMO.fillFrom(item: item)
            return itemMO
        } else {
            let entityDescription = NSEntityDescription.entity(forEntityName: EntityName.item.rawValue, in: context)
            let itemMO = ItemMO(entity: entityDescription!, insertInto: context)
            itemMO.fillFrom(item: item)
            return itemMO
        }
    }
}
