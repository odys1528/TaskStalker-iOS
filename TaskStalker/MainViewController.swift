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
import CoreData
import SwipeCellKit

class CustomStalkCell: UITableViewCell {//SwipeTableViewCell {
    @IBOutlet weak var nameLabel: UITextView!
    @IBOutlet weak var emailLabel: UITextView!
    @IBOutlet weak var periodLabel: UITextView!
}

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tempArray = [StalkItem]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        loadItems()
        
    }
    
    //MARK: - new stalk
    @IBAction func addStalk(_ sender: Any) {
        var name = UITextField()
        var email = UITextField()
        var period = UITextField()
        
        let alert = UIAlertController(title: "Add new stalk", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {(action) in
            if name.text != nil && email.text != nil && period.text != nil {
                let newItem = StalkItem(context: self.context)
                newItem.email = email.text!
                newItem.name = name.text!
                newItem.stalkPeriod = period.text!
                self.tempArray.append(newItem)
                self.saveItems()
            }
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
    
    //MARK: - tableView stuff
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "StalkCell", for: indexPath) as! CustomStalkCell
//        cell.delegate = self
        cell.nameLabel?.text = self.tempArray[indexPath.row].name
        cell.emailLabel?.text = self.tempArray[indexPath.row].email
        cell.periodLabel?.text = self.tempArray[indexPath.row].stalkPeriod
        
        cell.nameLabel?.textColor = FlatSand()
        cell.emailLabel?.textColor = FlatSand()
        cell.periodLabel?.textColor = FlatSand()
        
        let darkening = CGFloat(indexPath.row) / CGFloat(tempArray.count)
        cell.nameLabel?.backgroundColor = FlatMintDark().darken(byPercentage: darkening)
        cell.emailLabel?.backgroundColor = FlatMintDark().darken(byPercentage: darkening)
        cell.periodLabel?.backgroundColor = FlatMintDark().darken(byPercentage: darkening)
        cell.nameLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        cell.emailLabel?.font = UIFont.systemFont(ofSize: 12.0)
        cell.periodLabel?.font = UIFont.systemFont(ofSize: 12.0)
        cell.backgroundColor = FlatMintDark().darken(byPercentage: darkening)
        
        return cell
    }
    
    func saveItems() {
        do {
            try self.context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<StalkItem> = StalkItem.fetchRequest()) {
        do {
            tempArray = try self.context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func deleteItem(indexPath: IndexPath) {
        context.delete(tempArray[indexPath.row])
        tempArray.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .fade)
        saveItems()
    }

}

//MARK: - SearchBar methods
extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<StalkItem> = StalkItem.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        loadItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

//MARK: - SwipeCell
//extension MainViewController: SwipeTableViewCellDelegate {
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        guard orientation == .right else { return nil }
//
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//            action.fulfill(with: .delete)
//            self.deleteItem(indexPath: indexPath)
//        }
//
//        deleteAction.image = UIImage(named: "delete")
//
//        return [deleteAction]
//    }
//
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.expansionStyle = .destructive
//        options.transitionStyle = .reveal
//        return options
//    }
//}
