//
//  MainViewController.swift
//  TaskStalker
//
//  Created by Jolanta Zakrzewska on 14/07/2019.
//  Copyright © 2019 Jolanta Zakrzewska. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tempArray = [StalkItem]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none

        if let user = Auth.auth().currentUser?.email {
            print(user)
        } else {
            print("no user")
        }
        
    }
    
    @IBAction func addStalk(_ sender: Any) {
        var name = UITextField()
        var email = UITextField()
        var period = UITextField()
        
        let alert = UIAlertController(title: "Add new stalk", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {(action) in
            let newItem = StalkItem()
            newItem.email = email.text!
            newItem.name = name.text!
            newItem.stalkPeriod = period.text!
            self.tempArray.append(newItem)
            self.tableView.reloadData()
        }
        
        alert.addTextField {(alertTextField) in
            alertTextField.placeholder = "write name"
            name = alertTextField
        }
        
        alert.addTextField {(alertTextField) in
            alertTextField.placeholder = "write email"
            email = alertTextField
        }
        
        alert.addTextField {(alertTextField) in
            alertTextField.placeholder = "write period"
            period = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        self.performSegue(withIdentifier: "logout", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tempArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "StalkCell")
        cell.textLabel?.text = "\(self.tempArray[indexPath.row].name) (\(self.tempArray[indexPath.row].email))"
        cell.detailTextLabel?.text = self.tempArray[indexPath.row].stalkPeriod
        
        cell.textLabel?.textColor = FlatSand()
        cell.detailTextLabel?.textColor = FlatSand()
        cell.textLabel?.backgroundColor = FlatMintDark()
        cell.detailTextLabel?.backgroundColor = FlatMintDark()
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        cell.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 12.0)
        cell.backgroundColor = FlatMintDark().darken(byPercentage: CGFloat(indexPath.row) / CGFloat(tempArray.count))
        
        return cell
    }

}
