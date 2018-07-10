//
//  ItemListTableViewCell.swift
//  SuperMarket
//
//  Created by Орлов Максим on 13.06.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//

import UIKit


class ItemListTableViewCell: UITableViewCell {

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceButton: UIButton!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemPriceButton.backgroundColor = .clear
        itemPriceButton.layer.cornerRadius = 10
        itemPriceButton.layer.borderWidth = 1
        itemPriceButton.layer.borderColor = UIColor.black.cgColor
        itemPriceButton.backgroundColor = barTintColor
        self.selectionStyle = .none
        self.accessoryType = .disclosureIndicator
    }

    
    func configureSelf(withModel model: Item) {
        itemNameLabel.text = model.name
        let buttonTitle = String(model.price) + " " + "руб."
        itemPriceButton.setTitle(buttonTitle, for: .normal)
        itemDescriptionLabel.text = model.itemDescription
    }
}
