//
//  FavLegiCell.swift
//  HW9.01
//
//  Created by apple on 11/28/16.
//  Copyright © 2016 韩青烽. All rights reserved.
//

import UIKit

class FavLegiCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var state: UILabel!
    @IBOutlet var photo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
