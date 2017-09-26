//
//  Menu.swift
//  HW9.01
//
//  Created by apple on 11/20/16.
//  Copyright © 2016 韩青烽. All rights reserved.
//

import Foundation

class Menu: UITableViewController {

    var TableArray = [String]()
    
    override func viewDidLoad() {
        TableArray = ["Legislators", "Bills", "Committee","Favorite", "About"]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableArray[indexPath.row], for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = TableArray[indexPath.row]
        
        return cell
    }
    
    
    
    
}
