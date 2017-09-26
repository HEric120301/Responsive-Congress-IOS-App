//
//  CommJointDetail.swift
//  HW9.01
//
//  Created by apple on 11/27/16.
//  Copyright © 2016 韩青烽. All rights reserved.
//

import UIKit

class CommJointDetail: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var textview: UITextView!
    @IBOutlet var tableview: UITableView!
    let titles: [String] = ["ID", "Parent ID", "Chamber", "Office", "Contact"]
    var bioid: String?
    //content data
    var contents: [String] = []
    var name: String?
    var commid: String?
    var parentid: String?
    var chamber: String?
    var office: String?
    var contact: String?
    var allinfor: [String: AnyObject] = [:]
    
    //favorite
    @IBOutlet var fav: UIBarButtonItem!
    var isfav = false
    @IBAction func fav(_ sender: Any) {
        if isfav == false {
            isfav = true
            GlobalFav.CommFav.append(allinfor)
            fav.image = UIImage(named: "dofav") as UIImage?
        }
        else {
            isfav = false
            fav.image = UIImage(named: "unfav") as UIImage?
            var index = 0
            for temp in GlobalFav.CommFav {
                if temp["committee_id"] as? String! == commid {break}
                index += 1
            }
            GlobalFav.CommFav.remove(at: index)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableview)
        self.navigationItem.title = "Committees"
        
        self.tableview.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0)

        self.fav.tintColor = UIColor.blue
        for temp in GlobalFav.CommFav {
            if temp["committee_id"] as? String! == commid {
                isfav = true
                break
            }
        }
        if isfav == true {fav.image = UIImage(named: "dofav")}
        else {fav.image = UIImage(named: "unfav")}
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contents.append(commid!)
        contents.append(parentid!)
        contents.append(chamber!)
        contents.append(office!)
        contents.append(contact!)
        textview.text = name
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let title = UILabel()
        let content = UILabel()
        title.font = title.font.withSize(14)
        content.font = content.font.withSize(14)
        content.frame = (frame: CGRect(x: cell.frame.size.width - 175, y: 7, width: 200, height: 30))
        content.text = contents[indexPath.row]
        cell.addSubview(content)
        
        title.text = titles[indexPath.row]
        title.frame = (frame: CGRect(x: cell.frame.size.width - 300, y: 7, width: 120, height: 30))
        cell.addSubview(title)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
