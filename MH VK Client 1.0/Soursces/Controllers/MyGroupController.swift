//
//  MyCommunitesController.swift
//  MH VK Client 1.0
//
//  Created by Vitaly Khomatov on 16/09/2019.
//  Copyright © 2019 Macrohard. All rights reserved.
//

import UIKit

class MyGroupController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var myGroupSearch: UISearchBar!
    
    private var groupsVK = [GroupVK]()
    private let networkService = NetworkService(token: Session.shared.accessToken)
    var searchGroups = [GroupVK]()
    var seach: Bool = false
    
    @IBAction func returnToMyCommunites(unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier == "addGroups" {
            
            guard let allCommunitesController = unwindSegue.source as? AllGroupController else { return }
            guard let indexPath = allCommunitesController.tableView.indexPathForSelectedRow else { return }
            
            var group = allCommunitesController.allGroups[indexPath.row]
            
            if allCommunitesController.search {
                group = allCommunitesController.searchGroups[indexPath.row] }
            
            if !groupsVK.contains(where: { $0.name == group.name }) {
                groupsVK.insert(group, at: 0)
                tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myGroupSearch.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        myGroupSearch.placeholder = "Search"

        
        DispatchQueue.global().async {

            self.networkService.loadGroups(userId: Session.shared.usedId) { result in
            switch result {
            case let .success(groups):
                self.groupsVK = groups
                guard !groups.isEmpty else { return }
                //self.searchBarFilter(search: nil)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case let .failure(error):
                print(error)
            }
        }
        }
        
    }
    
    
    func searchBar(_ myCommunitesSearch: UISearchBar, textDidChange searchText: String) {
        
        //  searchCommunites.groups = myCommunites.groups.filter({$0.name.prefix(searchText.count) == searchText})
        searchGroups = groupsVK.filter({$0.name.prefix(searchText.count) == searchText})
        seach = true
        tableView.reloadData()
        
        if searchText.count < 1 {
            myGroupSearch.resignFirstResponder()
            seach = false
            tableView.reloadData()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if seach {
            return searchGroups.count
        } else {
            return groupsVK.count
            
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupsCell", for: indexPath) as! GroupCell
        
        if seach {
            
            cell.configure(witch: searchGroups[indexPath.row])
            
        } else {
            cell.configure(witch: groupsVK[indexPath.row])
            
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if seach {
                let delName = searchGroups[indexPath.row]
                searchGroups.remove(at: indexPath.row)
                
                var i : Int = 0
                for name in groupsVK {
                    if name == delName {
                        groupsVK.remove(at: i)
                    }
                    i += 1
                }
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                groupsVK.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    
    
}
