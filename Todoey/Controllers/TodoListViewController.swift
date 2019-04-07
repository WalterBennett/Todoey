//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Walter Bennett on 3/21/19.
//  Copyright © 2019 Walter Bennett. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    
    let realm = try! Realm()
    
    var todoItems : Results<Item>?  // Collection of Results that are Item OBJECTS
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // Receive category Data from Segue here
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Remove the separator lines between tableView cells
        tableView.separatorStyle = .none
    }
    
    // viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
        // Modify navigationBar items
        
        // Modify the tableView title
        title = selectedCategory?.name
        
        guard let colorHex = selectedCategory?.color else {fatalError("Category doesn't contain a color")}
        
        updateNavBar(withHexCode: colorHex)
        
  
    }
    
    // viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexCode: "1D9BF6")
        
    }
    
    // MARK: - Nav Bar Setup Methods
    func updateNavBar(withHexCode colorHexCode : String) {
        
        // Check if navigationBar exists otherwise throw fatalError
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
        
        // IF data exists in selectedCategory.color then do this
        guard let navBarColor = UIColor(hexString: colorHexCode) else {fatalError("Selected Category doesn't contain a color")}

        // NavBar - barTintColor
        navBar.barTintColor = navBarColor
        
        // NavBar - tintColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        // NavBar - largeTitleTextAttributes
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
        // SearchBar - barTintColor
        searchBar.barTintColor = navBarColor
    }
    
    //MARK - Tableview Datasource Methods
    // numberOfRowsInSection - Tells the delegate how many rows are contained in the section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    // cellForRowAt - Populates and Defines the tableView cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create Reusable cell
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        // Modify the cell
        if let item = todoItems?[indexPath.row] {
            
            // Modify the cell text using db data
            cell.textLabel?.text = item.title
            
            // Modify the cell colors - Based on the current index path
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                // Modify the cell background color
                cell.backgroundColor = color
                
                // Modify the cell text color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            // Ternary operator ==>
            // value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }

        return cell
        
    }
    
    //MARK - TableView Delegate Methods
    // Tells the delegate that the specified row is now selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // UPDATE the Selected cell inside our tableView to Checkmark or Uncheckmark
        if let item = todoItems?[indexPath.row] {   // Grab the item at the current selected indexPath.row
            do {
                try realm.write {                   // Save updates/changes
//                    realm.delete(item)
                    item.done = !item.done          // Toggle checkmarlk property
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        // Deselect the row so it doesn't stay highlighted
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Show UIAlert control with a Text Field so I can write a quick Todo List Item then append it to the end of my itemArray
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // This happen once the user clicks the Add Item button on our UIAlert
            if let currentCategory = self.selectedCategory { // Check if Data exists in selectedCategory
                do {
                    try self.realm.write {                      // Save all Changes/Updates
                        let newItem = Item()                    // Create a "newItem" Object
                        newItem.title = textField.text!         // Update the Object's title property
                        newItem.dateCreated = Date()            // Update the Object's dateCreated property
                        currentCategory.items.append(newItem)   // Append "newItem" Object to the "currentCategory" array
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            
            self.tableView.reloadData()

        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)

    }
    
    //MARK - Model Manipulation Methods
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
        
    }
    
    // MARK: - Delete Data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.todoItems?[indexPath.row] {  // Grab a Reference to the item at the particular indexPath.row
            do {
                try self.realm.write {                  // Save updates/changes
                    self.realm.delete(item)             // Mark item for deletion
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
}

// MARK: - Search bar methods
extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Query the todoItems ARRAY using an NSPredicate as a Filter ("title CONTAINS[cd] %@")
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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

