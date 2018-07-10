//
//  ItemListDataManager.swift
//  SuperMarket
//
//  Created by Орлов Максим on 13.06.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//

import Foundation
import CoreData

protocol ItemListDataManagerType: class {
    func getItemsLocally()
    func addToCustomerItems(item: Item, qty: Int)
}

class ItemListDataManager {
    
    let mainContext = CoreDataStack.sharedInstance.mainContext
    let bgContext = CoreDataStack.sharedInstance.bgContext
    let customerId = UserDefaults.standard.integer(forKey: "CustomerId")
    let customerName = UserDefaults.standard.string(forKey: "CustomerName")
    
    private var itemList = [Item]() //MARK: Тестовые данные
    private let item = Item(id: 0, name: "Хлеб", price: 30, itemDescription: "Какое то описание")
    private let item1 = Item(id: 1, name: "Молоко", price: 60, itemDescription: "Какое то описание")
    private let item2 = Item(id: 2, name: "Чай", price: 150, itemDescription: "Какое то описание")
    private let item3 = Item(id: 3, name: "Кофе", price: 350, itemDescription: "Какое то описание")
    private let item4 = Item(id: 4, name: "Сахар", price: 80, itemDescription: "Какое то описание")
    private let item5 = Item(id: 5, name: "Мука", price: 70, itemDescription: "Какое то описание")
    private let item6 = Item(id: 6, name: "Сигареты", price: 120, itemDescription: "Какое то описание")
    private let item7 = Item(id: 7, name: "Конфеты", price: 140, itemDescription: "Какое то описание")
    private let item8 = Item(id: 8, name: "Вода", price: 33, itemDescription: "Какое то описание")
    private let item9 = Item(id: 9, name: "Газировка", price: 55, itemDescription: "Какое то описание")
    
    weak var presenter: ItemListPresenterDataManagerType!
    
    init(presenter: ItemListPresenterDataManagerType) {
        self.presenter = presenter
        itemList.append(item)
        itemList.append(item1)
        itemList.append(item2)
        itemList.append(item3)
        itemList.append(item4)
        itemList.append(item5)
        itemList.append(item6)
        itemList.append(item7)
        itemList.append(item8)
        itemList.append(item9)
        saveItemsLocally(itemList: itemList)
    }

    
    private func saveItemsLocally(itemList: [Item]) { //MARK: Записываем массив items в CoreData
        for item in itemList {
            let _ = ItemMO.insert(item: item, context: bgContext)
        }
        CoreDataStack.sharedInstance.saveContext(context: bgContext)
    }
}

extension ItemListDataManager: ItemListDataManagerType {
    
    func getItemsLocally() { //MARK: Получаем список item из Coredata
        var itemsGetted = [Item]()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let resource = CoreDataResource<ItemMO>(entity: .item, predicate: nil, sortDescriptors: [sortDescriptor])
            guard let itemListMO = CoreDataStack.sharedInstance.fetchEntities(entity: resource, context: self.mainContext) else { return }
            for itemMO in itemListMO {
                itemsGetted.append(Item.init(mo: itemMO)!)
            }
            self.presenter.itemListGetted(itemList: itemsGetted)
    }
    
    func addToCustomerItems(item: Item, qty: Int) { //MARK: Добавляем новый айтем
        let orderLine = createNewOrderLine(withItem: item, qty: qty)
        let resource = CoreDataResource<CustomerMO>(entity: .customer, predicate: nil, sortDescriptors: nil)
        if let customerMO = CoreDataStack.sharedInstance.fetchEntity(entity: resource, context: mainContext) {
            guard var customer = Customer(mo: customerMO) else { return }
            customer.orderLineList?.append(orderLine)
            let _ = CustomerMO.insert(customer: customer, context: bgContext)
        } else {
            guard let name = customerName else { return }
            var customer = Customer(id: customerId, name: name, orderLineList: nil)
            customer.orderLineList?.append(orderLine)
            let _ = CustomerMO.insert(customer: customer, context: bgContext)
        }
        CoreDataStack.sharedInstance.saveContext(context: bgContext)
    }
    
    func createNewOrderLine(withItem item: Item, qty: Int) -> OrderLine { //MARK: Создаем новый orderLine
        let orderLineId = getNewOrderLineId()
        let orderLine = OrderLine(orderLineId: orderLineId, itemId: item.id, itemName: item.name, itemPrice: item.price, qty: qty, customerId: customerId)
        return orderLine
    }
    
    func getNewOrderLineId() -> Int { //MARK: Получаем id следующей orderLine
        var orderId = 0
        let resource = CoreDataResource<OrderLineMO>(entity: .orderLine, predicate: NSPredicate(format: "customerId = %@", String(customerId)), sortDescriptors: nil)
        if let orderListMO = CoreDataStack.sharedInstance.fetchEntities(entity: resource, context: mainContext) {
            if orderListMO.count > 0 {
                guard let lastLine = orderListMO.last?.orderLineId else { return orderId }
                orderId = Int(lastLine) + 1
            } else {
                orderId = orderListMO.count + 1
            }
        }
        return orderId
    }
}



