//
//  MainMenuViewController.swift
//  MaterialSideMenu
//
//  Created by Logomorph on 17/07/2019.
//  Copyright © 2019 Logomorph. All rights reserved.
//

import UIKit
import MaterialSideMenu

class MainMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var sideMenu:MaterialSideMenuViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = "Home"
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "No side gestures"
        } else {
            cell.textLabel?.text = "Screen \(indexPath.row)"
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            sideMenu?.goHome()
            tableView.deselectRow(at: indexPath, animated: true)
        } else if indexPath.row == 1 {
            sideMenu?.pushViewController(NoGesturesViewController(nibName: nil, bundle: nil), animated: false)
        } else {
            let newController = UIViewController()
            newController.title = "Screen \(indexPath.row)"
            sideMenu?.pushViewController(newController, animated: false)
        }
    }
}
