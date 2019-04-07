//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Walter Bennett on 3/25/19.
//  Copyright © 2019 Walter Bennett. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
    
    // Initialize a NEW access point to our REALM db
    let realm = try! Realm()
    
    // Collection of Results that are Category OBJECTS
    var categories: Results<Category>?
    
    // viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        // Remove the separator lines between tableView cells
        tableView.separatorStyle = .none
        
        // Check if navigationBar exists otherwise throw fatalError
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
        
        // NavBar - largeTitleTextAttributes
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : FlatWhite()]
    }
    


    // MARK: - TableView Datasource Methods
    // numberOfRowsInSection - Tells the delegate how many rows are contained in the section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1   // IF there's NO categories yet, then return 1 cell
    }
    
    // cellForRowAt - Populates and Defines the tableView cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create a re-usable cell - From the SUPER class and add it to the index path
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        // Retrieve category values stored in db
        if let category = categories?[indexPath.row] {
            
            // 1. Cell Text Data
            cell.textLabel?.text = category.name

            guard let categoryColor = UIColor(hexString: category.color) else {fatalError()}
            // 2. Cell Background Color
            cell.backgroundColor = categoryColor
            // 3. Cell Text Color
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    // didSelectRowAt - Tells the delegate that the specified row is now selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self) // Takes us to the TodoListViewController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Create a NEW instance of the destination VC
        let destinationVC = segue.destination as! TodoListViewController
        
        // Grab the category that corresponds to the selected cell
        if let indexPath = tableView.indexPathForSelectedRow {  // Get the selected cell??
            destinationVC.selectedCategory = categories?[indexPath.row] // This is the category cell that was clicked
        }
    }
    
    // MARK: - Data Manipulation Methods
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
 
        self.tableView.reloadData() // Update tableView DATA
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)   // Fetch all the data in the Category datatype

        tableView.reloadData()  // Update tableView Data - CALL ALL the DATASOURCE METHODS
        
    }
    
    // MARK: - Delete Data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {   // Grab the item at the current selected indexPath.row
            do {
                try self.realm.write {                   // Save updates/changes
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }

    // MARK: - Add new Categories - CRUD (C - Create)
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Show UIAlert control with a Text Field so I can write a quick Todo List Item
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            // What will happen once the user clicks the Add Item button inside the Alert
            let newCategory = Category()    // CREATE a new Category OBJECT
            newCategory.name = textField.text!  // Name the OBJECT based on what the user typed in the textField
            newCategory.color = UIColor.randomFlat.hexValue()   // Assign a random color to persist
            
            self.save(category: newCategory)    // CALL the SAVE method
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}
