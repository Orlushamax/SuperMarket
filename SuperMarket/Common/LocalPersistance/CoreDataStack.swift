//
//  CoreDataStack.swift
//  SuperMarket
//
//  Created by Орлов Максим on 13.06.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//

import Foundation
import CoreData


final class CoreDataStack: NSObject {
    
    static let sharedInstance = CoreDataStack()
    
    //MARK: CoreDataStack
    lazy var persistanceContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved Error - \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelUrl = Bundle.main.url(forResource: "Model", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelUrl)!
    }()
    
    lazy var peristentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let applicationDocumentsDirectory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        let persistentStoreUrl: URL = applicationDocumentsDirectory.appendingPathComponent("Model.sqlite")
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreUrl, options: nil)
        }
        catch {
            fatalError("Persistent store error! \(error)")
        }
        
        return coordinator
    }()
    
    
    lazy var mainContext: NSManagedObjectContext = { //MARK: Главный контекст
        let mainContext: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.persistentStoreCoordinator = self.peristentStoreCoordinator
        
        return mainContext
    }()
    
    lazy var bgContext: NSManagedObjectContext = { //MARK: Бэкграунд контекст
        let bgContext: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        bgContext.persistentStoreCoordinator = self.peristentStoreCoordinator
        
        return bgContext
    }()
    
    func saveContext(context: NSManagedObjectContext) { //МARK: Сохраняем контекст
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error),\(error.userInfo)")
            }
        }
    }
    
    func removeComparable(entity: NSManagedObject, context: NSManagedObjectContext) { //MARK: Удаляем обьект из кордаты
        context.delete(entity)
        do{
            try context.save()
        } catch {
            print("Не удалось сохранить удаление!")
        }
    }
}

extension CoreDataStack: PersistantStack {
    
    func fetchEntity<T>(entity: CoreDataResource<T>, context: NSManagedObjectContext) -> T?  {//MARK: Загруаем сущность
        do {
            let fetchResult = try context.fetch(entity.fetchRequest).first
            return fetchResult
        } catch {
            print("Failed to fetch entities")
            return nil
        }
    }
    
    //
    func fetchEntities<T>(entity: CoreDataResource<T>, context: NSManagedObjectContext) -> [T]? { //MARK: Метод загрузки нескольких сущностей
        do {
            let result: [T]?  = try context.fetch(entity.fetchRequest)
            return result
        } catch {
            print("Failed to fetch entities")
            return nil
        }
    }
}
