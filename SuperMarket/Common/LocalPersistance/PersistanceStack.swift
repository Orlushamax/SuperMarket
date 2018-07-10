//
//  PersistanceStack.swift
//  SuperMarket
//
//  Created by Орлов Максим on 13.06.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//

import Foundation
import CoreData

protocol PersistantStack {
    func fetchEntity<T>(entity: CoreDataResource<T>, context: NSManagedObjectContext) -> T?
    func fetchEntities<T>(entity: CoreDataResource<T>, context: NSManagedObjectContext) -> [T]?
}

