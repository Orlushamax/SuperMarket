//
//  ProfileDataManager.swift
//  SuperMarket
//
//  Created by Орлов Максим on 14.06.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//

import Foundation
import CoreData

protocol ProfileDatamanagerType: class {
    func getCustomerInfo()
    func deleteOrderLine(orderLine: OrderLine)
    func changeOrderLineQty(orderLine: OrderLine, qty: Int)
}

class ProfileDataManager {
    weak var presenter: ProfilePresenterDatamanagerViewType!
    
    let mainContext = CoreDataStack.sharedInstance.mainContext
    let bgContext = CoreDataStack.sharedInstance.bgContext
    let customerId = UserDefaults.standard.integer(forKey: "CustomerId")
    let customerName = UserDefaults.standard.string(forKey: "CustomerName")
    init(presenter: ProfilePresenterDatamanagerViewType) {
        self.presenter = presenter
    }
}

extension ProfileDataManager: ProfileDatamanagerType {
    
    func getCustomerInfo() { //MARK: Получаем сущность клиента
        let resource = CoreDataResource<CustomerMO>(entity: .customer, predicate: NSPredicate(format: "id = %@",  String(customerId)), sortDescriptors: nil)
        if let customerMO = CoreDataStack.sharedInstance.fetchEntity(entity: resource, context: mainContext) {
            guard let customer = Customer(mo: customerMO) else { return }
            presenter.customerGetted(customer: customer)
        } else {
            guard let name = customerName else { return }
            let customer = Customer(id: customerId, name: name, orderLineList: nil)
            let _ = CustomerMO.insert(customer: customer, context: mainContext)
            CoreDataStack.sharedInstance.saveContext(context: mainContext)
            presenter.customerGetted(customer: customer)
        }
    }
    
    func deleteOrderLine(orderLine: OrderLine) { //MARK: Находим orderLine, удаляем, сохраняем изменнения и возвращаем новый список
        let resource = CoreDataResource<OrderLineMO>(entity: .orderLine, predicate: NSPredicate(format: "orderLineId = %@ AND customerId = %@",  String(orderLine.orderLineId) ,String(customerId)), sortDescriptors: nil)
        if let orderLineMO = CoreDataStack.sharedInstance.fetchEntity(entity: resource, context: bgContext) {
            CoreDataStack.sharedInstance.removeComparable(entity: orderLineMO, context: bgContext)
            CoreDataStack.sharedInstance.saveContext(context: bgContext)
        }
    }
    
    func changeOrderLineQty(orderLine: OrderLine, qty: Int) { //MARK: Изменяем количество айтемов в orderLine
         let resource = CoreDataResource<OrderLineMO>(entity: .orderLine, predicate: NSPredicate(format: "orderLineId = %@ AND customerId = %@",  String(orderLine.orderLineId) ,String(customerId)), sortDescriptors: nil)
        if let orderLineMO = CoreDataStack.sharedInstance.fetchEntity(entity: resource, context: bgContext) {
            orderLineMO.qty = Int16(qty)
            CoreDataStack.sharedInstance.saveContext(context: bgContext)
            getCustomerInfo()
        }
    }
}
