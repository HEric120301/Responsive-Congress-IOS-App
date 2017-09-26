//
//  CommHouseController.swift
//  HW9.01
//
//  Created by apple on 11/27/16.
//  Copyright © 2016 韩青烽. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

class CommHouseController: UITableViewController {
    var arr :[[String: AnyObject]] = []

    @IBOutlet var menu: UIBarButtonItem!
    //search
    let searchController = UISearchController(searchResultsController: nil)
    var filteredArr :[[String: AnyObject]] = []
    var filteredarrListGrouped = NSDictionary() as! [String : [[String: AnyObject]]]
    var filteredsectionTitleList = [String]()
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredArr = arr.filter{ x in
            return ((x["name"] as! String).lowercased().contains(searchText.lowercased()))
        }
        tableView.reloadData()
    }
    
    
    //search
    @IBOutlet var sbutton: UIBarButtonItem!
    @IBAction func searchButton(_ sender: Any) {
        if(self.navigationItem.titleView != nil){
            self.navigationItem.title = "Committees"
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
        self.navigationItem.title = "Committees"
        self.navigationItem.titleView = nil
        
        searchController.searchBar.text = ""
        self.tableView.reloadData()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchController.loadViewIfNeeded()

        menu.target = self.revealViewController()
        menu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        //set font of bar button item
        //House.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica", size: 17.0)!], for: UIControlState.normal)
        
        SwiftSpinner.show("Fetching data")
        //retrieve data
        let url = "http://hqf-env1.us-west-2.elasticbeanstalk.com/"
        let parameters: Parameters = ["action": 4]
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
            let swiftjsondata = JSON(response.result.value!)
            if let resData = swiftjsondata["results"].arrayObject {
                self.arr = resData as! [[String: AnyObject]]
                self.arr = self.arr.filter({($0["chamber"] as! String) == "house"})
                self.arr.sort{
                    let name1 = $0["name"] as? String
                    let name2 = $1["name"] as? String
                    return name1!<name2!
                }
            }
            self.tableView.reloadData()
            SwiftSpinner.hide()
        }
        //initial title
        self.navigationItem.title = "Committees"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommHouseCell", for: indexPath) as! CommHouseCell
        
        if searchController.isActive && searchController.searchBar.text != "" {
            cell.name.text = (filteredArr[indexPath.row]["name"] as! String?)!
            cell.commid.text = (filteredArr[indexPath.row]["committee_id"] as! String?)!
            return cell
        }
        
        cell.name.text = (arr[indexPath.row]["name"] as! String?)!
        cell.commid.text = (arr[indexPath.row]["committee_id"] as! String?)!
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    
    //detail
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CommHouseDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var arrtemp :[[String: AnyObject]] = []
        if searchController.isActive && searchController.searchBar.text != "" {
            arrtemp = filteredArr
        }
        else {arrtemp = arr}
        if let destinationDT = segue.destination as? CommHouseDetail {

            destinationDT.allinfor = arrtemp[(sender as! NSIndexPath).row]

            destinationDT.name = (arrtemp[(sender as! NSIndexPath).row]["name"] as! String?)!
            destinationDT.commid = (arrtemp[(sender as! NSIndexPath).row]["committee_id"] as! String?)!
            
            if let parent = arrtemp[(sender as! NSIndexPath).row]["parent_committee_id"] as? String {
                destinationDT.parentid = parent
            }
            else{
                destinationDT.parentid = "N.A"
            }
            destinationDT.chamber = arrtemp[(sender as! NSIndexPath).row]["chamber"] as! String?
            if let office = arrtemp[(sender as! NSIndexPath).row]["office"] as? String {
                destinationDT.office = office
            }
            else{
                destinationDT.office = "N.A"
            }
            if let contact = arrtemp[(sender as! NSIndexPath).row]["phone"] as? String {
                destinationDT.contact = contact
            }
            else{
                destinationDT.contact = "N.A"
            }
        }
    }
}

//search
extension CommHouseController: UISearchResultsUpdating {
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
