//
//  AboutController.swift
//  HW9.01
//
//  Created by apple on 11/27/16.
//  Copyright © 2016 韩青烽. All rights reserved.
//

import UIKit

class AboutController: UIViewController {

    @IBOutlet var menu: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        menu.target = self.revealViewController()
        menu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
