//
//  CoreDataResource.swift
//  SuperMarket
//
//  Created by Орлов Максим on 13.06.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//

import Foundation
import CoreData

enum EntityName: String {
    case orderLine = "OrderLine"
    case item = "Item"
    case customer = "Customer"
}

struct CoreDataResource<T: NSManagedObject> {
    let entityName: String
    let fetchRequest: NSFetchRequest<T>
    
    init(entity: EntityName, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) {
        self.entityName = entity.rawValue
        self.fetchRequest = NSFetchRequest(entityName: entityName)
        self.fetchRequest.returnsObjectsAsFaults = false
        
        self.fetchRequest.predicate = predicate
        self.fetchRequest.sortDescriptors = sortDescriptors
    }
    
    init(entity: EntityName) {
        self.init(entity: entity, predicate: nil, sortDescriptors: nil)
    }
}
