//
//  LegiStateDetail.swift
//  HW9.01
//
//  Created by apple on 11/22/16.
//  Copyright © 2016 韩青烽. All rights reserved.
//

import UIKit

class LegiStateDetail: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet var photo: UIImageView!
    //tableview
    let titles: [String] = ["First Name", "Last Name", "State", "Birth date", "Gender","Chamber", "Fax No.","Twitter","Facebook","Website","Office No.","Term ends on"]
    var bioid: String?
    //content data
    var contents: [String] = []
    
    var lname: String?
    var fname: String?
    var stateName: String?
    var gender: String?
    var birthday: String?
    var chamber: String?
    var faxNo: String?
    var twitter: String?
    var facebook: String?
    var website: String?
    var office: String?
    var termend: String?
    var allinfor: [String: AnyObject] = [:]
    
    //favorite
    var isfav = false
    @IBOutlet var fav: UIBarButtonItem!
    @IBAction func fav(_ sender: Any) {
        if isfav == false {
            isfav = true
            GlobalFav.LegiFav.append(allinfor)
            fav.image = UIImage(named: "dofav") as UIImage?
        }
        else {
            isfav = false
            fav.image = UIImage(named: "unfav") as UIImage?
            var index = 0
            for temp in GlobalFav.LegiFav {
                
                if temp["bioguide_id"] as? String! == bioid {break}
                index += 1
            }
            GlobalFav.LegiFav.remove(at: index)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableview)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contents.append(lname!)
        contents.append(fname!)
        contents.append(stateName!)
        contents.append(birthday!)
        contents.append(gender!)
        contents.append(chamber!)
        contents.append(faxNo!)
        contents.append(twitter!)
        contents.append(facebook!)
        contents.append(website!)
        contents.append(office!)
        contents.append(termend!)
        photo.af_setImage(withURL: URL(string: ("https://theunitedstates.io/images/congress/original/"+bioid!+".jpg" as String?)!)!)
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
        content.font = content.font.withSize(14)
        content.frame = (frame: CGRect(x: cell.frame.size.width - 175, y: 7, width: 200, height: 30))
        title.font = title.font.withSize(14)
        title.text = titles[indexPath.row]
        title.frame = (frame: CGRect(x: cell.frame.size.width - 300, y: 7, width: 120, height: 30))
        cell.addSubview(title)
        if(title.text == "Twitter"){
            if(contents[indexPath.row] == "N.A"){content.text = contents[indexPath.row];cell.addSubview(content)}
            else{
                let button = UIButton()
                button.frame = (frame: CGRect(x: cell.frame.size.width - 245, y: 7, width: 216, height: 30))
                button.setTitle("Twitter Link", for: .normal)
                button.setTitleColor(UIColor.blue, for: .normal)
                button.addTarget(self, action: #selector(twitterAction), for: .touchUpInside)
                button.tag = indexPath.row
                button.titleLabel?.font = button.titleLabel?.font.withSize(14)
                cell.addSubview(button)
            }
        }
        else if(title.text == "Facebook"){
            if(contents[indexPath.row] == "N.A"){content.text = contents[indexPath.row];cell.addSubview(content)}
            else{
                let button = UIButton()
                button.frame = (frame: CGRect(x: cell.frame.size.width - 235, y: 7, width: 216, height: 30))
                button.setTitle("Facebook Link", for: .normal)
                button.setTitleColor(UIColor.blue, for: .normal)
                button.addTarget(self, action: #selector(facebookAction), for: .touchUpInside)
                button.tag = indexPath.row
                button.titleLabel?.font = button.titleLabel?.font.withSize(14)
                cell.addSubview(button)
            }
        }
        else if(title.text == "Website"){
            if(contents[indexPath.row] == "N.A"){content.text = contents[indexPath.row];cell.addSubview(content)}
            else{
                let button = UIButton()
                button.frame = (frame: CGRect(x: cell.frame.size.width - 240, y: 7, width: 216, height: 30))
                button.setTitle("Website Link", for: .normal)
                button.setTitleColor(UIColor.blue, for: .normal)
                button.addTarget(self, action: #selector(websiteAction), for: .touchUpInside)
                button.tag = indexPath.row
                button.titleLabel?.font = button.titleLabel?.font.withSize(14)
                cell.addSubview(button)
            }
        }
        else {
            var tempcontent = ""
            if title.text == "Gender" {
                if contents[indexPath.row] == "M" {tempcontent = "Male"}
                else {tempcontent = "Female"}
            }
            else if title.text == "Chamber"{
                if contents[indexPath.row] == "house" {tempcontent = "House"}
                else {tempcontent = "Senate"}
            }
            else if title.text == "Birth date" {
                tempcontent = dateHelper(sourcedate: contents[indexPath.row])
            }
            else if title.text == "Term ends on" {
                tempcontent = dateHelper(sourcedate: contents[indexPath.row])
            }
            else {tempcontent = contents[indexPath.row]}
            content.text = tempcontent
            cell.addSubview(content)
        }
        return cell
    }
    func dateHelper(sourcedate: String!) -> String{
        let year = String(sourcedate.characters.prefix(4))
        let date = String(sourcedate.characters.suffix(2))
        let month = monthHash[String(String(String(sourcedate.characters.prefix(7))).characters.suffix(2))]
        return "\(date) \(month!) \(year)"
    }
    func twitterAction(sender: UIButton!) {
        UIApplication.shared.openURL(URL(string: "https://twitter.com/\(contents[sender.tag])")!)
    }
    func facebookAction(sender: UIButton!) {
        UIApplication.shared.openURL(URL(string: "https://www.facebook.com/\(contents[sender.tag])")!)
    }
    func websiteAction(sender: UIButton!) {
        UIApplication.shared.openURL(URL(string: contents[sender.tag])!)
    }
    var monthHash: [String: String] = ["01": "Jan", "02":"Feb", "03":"Mar", "04":"Apr","05":"May","06":"Jun","07":"Jul","08":"Aug","09":"Sep","10":"Oct","11":"Nov","12":"Dec"]
}
