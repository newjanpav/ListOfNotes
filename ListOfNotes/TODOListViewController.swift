//
//  TODOListViewController.swift
//  ListOfNotes
//
//  Created by Pavel Shymanski on 16.11.23.
//


import Foundation
import UIKit

protocol PersistenceManager {
    func save(item: TODOListItem)
    func remove(item: TODOListItem)
    func loadAllItems() -> [TODOListItem]?
}



class TODOListViewController: UIViewController {

    @IBOutlet weak var addButton : UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var persistenceManager: PersistenceManager?
    let dataSource = TODOListDataSource()
    var selectedItem: TODOListItem? // Empty for new Item
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performInitialConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStoredItems()
    }
    
    func performInitialConfiguration() {
        persistenceManager = RealmManager()
        tableView.delegate = self
        tableView.dataSource = dataSource
        dataSource.delegate = self
    }
    
    func loadStoredItems() {
        let items = persistenceManager?.loadAllItems()
        dataSource.items = items
        tableView.reloadData()
    }
    
    
    override func prepare(for segue : UIStoryboardSegue, sender: Any?){
        if segue.identifier == "todoDetails" {
            guard let destination = segue.destination as? TODOListItemDetailsViewController else { return }
            destination.currentItem = selectedItem
            destination.delegate = self
        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        selectedItem = TODOListItem(title: "", body: "", lastUpdatedDate: .now, createdDate: .now)
        performSegue(withIdentifier: "todoDetails", sender: self)
    }
}
    

extension TODOListViewController : UITableViewDelegate {
    func tableView( _ tableView: UITableView, didSelectRowAt indePath: IndexPath) {
        guard let item = dataSource.items?[indePath.row] else { return }
        selectedItem = item
        performSegue(withIdentifier: "todoDetails", sender: self)
    }
}


extension TODOListViewController : TODOListItemDetailsDelegate {
    func todoListItemDetailsViewController(_ controller: TODOListItemDetailsViewController, didFinishEditingOfItem item: TODOListItem) {
        if item.body == "" { return }
        
        else { persistenceManager?.save(item: item)
            loadStoredItems() }
    }
}


extension TODOListViewController: TODOListDataSourceDelegate {
    func todoItemDelete(_ controller: TODOListDataSource, indexPath: IndexPath, item: TODOListItem) {
        
        let alertController = UIAlertController(title: "Delete this item?", message:"Are you sure?", preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)
        
        let okAction = UIAlertAction(title: "ok", style: .destructive) { _ in
            alertController.dismiss(animated: true) {
                
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.dataSource.items?.remove(at: indexPath.row)
                self.tableView.endUpdates()
                
                self.persistenceManager?.remove(item: item)
                self.loadStoredItems()
            }
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel) { _ in
            alertController.dismiss(animated: true)
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
    }
}
    

