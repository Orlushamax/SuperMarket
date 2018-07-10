//
//  ProfileTableViewCell.swift
//  TestAltarix
//
//  Created by Орлов Максим on 13.06.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isUserInteractionEnabled = false
        if let name = UserDefaults.standard.object(forKey: "CustomerName") {
            self.nameLabel.text = name as? String
        }
    }
}
