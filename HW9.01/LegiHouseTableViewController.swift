//
//  LegiHouseTableViewController.swift
//  HW9.01
//
//  Created by apple on 11/21/16.
//  Copyright © 2016 韩青烽. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import AlamofireImage

class LegiHouseTableViewController: UITableViewController {

    
    @IBOutlet var menu: UIBarButtonItem!
    var arr :[[String: AnyObject]] = []
    //search
    let searchController = UISearchController(searchResultsController: nil)
    var filteredArr :[[String: AnyObject]] = []
    var filteredarrListGrouped = NSDictionary() as! [String : [[String: AnyObject]]]
    var filteredsectionTitleList = [String]()
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredArr = arr.filter{ x in
            return ((x["first_name"] as! String).lowercased().contains(searchText.lowercased()))
        }
        tableView.reloadData()
    }
    
    @IBOutlet var sbutton: UIBarButtonItem!
    @IBAction func searchButton(_ sender: Any) {
        if(self.navigationItem.titleView != nil){
            self.navigationItem.title = "Legislators"
            self.navigationItem.titleView = nil
        }
        else {
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.titleView = searchController.searchBar
            self.navigationItem.title = nil
        }
    }
    //handle back-from-detail event
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.rightBarButtonItem = self.sbutton
        self.navigationItem.title = "Legislators"
        self.navigationItem.titleView = nil
        
        searchController.searchBar.text = ""
        self.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchController.loadViewIfNeeded()    // iOS 9
        
        menu.target = self.revealViewController()
        menu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        //set font of bar button item
        //House.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica", size: 17.0)!], for: UIControlState.normal)
        
        SwiftSpinner.show("Fetching data")
        //retrieve data
        let url = "http://hqf-env1.us-west-2.elasticbeanstalk.com/"
        let parameters: Parameters = ["action": 1]
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
            let swiftjsondata = JSON(response.result.value!)
            if let resData = swiftjsondata["results"].arrayObject {
                self.arr = resData as! [[String: AnyObject]]
                
                self.arr = self.arr.filter({($0["chamber"] as! String) == "house"})
                self.arr.sort{
                    let name1 = $0["first_name"] as? String
                    let name2 = $1["first_name"] as? String
                    let lname1 = $0["last_name"] as? String
                    let lname2 = $1["last_name"] as? String
                    if((name1?[(name1?.startIndex)!])! == (name2?[(name2?.startIndex)!])!){
                        if((lname1?[(lname1?.startIndex)!])! == (lname2?[(lname2?.startIndex)!])!){
                            if(lname1 == lname2){return name1! < name2!}
                            else{return lname1! < lname2!}
                        }
                        else{return lname1! < lname2!}
                    }
                    else{return name1! < name2!}
                }
            }
            self.tableView.reloadData()
            SwiftSpinner.hide()
        }
        //initial title
        self.navigationItem.title = "Legislators"
        //search
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.isTranslucent = true
        self.searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        self.navigationItem.titleView = searchController.searchBar
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {return filteredArr.count}
        return arr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellHouse", for: indexPath) as! LegiHouseTableViewCell
        
        if searchController.isActive && searchController.searchBar.text != "" {
            cell.name.text = (filteredArr[indexPath.row]["first_name"] as! String?)! + " "
                + (filteredArr[indexPath.row]["last_name"] as! String?)!
            cell.state.text = (filteredArr[indexPath.row]["state_name"] as! String?)!

            if let url = URL(string: "https://theunitedstates.io/images/congress/original/"+(filteredArr[indexPath.row]["bioguide_id"] as! String?)!+".jpg"){
                cell.photo.af_setImage(withURL: url)
            }
            return cell
        }
        cell.name.text = (arr[indexPath.row]["first_name"] as! String?)! + " "
            + (arr[indexPath.row]["last_name"] as! String?)!
        cell.state.text = (arr[indexPath.row]["state_name"] as! String?)!
        
        if let url = URL(string: "https://theunitedstates.io/images/congress/original/"+(arr[indexPath.row]["bioguide_id"] as! String?)!+".jpg"){
            cell.photo.af_setImage(withURL: url)
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    //detail
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "houseDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var arrtemp :[[String: AnyObject]] = []
        if searchController.isActive && searchController.searchBar.text != "" {
            arrtemp = filteredArr
        }
        else {arrtemp = arr}
        if let destinationDT = segue.destination as? LegiHouseDetail {
            destinationDT.allinfor = arrtemp[(sender as! NSIndexPath).row]

            destinationDT.stateName = (arrtemp[(sender as! NSIndexPath).row]["state_name"] as! String?)!
            destinationDT.bioid = arrtemp[(sender as! NSIndexPath).row]["bioguide_id"] as! String?
            destinationDT.lname = arrtemp[(sender as! NSIndexPath).row]["last_name"] as! String?
            destinationDT.fname = arrtemp[(sender as! NSIndexPath).row]["first_name"] as! String?
            destinationDT.gender = arrtemp[(sender as! NSIndexPath).row]["gender"] as! String?
            destinationDT.birthday = arrtemp[(sender as! NSIndexPath).row]["birthday"] as! String?
            destinationDT.chamber = arrtemp[(sender as! NSIndexPath).row]["chamber"] as! String?
            
            if let fax = arrtemp[(sender as! NSIndexPath).row]["fax"] as? String {
                destinationDT.faxNo = fax
            }
            else {
                destinationDT.faxNo = "N.A" as String
            }
            if let twi = arrtemp[(sender as! NSIndexPath).row]["twitter_id"] as? String {
                destinationDT.twitter = twi
            }
            else {
                destinationDT.twitter = "N.A" as String
            }
            if let face = arrtemp[(sender as! NSIndexPath).row]["facebook_id"] as? String {
                destinationDT.facebook = face
            }
            else {
                destinationDT.facebook = "N.A" as String
            }
            
            destinationDT.website = arrtemp[(sender as! NSIndexPath).row]["website"] as! String?
            destinationDT.office = arrtemp[(sender as! NSIndexPath).row]["office"] as! String?
            destinationDT.website = arrtemp[(sender as! NSIndexPath).row]["website"] as! String?
            destinationDT.termend = arrtemp[(sender as! NSIndexPath).row]["term_end"] as! String?
        }
    }

}

//search
extension LegiHouseTableViewController: UISearchResultsUpdating {
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
