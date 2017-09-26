//
//  LegiHouseTableViewCell.swift
//  HW9.01
//
//  Created by apple on 11/21/16.
//  Copyright © 2016 韩青烽. All rights reserved.
//

import Foundation
import UIKit

class LegiHouseTableViewCell: UITableViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var state: UILabel!
    @IBOutlet var photo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
