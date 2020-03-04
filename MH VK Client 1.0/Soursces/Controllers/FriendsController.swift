//
//  FriendsController.swift
//  MH VK Client 1.0
//
//  Created by Vit on 16/09/2019.
//  Copyright © 2019 Macrohard. All rights reserved.
//

import UIKit
import RealmSwift


class FriendsController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var frendsSearch: UISearchBar!
    
    private let networkService = NetworkService(token: Session.shared.accessToken)
    private var searchFriend = [FriendVK]()
    private var mySortFriends = [FriendVK]()
    private var alfGroupsFriends = [[FriendVK]]()
    private var friendsAlf = [Character]()
    private var seach: Bool = false
    
    var friendsToken: NotificationToken?
    // var friends: Results<FriendVK>?
    
    //пытаемся загрузить данные из базы
    private lazy var friendsVK: Results<FriendVK> = try! Realm(configuration: RealmService.deleteIfMigration).objects(FriendVK.self)//.sorted(byKeyPath: "lastName")
    
    // распределение друзей в группы по первой букве фамилии
    func FriendSetup()
    {
        
        self.alfGroupsFriends.removeAll()
        //получение алфавита из первых букв фамилий друзей
        self.mySortFriends = self.friendsVK.sorted(by: <)
        
        var set = Set<Character>()
        self.friendsAlf = self.mySortFriends
            .compactMap{ $0.lastName.first }
            .filter { set.insert($0).inserted }
        
        // print(self.friendsAlf)
        
        //сортировка друзей по алфавиту и создания массива из групп из отсортированных друзей для отображения секций таблицы
        for i in (0..<self.friendsAlf.count) {
            let friendGroup = self.mySortFriends.filter({$0.lastName.first == self.friendsAlf[i]})
            if friendGroup.count > 0 {
                self.alfGroupsFriends.append(friendGroup)
            }
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frendsSearch.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        //pairTableAndRealm()
        
        //  print("Список загруженных из базы друзей: \(friendsVK)")
        
        //загрузка списка друзей из VK
        networkService.loadFriends() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(friendsVK):
                guard !friendsVK.isEmpty else {
                    print("НЕ УДАЛОСЬ ЗАГРУЗИТЬ СПИСОК ДРУЗЕЙ")
                    return }
                
                //сортировка друзей по алфавиту
                // self.mySortFriends = friendsVK.sorted(by: <)
                
                //сохранение друзей в Realm, удаляем старую базу и создаем новую
                try? RealmService.save(items: friendsVK, configuration: RealmService.deleteIfMigration, update: .all)
                
                //считываем данные из БД
                self.friendsVK = try! Realm(configuration: RealmService.deleteIfMigration).objects(FriendVK.self)
                
            case let .failure(error):
                print("ОШИБКА ЗАГРУЗКИ СПИСКА ДРУЗЕЙ: \(error)")
            }
        }
        
        
        //ставим observer на БД
        friendsToken = self.friendsVK.observe { [weak self] (changes:RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update:
                
                guard let self = self else { return }
                print("ОБНОВЛЕНИЕ ДАННЫХ В РЕАЛМ ДРУЗЬЯ")
                
                self.FriendSetup()
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                //self.tableView.reloadData()
                
            case .error(let error):
                fatalError("\(error)")
            }
        }
        
    }
    
    
    deinit {
        friendsToken?.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - SerchBar
    
    func searchBar(_ frendsSearch: UISearchBar, textDidChange searchText: String) {
        
        searchFriend =  mySortFriends.filter({$0.lastName.prefix(searchText.count) == searchText})
        seach = true
        tableView.reloadData()
        
        if searchText.count < 1 {
            frendsSearch.resignFirstResponder()
            seach = false
            tableView.reloadData()
        }
        
    }
    
    
    // MARK: - Tableview data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if seach {
            return 1
        }  else {
            return alfGroupsFriends.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if seach {
            return ""
        }  else {
            //print("NUMBER OF SECTION: \(section)")
            
            return String(friendsAlf[section])
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if seach {
            return searchFriend.count
        }else {
            return alfGroupsFriends[section].count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath) as! FriendsCell
        
        var blockCell = false
        
        if seach {
            cell.configure(witch: searchFriend[indexPath.row])
            if searchFriend[indexPath.row].deactivated != "" {
                // print("ДРУГ ЗАБЛОКИРОВАН ИЛИ УДАЛЕН: \(searchFriend[indexPath.row].deactivated)")
                blockCell = true }
        } else {
            cell.configure(witch: alfGroupsFriends[indexPath.section][indexPath.row])
            if alfGroupsFriends[indexPath.section][indexPath.row].deactivated != "" {
                // print("ДРУГ ЗАБЛОКИРОВАН ИЛИ УДАЛЕН: \(alfGroupsFriends[indexPath.section][indexPath.row].deactivated)")
                blockCell = true }
        }
        
        if blockCell == true {
            cell.isUserInteractionEnabled = false
            cell.friendName.textColor = .gray
        }
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showFriendAlbums" {
            
            guard let friendsController = segue.source as? FriendsController else { return }
            guard let friendsProfileController = segue.destination as? FriendAlbumsController else { return }
            guard let indexPath = friendsController.tableView.indexPathForSelectedRow else { return }
            
            if seach {
                friendsProfileController.activeFriend = friendsController.searchFriend[indexPath.row]
            } else {
                friendsProfileController.activeFriend = friendsController.alfGroupsFriends[indexPath.section][indexPath.row]}
        }
    }
    
}

//extension UIApplication {
//
//    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
//
//        if let nav = base as? UINavigationController {
//            return getTopViewController(base: nav.visibleViewController)
//
//        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
//            return getTopViewController(base: selected)
//
//        } else if let presented = base?.presentedViewController {
//            return getTopViewController(base: presented)
//        }
//        return base
//    }
//}
