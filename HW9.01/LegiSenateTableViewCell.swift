//
//  LegiSenateTableViewCell.swift
//  HW9.01
//
//  Created by apple on 11/23/16.
//  Copyright © 2016 韩青烽. All rights reserved.
//

import UIKit

class LegiSenateTableViewCell: UITableViewCell {
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var photo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
