//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Walter Bennett on 3/25/19.
//  Copyright © 2019 Walter Bennett. All rights reserved.
//

import UIKit
import CoreData


class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    // Create an Object of the AppDelegate to access it's viewContext
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }

    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {              // number of rows in tableView
        return categoryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {   // create a cell for each table view row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)    // create a re-usable cell and add it to the index path

        cell.textLabel?.text = categoryArray[indexPath.row].name    // set the text from the data model
        
        return cell
        
    }
    
    // MARK: - TableView Delegate Methods
    // Tells the delegate that the specified row is now selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController    // Create a reference of the destination VC
        
        // Grab the category that corresponds to the selected cell
        if let indexPath = tableView.indexPathForSelectedRow {  // Get the selected cell??
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }

    // MARK: - Add new Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // Show UIAlert control with a Text Field so I can write a quick Todo List Item then append it to the end of my itemArray
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            // What will happen once the user clicks the Add Item button inside the Alert
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            
            self.saveCategories()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Data Manipulation Methods
    func saveCategories() {
        
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        
        // Update tableView DATA
        self.tableView.reloadData()
    }
    
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        // READ data from our Context
        do {
            categoryArray = try context.fetch(request)  // Perform REQUEST
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        // Update tableView Data
        tableView.reloadData()
        
    }
    

    
    
    
    
    
    
    
    

    
}
