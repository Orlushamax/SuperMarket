//
//  ItemListPresenter.swift
//  SuperMarket
//
//  Created by Орлов Максим on 13.06.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//

import Foundation

protocol ItemListPresenterViewType {
    func getItemList()
    func addToCustomerItems(item: Item, qty: Int)
    func showQtyAlert(item: Item)
    func checkIfLauchedBefore() -> Bool
}

protocol ItemListPresenterDataManagerType: class {
    func itemListGetted(itemList: [Item])
}

class ItemListPresenter {
    weak var view: ItemListViewType?
    var orderId = 0
    var dataManager: ItemListDataManager?
    
    init(view: ItemListViewType) {
        self.view = view
        dataManager = ItemListDataManager(presenter: self)
    }
    
    func getItemList() {
        dataManager?.getItemsLocally()
    }
    
    func addToCustomerItems(item: Item, qty: Int) {
        self.dataManager?.addToCustomerItems(item: item, qty: qty)
    }
    
    func showQtyAlert(item: Item) { 
        view?.showQtyAlert(item: item)
    }
    
    func checkIfLauchedBefore() -> Bool { //MARK: Проверяем если прилоение запущено первый раз - показываем анимацию кнопок
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            return true
        } else {
            return false
        }
    }
}

extension ItemListPresenter: ItemListPresenterDataManagerType {
    func itemListGetted(itemList: [Item]) {
        DispatchQueue.main.async {
            self.view?.showItemList(itemList: itemList)
        }
    }
}
