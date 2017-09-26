//
//  LegiStateTableViewCell.swift
//  HW9.01
//
//  Created by apple on 11/23/16.
//  Copyright © 2016 韩青烽. All rights reserved.
//

import UIKit

class LegiStateTableViewCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var state: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
