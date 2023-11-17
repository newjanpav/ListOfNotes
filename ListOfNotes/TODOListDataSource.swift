//
//  TODOListDataSource.swift
//  ListOfNotes
//
//  Created by Pavel Shymanski on 16.11.23.
//
import Foundation
import UIKit

protocol TODOListDataSourceDelegate: AnyObject {
    func todoItemDelete(_ controller: TODOListDataSource, indexPath:IndexPath, item: TODOListItem)
}

class TODOListDataSource : NSObject, UITableViewDataSource{
    var items: [TODOListItem]?
    var delegate: TODOListDataSourceDelegate?
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let items = items else {return UITableViewCell() }
        
        let id = "default"
        let cell: UITableViewCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: id) {
            cell = reuseCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: id)
        }
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let item = items?[indexPath.row] else { return }
        delegate?.todoItemDelete(self,indexPath: indexPath, item: item)
    }
}
