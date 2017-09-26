//
//  LegiTableViewController.swift
//  HW9.01
//
//  Created by apple on 11/21/16.
//  Copyright © 2016 韩青烽. All rights reserved.
//

import AlamofireImage
import SwiftyJSON
import Alamofire

class LegiTableViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate,UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var menu: UIBarButtonItem!
    
    @IBOutlet var tableview: UITableView!


    //main data
    var arr :[[String: AnyObject]] = []
    var arrListGrouped = NSDictionary() as! [String : [[String: AnyObject]]]
    // array of section titles
    var sectionTitleList = [String]()

    //picker view
    var filteredArr :[[String: AnyObject]] = []
    var filteredarrListGrouped = NSDictionary() as! [String : [[String: AnyObject]]]
    var filteredsectionTitleList = [String]()
    
    var pickState = UIPickerView()
    var isinfilter = false
    @IBAction func filter(_ sender: Any) {
        if(isinfilter == false){
            isinfilter = true
            tableview.isHidden = true
            pickState.isHidden = false
            pickState.center = self.view.center
            pickState.delegate = self
            pickState.dataSource = self
            self.view.addSubview(pickState)}
        else {
            filteredArr = []
            filteredarrListGrouped = NSDictionary() as! [String : [[String: AnyObject]]]
            filteredsectionTitleList = [String]()
            isinfilter = false
            tableview.isHidden = false
            pickState.isHidden = true
            tableview.reloadData()
        }
    }
    func filterContentForPcikerView(searchText: String) {
        filteredArr = arr.filter{ x in
            return (x["state_name"] as! String) == searchText
        }
    }
    fileprivate func splitFilterDataInToSection() {
        var sectionTitle: String = ""
        for i in 0..<self.filteredArr.count {
            let currentRecord = self.filteredArr[i]
            let firstChar = (currentRecord["state_name"]as! String!)[(currentRecord["state_name"]as! String!).startIndex]
            let firstCharString = "\(firstChar)"
            if firstCharString != sectionTitle {
                sectionTitle = firstCharString
                self.filteredarrListGrouped[sectionTitle] = [[String: AnyObject]]()
                self.filteredsectionTitleList.append(sectionTitle)
            }
            self.filteredarrListGrouped[firstCharString]?.append(currentRecord)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menu.target = self.revealViewController()
        menu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        
        SwiftSpinner.show("Fetching data")
        //set font of bar button item
        //barbutton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica", size: 17.0)!], for: UIControlState.normal)
        
        //retrieve data
        let url = "http://hqf-env1.us-west-2.elasticbeanstalk.com/"
        let parameters: Parameters = ["action": 1]
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
            let swiftjsondata = JSON(response.result.value!)
            if let resData = swiftjsondata["results"].arrayObject {
                self.arr = resData as! [[String: AnyObject]]
                self.arr.sort{
                    let state1 = $0["state_name"] as? String
                    let state2 = $1["state_name"] as? String
                    
                    return state1! < state2!
                }
            }
            self.splitDataInToSection()
            
            self.tableview.reloadData()
            SwiftSpinner.hide()
        }
        self.navigationItem.title = "Legislators"
    }
    
    
    fileprivate func splitDataInToSection() {
        var sectionTitle: String = ""
        for i in 0..<self.arr.count {
            let currentRecord = self.arr[i]
            let firstChar = (currentRecord["state_name"]as! String!)[(currentRecord["state_name"]as! String!).startIndex]
            let firstCharString = "\(firstChar)"
            if firstCharString != sectionTitle {
                sectionTitle = firstCharString
                self.arrListGrouped[sectionTitle] = [[String: AnyObject]]()
                self.sectionTitleList.append(sectionTitle)
            }
            self.arrListGrouped[firstCharString]?.append(currentRecord)
        }
        
        for i in 0..<self.sectionTitleList.count {
            let sectionTitle = self.sectionTitleList[i]
            if let arrs = self.arrListGrouped[sectionTitle]{
                self.arrListGrouped[sectionTitle] = arrs.sorted{
                    let lname1 = $0["last_name"] as? String
                    let lname2 = $1["last_name"] as? String
                    return lname1! < lname2!
                }
            }
        }
        
    }

     func numberOfSections(in tableView: UITableView) -> Int {
        if isinfilter == true {return self.filteredarrListGrouped.count}
        return self.arrListGrouped.count
    }

     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isinfilter == true {return self.filteredsectionTitleList[section]}
        return self.sectionTitleList[section]
    }
    
     func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if isinfilter == true {return self.filteredsectionTitleList}
        return self.sectionTitleList
    }

     func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isinfilter == true {
            let sectionTitle = self.filteredsectionTitleList[section]
            let arrs = self.filteredarrListGrouped[sectionTitle]
            return arrs!.count
        }

        let sectionTitle = self.sectionTitleList[section]
        let arrs = self.arrListGrouped[sectionTitle]
        return arrs!.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LegiStateTableViewCell
        
        if isinfilter == true {
            let sectionTitle = self.filteredsectionTitleList[(indexPath as NSIndexPath).section]
            let arrs = self.filteredarrListGrouped[sectionTitle]
            cell.name.text = (arrs?[indexPath.row]["first_name"] as! String?)! + " "
                + (arrs![indexPath.row]["last_name"] as! String?)!
            cell.state.text = (arrs![indexPath.row]["state_name"] as! String?)!
            
            if let url = URL(string: "https://theunitedstates.io/images/congress/original/"+(arrs![indexPath.row]["bioguide_id"] as! String?)!+".jpg"){
                cell.photo.af_setImage(withURL: url)
            }
            return cell
        }

        
        let sectionTitle = self.sectionTitleList[(indexPath as NSIndexPath).section]
        let arrs = self.arrListGrouped[sectionTitle]
        cell.name.text = (arrs?[indexPath.row]["first_name"] as! String?)! + " "
        + (arrs![indexPath.row]["last_name"] as! String?)!
        cell.state.text = (arrs![indexPath.row]["state_name"] as! String?)!
        
       
        if let url = URL(string: "https://theunitedstates.io/images/congress/original/"+(arrs![indexPath.row]["bioguide_id"] as! String?)!+".jpg"){
        cell.photo.af_setImage(withURL: url)
        }
        return cell
    }
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    //detail
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "stateDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var sectionTitle = self.sectionTitleList[(sender as! NSIndexPath).section]
        var arrs = self.arrListGrouped[sectionTitle]
        
        if isinfilter == true {
            sectionTitle = self.filteredsectionTitleList[(sender as! NSIndexPath).section]
            arrs = self.filteredarrListGrouped[sectionTitle]
        }
        let arrtemp = arrs
        if let destinationDT = segue.destination as? LegiStateDetail {
            
            destinationDT.allinfor = (arrtemp?[(sender as! NSIndexPath).row])!

            destinationDT.stateName = (arrtemp?[(sender as! NSIndexPath).row]["state_name"] as! String?)!
            destinationDT.bioid = arrtemp?[(sender as! NSIndexPath).row]["bioguide_id"] as! String?
            destinationDT.lname = arrtemp?[(sender as! NSIndexPath).row]["last_name"] as! String?
            destinationDT.fname = arrtemp?[(sender as! NSIndexPath).row]["first_name"] as! String?
            destinationDT.gender = arrtemp?[(sender as! NSIndexPath).row]["gender"] as! String?
            destinationDT.birthday = arrtemp?[(sender as! NSIndexPath).row]["birthday"] as! String?
            destinationDT.chamber = arrtemp?[(sender as! NSIndexPath).row]["chamber"] as! String?
            
            if let fax = arrtemp?[(sender as! NSIndexPath).row]["fax"] as? String {
                destinationDT.faxNo = fax
            }
            else {
                destinationDT.faxNo = "N.A" as String
            }
            if let twi = arrtemp?[(sender as! NSIndexPath).row]["twitter_id"] as? String {
                destinationDT.twitter = twi
            }
            else {
                destinationDT.twitter = "N.A" as String
            }
            if let face = arrtemp?[(sender as! NSIndexPath).row]["facebook_id"] as? String {
                destinationDT.facebook = face
            }
            else {
                destinationDT.facebook = "N.A" as String
            }
            
            destinationDT.website = arrtemp?[(sender as! NSIndexPath).row]["website"] as! String?
            destinationDT.office = arrtemp?[(sender as! NSIndexPath).row]["office"] as! String?
            destinationDT.website = arrtemp?[(sender as! NSIndexPath).row]["website"] as! String?
            destinationDT.termend = arrtemp?[(sender as! NSIndexPath).row]["term_end"] as! String?
        }
    }
    
    //PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stateName.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stateName[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print("\(stateName[row])")
        filterContentForPcikerView(searchText: stateName[row])
        splitFilterDataInToSection()
        tableview.reloadData()
        //print(filteredArr)
        tableview.isHidden = false
        pickerView.isHidden = true
    }
    
    
    //helper data
    let stateName: [String] = ["Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","District of Columbia","Federated States Of Micronesia","Florida","Georgia","Guam","Hawaii","Idaho","Illinois","Indiana","Iowa", "Kansas","Kentucky","Louisiana","Maine","Marshall Islands","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska", "Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Northern Mariana Islands","Ohio","Oklahoma","Oregon","Palau","Pennsylvania","Puerto Rico","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virgin Islands","Virginia","Washington","West Virginia","Wisconsin","Wyoming"]
}
