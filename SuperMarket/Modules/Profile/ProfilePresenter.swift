//
//  ProfilePresenter.swift
//  SuperMarket
//
//  Created by Орлов Максим on 14.06.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//

import Foundation

protocol ProfilePresenterDatamanagerViewType: class {
    func customerGetted(customer: Customer)
}

protocol ProfilePresenterViewType {
    func getCustomerInfo()
    func showChangeQtyAlert(orederLine: OrderLine, indexPath: IndexPath)
    func deleteOrderLine(orderLine: OrderLine)
    func changeOrderLineQty(orderLine: OrderLine, qty: Int)
    func updateTotalPrice(orderLineList: [OrderLine])
}

class ProfilePresenter {
    weak var view: ProfileViewType?
    var dataManager: ProfileDataManager?
    
    init(view: ProfileViewType) {
        self.view = view
        dataManager = ProfileDataManager(presenter: self)
    }
    
    func getCustomerInfo() {
        dataManager?.getCustomerInfo()
    }
    
    func showChangeQtyAlert(orederLine: OrderLine, indexPath: IndexPath){ //MARK: Показываем алерт для изменения количества
        view?.showChageQtyAlert(orderLine: orederLine, indexPath: indexPath)
    }
    
    func deleteOrderLine(orderLine: OrderLine) {
        dataManager?.deleteOrderLine(orderLine: orderLine)
    }
    
    func changeOrderLineQty(orderLine: OrderLine, qty: Int) {
        dataManager?.changeOrderLineQty(orderLine: orderLine, qty: qty)
    }
    
    func updateTotalPrice(orderLineList: [OrderLine]) { //MARK: Обновляем общую стоимость
        let orderSum = orderLineList.map({return $0.itemPrice * $0.qty}).reduce(0, +)
        self.view?.updateFooterView(orderSum: orderSum)
    }
}

extension ProfilePresenter: ProfilePresenterDatamanagerViewType {
    
    func customerGetted(customer: Customer) {
        DispatchQueue.main.async {
            guard let orderLineList = customer.orderLineList else { return }
            let sorteredOrderLineList = orderLineList.sorted(by: { $0.orderLineId < $1.orderLineId })
            for line in sorteredOrderLineList {
                print(line.orderLineId)
            }
            let orderSum = orderLineList.map({return $0.itemPrice * $0.qty}).reduce(0, +)
            self.view?.showCustomer(customer: customer, orderLineList: sorteredOrderLineList, orderSum: orderSum)
        }
    }
}

