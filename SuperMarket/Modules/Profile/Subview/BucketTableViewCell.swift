//
//  BucketTableViewCell.swift
//  TestAltarix
//
//  Created by Орлов Максим on 12.06.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//

import UIKit

class BucketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.backgroundColor = barTintColor
        self.containerView.layer.cornerRadius = 10
    }
    
    func configureSelf(withModel model: OrderLine) {
        self.nameLabel.text = model.itemName
        self.qtyLabel.text = String(model.qty)
        self.priceLabel.text = String(model.itemPrice) + " " + "руб."
    }
}
