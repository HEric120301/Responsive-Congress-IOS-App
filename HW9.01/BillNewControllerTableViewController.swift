//
//  BillNewControllerTableViewController.swift
//  HW9.01
//
//  Created by apple on 11/27/16.
//  Copyright © 2016 韩青烽. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import AlamofireImage

class BillNewControllerTableViewController: UITableViewController {
    
    var arr :[[String: AnyObject]] = []

    @IBOutlet weak var menu: UIBarButtonItem!
    //search
    let searchController = UISearchController(searchResultsController: nil)
    var filteredArr :[[String: AnyObject]] = []
    var filteredarrListGrouped = NSDictionary() as! [String : [[String: AnyObject]]]
    var filteredsectionTitleList = [String]()
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredArr = arr.filter{ x in
            return ((x["official_title"] as! String).lowercased().contains(searchText.lowercased()))
        }
        tableView.reloadData()
    }
    
    
    @IBOutlet var sbutton: UIBarButtonItem!
    
    @IBAction func searchButton(_ sender: Any) {
        if(self.navigationItem.titleView != nil){
            self.navigationItem.title = "Bills"
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
        self.navigationItem.title = "Bills"
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
        let parameters: Parameters = ["action": 3]
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
            let swiftjsondata = JSON(response.result.value!)
            if let resData = swiftjsondata["results"].arrayObject {
                self.arr = resData as! [[String: AnyObject]]
                self.arr.sort{
                    let offtitle1 = $0["introduced_on"] as? String
                    let offtitle2 = $1["introduced_on"] as? String
                    return offtitle1! > offtitle2!
                }
            }
            self.tableView.reloadData()
            SwiftSpinner.hide()
        }
        //initial title
        self.navigationItem.title = "Bills"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "BillNewCell", for: indexPath) as! BillNewCellTableViewCell
        cell.off_title.numberOfLines = 3;
        if searchController.isActive && searchController.searchBar.text != "" {
            cell.bill_id.text = (filteredArr[indexPath.row]["bill_id"] as! String?)!
            
            cell.off_title.text = (filteredArr[indexPath.row]["official_title"] as! String?)!
            cell.time.text = (dateHelper(sourcedate: filteredArr[indexPath.row]["last_action_at"] as! String!))
            return cell
        }
        cell.bill_id.text = (arr[indexPath.row]["bill_id"] as! String?)!
        cell.off_title.text = (arr[indexPath.row]["official_title"] as! String?)!
        cell.time.text = (dateHelper(sourcedate: arr[indexPath.row]["last_action_at"] as! String!))
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    
    //detail
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "BillNewDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var arrtemp :[[String: AnyObject]] = []
        if searchController.isActive && searchController.searchBar.text != "" {
            arrtemp = filteredArr
        }
        else {arrtemp = arr}
        if let destinationDT = segue.destination as? BillNewDetail {
            destinationDT.allinfor = arrtemp[(sender as! NSIndexPath).row]

            destinationDT.billid = (arrtemp[(sender as! NSIndexPath).row]["bill_id"] as! String?)!
            destinationDT.billtype = arrtemp[(sender as! NSIndexPath).row]["bill_type"] as! String?
            if let name = arrtemp[(sender as! NSIndexPath).row]["sponsor"] as?  NSDictionary {
                destinationDT.sponsor = "\(name["title"]!) \(name["first_name"]!) \(name["last_name"]!)"
            }
            destinationDT.lastaction = arrtemp[(sender as! NSIndexPath).row]["last_action_at"] as! String?
            if let lastversion = arrtemp[(sender as! NSIndexPath).row]["last_version"] as? NSDictionary {
                if let urls = lastversion["urls"] as? NSDictionary {
                    destinationDT.pdf = urls["pdf"] as! String?
                }
                else {destinationDT.pdf = "N.A"}
            }
            else{
                destinationDT.pdf = "N.A"
            }
            destinationDT.chamber = arrtemp[(sender as! NSIndexPath).row]["chamber"] as! String?
            destinationDT.status = "New"
            destinationDT.offtitle = arrtemp[(sender as! NSIndexPath).row]["official_title"] as! String?
            
            
            if let lastV = arrtemp[(sender as! NSIndexPath).row]["last_vote_at"] as? String {
                destinationDT.lastvote = lastV
            }
            else {
                destinationDT.lastvote = "N.A" as String
            }
        }
    }
    func dateHelper(sourcedate: String!) -> String{
        let year = String(sourcedate.characters.prefix(4))
        let date = String(String(String(sourcedate.characters.prefix(10))).characters.suffix(2))
        let month = monthHash[String(String(String(sourcedate.characters.prefix(7))).characters.suffix(2))]
        return "\(date) \(month!) \(year)"
    }
    var monthHash: [String: String] = ["01": "Jan", "02":"Feb", "03":"Mar", "04":"Apr","05":"May","06":"Jun","07":"Jul","08":"Aug","09":"Sep","10":"Oct","11":"Nov","12":"Dec"]
}

//search
extension BillNewControllerTableViewController: UISearchResultsUpdating {
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
