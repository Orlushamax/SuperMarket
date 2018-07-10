//
//  ItemDetailVC.swift
//  SuperMarket
//
//  Created by Орлов Максим on 14.06.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//

import UIKit

protocol ItemDetailViewType: class {
    func showItemDetail(item: Item)
}

class ItemDetailVC: UIViewController {

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var itemPriceButton: UIButton!
    
    private var orderLineList = [OrderLine]()
    private var presenter: ItemDetailPresenter?
    var itemId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemPriceButton.backgroundColor = .clear
        itemPriceButton.layer.cornerRadius = 10
        itemPriceButton.layer.borderWidth = 1
        itemPriceButton.layer.borderColor = UIColor.black.cgColor
        itemPriceButton.backgroundColor = barTintColor
        itemPriceButton.isEnabled = false
        itemPriceButton.alpha = 0
        itemDescriptionLabel.sizeToFit()
        presenter = ItemDetailPresenter(view: self)
        if let presenter = self.presenter {
            presenter.getItem(itemId: itemId)
        }
    }
}

extension ItemDetailVC: ItemDetailViewType {
    
    func showItemDetail(item: Item) {
        itemNameLabel.text = item.name
        itemDescriptionLabel.text = item.itemDescription
        let buttonTitle = String(item.price) + " " + "руб."
        itemPriceButton.setTitle(buttonTitle, for: .normal)
        itemPriceButton.animate(button: itemPriceButton)
        self.reloadInputViews()
    }
}

