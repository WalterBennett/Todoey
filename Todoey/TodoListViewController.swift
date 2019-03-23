//
//  ViewController.swift
//  Todoey
//
//  Created by Walter Bennett on 3/21/19.
//  Copyright © 2019 Walter Bennett. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Synchronize the itemArray with latest data
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }

    }
    
    //MARK - Tableview Datasource Methods
    
    // number of rows in table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    // create a cell for each table view row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        // set the text from the data model
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    // number of sections in table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK - TableView Delegate Methods
    
    // Tells the delegate that the specified row is now selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            
            // Remove checkmark if cell that has one is selected again
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            
            // Add a checkmark whenever a cell gets selected
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        // Deselect the row so it doesn't stay highlighted
        tableView.deselectRow(at: indexPath, animated: true)
   
    }
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Show UIAlert control with a Text Field so I can write a quick Todo List Item then append it to the end of my itemArray
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks the Add Item button on our UIAlert
            self.itemArray.append(textField.text!)
            
            // Save the UPDATED itemsArray to our User Defaults
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            // Update tableview DATA
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    


}

