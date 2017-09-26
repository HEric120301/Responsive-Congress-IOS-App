//
//  CommHouseCell.swift
//  HW9.01
//
//  Created by apple on 11/27/16.
//  Copyright © 2016 韩青烽. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

class CommHouseCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var commid: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
