//
//  FriendsController.swift
//  MH VK Client 1.0
//
//  Created by Vitaly Khomatov on 16/09/2019.
//  Copyright © 2019 Macrohard. All rights reserved.
//

import UIKit
//import RealmSwift
//import PromiseKit



class FriendsController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var frendsSearch: UISearchBar!
  //  private let networkService = NetworkService(token: Session.shared.accessToken)
    
  //  private var searchFriend = [FriendVK]()
  //  private var mySortFriends = [FriendVK]()
  //  private var alfGroupsFriends = [[FriendVK]]()
 //   private var friendsAlf = [Character]()
    
    private var vkFriendsAdapter = VKFriendsAdapter()
    

    private let viewModelFactory = FriendViewModelFactory()
    private var searchViewModels: [FriendViewModel] = []
    private var noSearchViewModels: [[FriendViewModel]] = []


    
    private var seach: Bool = false
  //  let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
  //  var friendsToken: NotificationToken?
    
    //пытаемся загрузить данные из базы
  //  private lazy var friendsVK: Results<FriendVK> = try! Realm(configuration: deleteIfMigration).objects(FriendVK.self)//.sorted(byKeyPath: "lastName")
    
    // распределение друзей в группы по первой букве фамилии
//    func FriendSetup() {
//        self.alfGroupsFriends.removeAll()
//
//        //получение алфавита из первых букв фамилий друзей
//        self.mySortFriends = self.friendsVK.sorted(by: <)
//        var set = Set<Character>()
//        self.friendsAlf = self.mySortFriends
//            .compactMap{ $0.lastName.first }
//            .filter { set.insert($0).inserted }
//
//        //сортировка друзей по алфавиту и создания массива групп из отсортированных друзей для отображения секций таблицы
//        for i in (0..<self.friendsAlf.count) {
//            let friendGroup = self.mySortFriends.filter({$0.lastName.first == self.friendsAlf[i]})
//            if friendGroup.count > 0 {
//                self.alfGroupsFriends.append(friendGroup)
//            }
//        }
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frendsSearch.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        frendsSearch.placeholder = "Search"
        
        //  загружаем друзей из базы если в существующей базе есть друзья
        if vkFriendsAdapter.alfGroupsFriends .count > 0 {
            vkFriendsAdapter.FriendSetup()
            print("ДРУЗЬЯ ЗАГРУЖЕНЫ ИЗ БАЗЫ")
            tableView.reloadData()
        }
        
        //загрузка друзей из сети с помощью Promises
        vkFriendsAdapter.GetFriendsFromRealm(table: self.tableView)
        
//        networkService.loadFriendsPr()
//            .done  { friends in
//                guard let realm = try? Realm(configuration: self.deleteIfMigration) else { fatalError() }
//                print("Realm \(String(describing: self.deleteIfMigration.fileURL!))" )
//                try? realm.write { realm.add(friends, update: .all) }
//        }.catch { error in
//            self.show(error as! UIViewController, sender: Any?.self) //у меня только вот так error работает, почему?
//            print("ОШИБКА ЗАГРУЗКИ СПИСКА ДРУЗЕЙ")
//
//        }
        
        //ставим observer на БД
        vkFriendsAdapter.SetRealmObserver(table: self.tableView)
//        self.friendsToken = vkFriendsAdapter.friendsVK.observe { [weak self] (changes:RealmCollectionChange) in
//            guard let tableView = self?.tableView else { return }
//            switch changes {
//            case .initial:
//                tableView.reloadData()
//            case .update:
//                guard let self = self else { return }
//                print("ОБНОВЛЕНИЕ ДАННЫХ В РЕАЛМ ДРУЗЬЯ")
//                self.vkFriendsAdapter.FriendSetup()
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            case .error(let error):
//                fatalError("\(error)")
//            }
//        }
        
      //  self.viewModels = self.viewModelFactory.constructViewModels(from: vkFriendsAdapter.mySortFriends)

    }
    
    deinit {
        vkFriendsAdapter.friendsToken?.invalidate()
    }
    
    
    // MARK: - SerchBar
    func searchBar(_ frendsSearch: UISearchBar, textDidChange searchText: String) {
        
        vkFriendsAdapter.searchFriend =  vkFriendsAdapter.mySortFriends.filter({$0.lastName.prefix(searchText.count) == searchText})
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
            return vkFriendsAdapter.alfGroupsFriends.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if seach {
            return "" } else {
             
              //  print("section = \(section)")
               return String(vkFriendsAdapter.friendsAlf[section]) }
        }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if seach {
            self.searchViewModels = self.viewModelFactory.constructSearchViewModels(from: vkFriendsAdapter.searchFriend)

            return vkFriendsAdapter.searchFriend.count } else {
            self.noSearchViewModels = self.viewModelFactory.constructNoSearchViewModels(from: vkFriendsAdapter.alfGroupsFriends)

            return vkFriendsAdapter.alfGroupsFriends[section].count
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.tintColor = .mainColor
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath) as! FriendsCell
        
        var blockCell = false
        
        if seach {
           // cell.configure(witch: vkFriendsAdapter.searchFriend[indexPath.row])
            cell.configure(with: searchViewModels[indexPath.row])
            if vkFriendsAdapter.searchFriend[indexPath.row].deactivated != "" {
                blockCell = true }
        } else {
            //cell.configure(witch: vkFriendsAdapter.alfGroupsFriends[indexPath.section][indexPath.row])
            cell.configure(with: noSearchViewModels[indexPath.section][indexPath.row])
            if vkFriendsAdapter.alfGroupsFriends[indexPath.section][indexPath.row].deactivated != "" {
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
                friendsProfileController.activeFriend = friendsController.vkFriendsAdapter.searchFriend[indexPath.row]
            } else {
                friendsProfileController.activeFriend = friendsController.vkFriendsAdapter.alfGroupsFriends[indexPath.section][indexPath.row]}
        }
    }
    
}










//загрузка друзей из сети с помощью DispatchQueue

//    DispatchQueue.global().async { // ВОТ ТАК ВСЕ РАБОТАЕТ БЕЗ ОШИБОК
//
//        self.networkService.loadFriends() { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case let .success(friendsVK):
//                guard !friendsVK.isEmpty else {
//                    print("НЕ УДАЛОСЬ ЗАГРУЗИТЬ СПИСОК ДРУЗЕЙ")
//                    return }
//
//                // КАК ТОЛЬКО СТАВЛЮ ЗДЕСЬ ОЧЕРЕДЬ ВОЗНИКАЕТ ОШИБКА ПОТОКА ДЛЯ РЕАЛМ !!!!!!!!!!
//                //   DispatchQueue.global().async {
//                guard let realm = try? Realm(configuration: self.deleteIfMigration) else { fatalError() }
//                print("Realm \(String(describing: self.deleteIfMigration.fileURL!))" )
//                try? realm.write {
//                    realm.add(friendsVK, update: .all)
//                }
//
//                //считываем данные из БД
//                self.friendsVK = try! Realm(configuration: self.deleteIfMigration).objects(FriendVK.self)
//                //    }
//
//            case let .failure(error):
//                print("ОШИБКА ЗАГРУЗКИ СПИСКА ДРУЗЕЙ: \(error)")
//            }
//        }
//        }
//




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


