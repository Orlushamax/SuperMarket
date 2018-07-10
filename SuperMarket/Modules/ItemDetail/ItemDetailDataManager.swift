//
//  ItemDetailDataManager.swift
//  SuperMarket
//
//  Created by Орлов Максим on 14.06.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//

import Foundation
import CoreData

protocol ItemDatamanagerType: class {
    func getItem(itemId: Int)
}

class ItemDataManager {
    weak var presenter: ItemDetailPresenterDatamanagerViewType!
    
    let mainContext = CoreDataStack.sharedInstance.mainContext
    let bgContext = CoreDataStack.sharedInstance.bgContext
    let customerId = UserDefaults.standard.integer(forKey: "CustomerId")
    let customerName = UserDefaults.standard.string(forKey: "CustomerName")
    init(presenter: ItemDetailPresenterDatamanagerViewType) {
        self.presenter = presenter
    }
}

extension ItemDataManager: ItemDatamanagerType {
    func getItem(itemId: Int) { //MARK: Получаем item из coredata
        let resource = CoreDataResource<ItemMO>(entity: .item, predicate: NSPredicate(format: "id = %@",  String(itemId)), sortDescriptors: nil)
        if let itemMO = CoreDataStack.sharedInstance.fetchEntity(entity: resource, context: mainContext) {
            let item = Item(mo: itemMO)
            presenter.itemGetted(item: item!)
        }
    }
}
