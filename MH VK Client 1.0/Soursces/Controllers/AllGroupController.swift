//
//  AllCommunitesController.swift
//  MH VK Client 1.0
//
//  Created by Vitaly Khomatov on 16/09/2019.
//  Copyright © 2019 Macrohard. All rights reserved.
//

import UIKit

class AllGroupController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var allGroupSearch: UISearchBar!
    
    private let networkService = NetworkService(token: Session.shared.accessToken)
    var allGroups = [GroupVK]()
    var searchGroups = [GroupVK]()
    
    var search: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   self.view.backgroundColor = .mainColor

        allGroupSearch.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        allGroupSearch.placeholder = "Search"
        
        
        DispatchQueue.global().async {
            
            self.networkService.searchGroups(userId: Session.shared.usedId, search: "А") { result in
                switch result {
                case let .success(groups):
                    self.allGroups = groups
                    guard !groups.isEmpty else { return }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case let .failure(error):
                    print(error)
                }
            }
            
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    func searchBar(_ allCommunitesSearch: UISearchBar, textDidChange searchText: String) {
        
        //  DispatchQueue.global().async {
        
        self.networkService.searchGroups(userId: Session.shared.usedId, search: searchText) { result in
            switch result {
            case let .success(groups):
                self.searchGroups = groups
                guard !groups.isEmpty else { return }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.search = true
                
            case let .failure(error):
                print(error)
            }
            //     }
        }
        
        if searchText.count < 1 {
            allGroupSearch.resignFirstResponder()
            search = false
            tableView.reloadData()
        }
        
        tableView.reloadData()
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellZero = UITableViewCell()
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupsCell", for: indexPath) as! GroupCell
        
        if search {
            
            //            if searchGroups.count > 0 && indexPath.row > 0 {
           // print("searchGroups.count : \(searchGroups.count)")
           // print("indexPath.row : \(indexPath.row)")
            
            if searchGroups.count > indexPath.row {
                cell.configure(witch: searchGroups[indexPath.row])
            } else  {
                return cellZero
            }
            //   } //else {
            //     print("Неуспеваю загрузить: \(searchGroups.count)") }
            
        } else {
            cell.configure(witch: allGroups[indexPath.row])
            
        }
        
        return cell
    }
    
    
}
