//
//  AllCommunitesController.swift
//  MH VK Client 1.0
//
//  Created by Vit on 16/09/2019.
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
        allGroupSearch.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        networkService.searchGroups(userId: Session.shared.usedId, search: "А") { result in
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
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    func searchBar(_ allCommunitesSearch: UISearchBar, textDidChange searchText: String) {
        
        
        networkService.searchGroups(userId: Session.shared.usedId, search: searchText) { result in
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
        }

        tableView.reloadData()
        // }
        
        if searchText.count < 1 {
            allGroupSearch.resignFirstResponder()
            search = false
            tableView.reloadData()
        }
        
        //          searchCommunites.groups = myCommunites.groups.filter({$0.name.prefix(searchText.count) == searchText})
        //          seach = true
        //          tableView.reloadData()
        //
        //          if searchText.count < 1 {
        //              myCommunitesSearch.resignFirstResponder()
        //              seach = false
        //              tableView.reloadData()
        //          }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupsCell", for: indexPath) as! GroupCell
        
        //  cell.groupName.text = allCommunites.groups[indexPath.row].name
        //  cell.groupPic?.image = allCommunites.groups[indexPath.row].pic
        
        if search {
            
            cell.configure(witch: searchGroups[indexPath.row])
            //cell.CommunitesName.text = searchCommunites.groups[indexPath.row].name
           // cell.CommunitesPic?.image = searchCommunites.groups[indexPath.row].pic
        } else {
            cell.configure(witch: allGroups[indexPath.row])
           // cell.CommunitesName.text = myCommunites.groups[indexPath.row].name
           // cell.CommunitesPic?.image = myCommunites.groups[indexPath.row].pic
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //tableView.deselectRow(at: indexPath, animated: true)        
        
        
    }
    
}


//    var allCommunites =  Group(groups: [("Общество", UIImage(named: "communites01")), ("Социум", UIImage(named: "communites02")), ("Люди в черном", UIImage(named: "communites03")), ("Физика и мы", UIImage(named: "communites04")), ("Братья и сёстры", UIImage(named: "communites05")), ("Работа мозга", UIImage(named: "communites06")), ("Рука руку моет", UIImage(named: "communites07")), ("Семья и отношения", UIImage(named: "communites08")), ("Офисный планктон", UIImage(named: "communites09")), ("Гранит науки", UIImage(named: "communites10"))])
