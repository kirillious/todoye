//
//  CategoreViewControllerTableViewController.swift
//  Todoey
//
//  Created by Kirill on 09.01.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoreViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categories: [Categories] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()

    }
    
    
    @IBAction func addCategoryButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { [self] (action) in
            //  what will happen if we press Add Item button on our UIAlert
            
            let newCategory = Categories(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            
            saveCategories()
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }


    //MARK: - Data Manipulation Methods
    
    func saveCategories() {

        do {
            try context.save()
        } catch {
            print("Error with saving context \(error)")
        }
    }

    func loadCategories(with request: NSFetchRequest<Categories> = Categories.fetchRequest() ) {
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error during fetching data \(error)")
        }

        tableView.reloadData()

    }
    

    //MARK: - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoViewController
        
        let indexPath = tableView.indexPathForSelectedRow
        destinationVC.selectedCategory = categories[indexPath!.row]
        
    }


    // MARK: - Tableview datasource methods


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
        
    }
}
