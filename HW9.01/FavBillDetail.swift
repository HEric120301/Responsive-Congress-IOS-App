//
//  FavBillDetail.swift
//  HW9.01
//
//  Created by apple on 11/28/16.
//  Copyright © 2016 韩青烽. All rights reserved.
//

import UIKit

class FavBillDetail: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableview: UITableView!
    @IBOutlet var textview: UITextView!
    let titles: [String] = ["Bill ID", "Bill Type", "Sponsor", "Last Action","PDF",  "Chamber", "Last Vote", "Status"]
    var bioid: String?
    //content data
    var contents: [String] = []
    
    var billid: String?
    var billtype: String?
    var sponsor: String?
    var lastaction: String?
    var pdf: String?
    var chamber: String?
    var lastvote: String?
    var status: String?
    var offtitle: String?
    var allinfor: [String: AnyObject] = [:]
    
    //favorite
    var isfav = false
    @IBOutlet var fav: UIBarButtonItem!
    @IBAction func fav(_ sender: Any) {
        if isfav == false {
            isfav = true
            GlobalFav.BillFav.append(allinfor)
            fav.image = UIImage(named: "dofav") as UIImage?
        }
        else {
            isfav = false
            fav.image = UIImage(named: "unfav") as UIImage?
            var index = 0
            for temp in GlobalFav.BillFav {
                if temp["bill_id"] as? String! == billid {break}
                index += 1
            }
            GlobalFav.BillFav.remove(at: index)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableview)
        self.navigationItem.title = "Bill Details"
        
        self.tableview.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0)

        self.fav.tintColor = UIColor.blue
        for temp in GlobalFav.BillFav {
            if temp["bill_id"] as? String! == billid {
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
        contents.append(billid!)
        contents.append(billtype!)
        contents.append(sponsor!)
        contents.append(lastaction!)
        contents.append(pdf!)
        contents.append(chamber!)
        contents.append(lastvote!)
        contents.append(status!)
        textview.text = offtitle
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
        cell.addSubview(content)
        title.text = titles[indexPath.row]
        title.frame = (frame: CGRect(x: cell.frame.size.width - 300, y: 7, width: 120, height: 30))
        cell.addSubview(title)
        if(title.text == "PDF"){
            if(contents[indexPath.row] == "N.A"){content.text = contents[indexPath.row];cell.addSubview(content)}
            else{
                let button = UIButton()
                button.frame = (frame: CGRect(x: cell.frame.size.width - 245, y: 7, width: 216, height: 30))
                button.setTitle("PDF Link", for: .normal)
                button.setTitleColor(UIColor.blue, for: .normal)
                button.addTarget(self, action: #selector(webAction), for: .touchUpInside)
                button.tag = indexPath.row
                button.titleLabel?.font = button.titleLabel?.font.withSize(14)
                cell.addSubview(button)
            }
        }
        else {
            var tempcontent = ""
            if title.text == "Last Action" {
                tempcontent = dateHelper(sourcedate: contents[indexPath.row])
            }
            else if title.text == "Chamber" {
                if(title.text == "house") {tempcontent = "House"}
                else {tempcontent = "Senate"}
            }
            else {tempcontent = contents[indexPath.row]}
            content.text = tempcontent
            cell.addSubview(content)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func dateHelper(sourcedate: String!) -> String{
        let year = String(sourcedate.characters.prefix(4))
        let date = String(String(String(sourcedate.characters.prefix(10))).characters.suffix(2))
        let month = monthHash[String(String(String(sourcedate.characters.prefix(7))).characters.suffix(2))]
        return "\(date) \(month!) \(year)"
    }
    func webAction(sender: UIButton!) {
        UIApplication.shared.openURL(URL(string: contents[sender.tag])!)
    }
    var monthHash: [String: String] = ["01": "Jan", "02":"Feb", "03":"Mar", "04":"Apr","05":"May","06":"Jun","07":"Jul","08":"Aug","09":"Sep","10":"Oct","11":"Nov","12":"Dec"]
}
