//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ToDoViewController: UITableViewController {
    
    var itemsArray = [DataModel]()
    var selectedCategory: Categories? {
        didSet {
            loadItems()
        }
    }
    
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)

        loadItems()
        
//        if let itemArray = defaults.array(forKey: "ToDoListArray") as? [DataModel] {
//            itemsArray = itemArray
//        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemsArray[indexPath.row].title
        
        cell.accessoryType = itemsArray[indexPath.row].done == true ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemsArray[indexPath.row].done = !itemsArray[indexPath.row].done
        

        tableView.reloadData()
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    

    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add new to do item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { [self] (action) in
            //  what will happen if we press Add Item button on our UIAlert
            
//            !!!!!!!!!!!!!
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            let newItem = DataModel(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = selectedCategory
            self.itemsArray.append(newItem)
            
            self.tableView.reloadData()
        }
         
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    
    }
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error with saving context \(error)")
        }
    }
    
    func loadItems(with request: NSFetchRequest<DataModel> = DataModel.fetchRequest(), predicate: NSPredicate? = nil) {
        
        print("MARK")
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        print("MARK")
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
//        request.predicate = compoundPredicate
        
        
        do {
            itemsArray = try context.fetch(request)
        } catch {
            print("Error during fetching data \(error)")
        }
        
        tableView.reloadData()
        
    }

}

extension ToDoViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<DataModel> = DataModel.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
                
        loadItems(with: request, predicate: predicate)
                
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
        
                searchBar.resignFirstResponder()
                
            }
            
        }
    }
    
    
    
    
}



