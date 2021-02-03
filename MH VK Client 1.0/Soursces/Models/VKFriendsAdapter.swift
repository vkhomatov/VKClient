//
//  VKFriendsAdapter.swift
//  MH VK Client 1.0
//
//  Created by Vitaly Khomatov on 19.05.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import Foundation
import RealmSwift
import PromiseKit


class VKFriendsAdapter {
    
    private let networkService = NetworkService(token: Session.shared.accessToken)
    private let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    private lazy var friendsVK: Results<FriendVK> = try! Realm(configuration: deleteIfMigration).objects(FriendVK.self)//.sorted(byKeyPath: "lastName")
    var friendsToken: NotificationToken?
    
    var mySortFriends = [FriendVK]()
    var searchFriend = [FriendVK]()
    var alfGroupsFriends = [[FriendVK]]()
    var friendsAlf = [Character]()
    
   // weak var friendsController: FriendsController?
    
    
    func GetFriendsFromRealm(table: UITableView?) {
        
        //  загружаем друзей из базы если в существующей базе есть друзья
        if friendsVK.count > 0 {
            guard let tableView = table else { return }
            
            FriendSetup()
            print("ДРУЗЬЯ ЗАГРУЖЕНЫ ИЗ БАЗЫ")
            tableView.reloadData()
        }
        
        //загрузка друзей из сети с помощью Promises
        networkService.loadFriendsPr()
            .done  { friends in
                guard let realm = try? Realm(configuration: self.deleteIfMigration) else { fatalError() }
                print("Realm \(String(describing: self.deleteIfMigration.fileURL!))" )
                try? realm.write { realm.add(friends, update: .all) }
        }.catch { error in
            // show(error as! UIViewController, sender: Any?.self) //у меня только вот так error работает, почему?
            print("ОШИБКА ЗАГРУЗКИ СПИСКА ДРУЗЕЙ: \(error)")
            
        }
    }
    
    func SetRealmObserver(table: UITableView?) {
        
        //ставим observer на БД
        friendsToken = friendsVK.observe { [weak self] (changes:RealmCollectionChange) in
            guard let tableView = table else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update:
                guard let self = self else { return }
                print("ОБНОВЛЕНИЕ ДАННЫХ В РЕАЛМ ДРУЗЬЯ")
                self.FriendSetup()
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            case .error(let error):
                fatalError("\(error)")
            }
        }
        
    }
    
    
    func FriendSetup() {
        
        alfGroupsFriends.removeAll()
        //получение алфавита из первых букв фамилий друзей
        var set = Set<Character>()
        mySortFriends = friendsVK.sorted(by: <)
        friendsAlf = mySortFriends
            .compactMap{ $0.lastName.first }
            .filter { set.insert($0).inserted }
        
        //сортировка друзей по алфавиту и создания массива групп из отсортированных друзей для отображения секций таблицы
        for i in (0..<friendsAlf.count) {
            let friendGroup = mySortFriends.filter({$0.lastName.first == friendsAlf[i]})
            if friendGroup.count > 0 {
                alfGroupsFriends.append(friendGroup)
            }
        }
        
    }
        
}
