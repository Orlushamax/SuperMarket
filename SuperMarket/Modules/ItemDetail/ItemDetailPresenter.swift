//
//  ItemDetailPresenter.swift
//  SuperMarket
//
//  Created by Орлов Максим on 14.06.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//
import Foundation

protocol ItemDetailPresenterDatamanagerViewType: class {
    func itemGetted(item: Item)
}

protocol ItemDetailPresenterViewType {
    func getItem(itemId: Int)
}

class ItemDetailPresenter {
    weak var view: ItemDetailViewType?
    var dataManager: ItemDataManager?
    
    init(view: ItemDetailViewType) {
        self.view = view
        dataManager = ItemDataManager(presenter: self)
    }
    
    func getItem(itemId: Int) {
        dataManager?.getItem(itemId: itemId)
    }
}

extension ItemDetailPresenter: ItemDetailPresenterDatamanagerViewType {
    func itemGetted(item: Item) {
        DispatchQueue.main.async {
            self.view?.showItemDetail(item: item)
        }
    }
}
