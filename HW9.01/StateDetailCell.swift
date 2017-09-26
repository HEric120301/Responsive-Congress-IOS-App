//
//  StateDetailCell.swift
//  HW9.01
//
//  Created by apple on 11/26/16.
//  Copyright © 2016 韩青烽. All rights reserved.
//

import UIKit

class StateDetailCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
