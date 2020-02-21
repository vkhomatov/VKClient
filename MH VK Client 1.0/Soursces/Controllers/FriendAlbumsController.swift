//
//  FriendProfileController.swift
//  MH VK Client 1.0
//
//  Created by Vit on 16/09/2019.
//  Copyright © 2019 Macrohard. All rights reserved.
//

import UIKit
import RealmSwift

class FriendAlbumsController: UICollectionViewController {
    
    private let networkService = NetworkService(token: Session.shared.accessToken)
    var activeFriend = FriendVK()
    var activeAlbum = FriendAlbum()
    
    var albumsToken: NotificationToken?

    
    //чтение списка альбомов выбранного друга из базы
    private lazy var albumsFromRealm: Results<FriendAlbum> = try! Realm(configuration: RealmService.deleteIfMigration).objects(FriendAlbum.self).filter("ownerId == %@", activeFriend.id)
    
    
    
//    func pairTableAndRealm() {
//          //  guard let realm = try? Realm() else { return }
//          //  friends = realm.objects(FriendVK.self)
//            albumsToken = self.albumsFromRealm.observe { [weak self] (changes:RealmCollectionChange) in
//                guard let collectionView = self?.collectionView else { return }
//                switch changes {
//                case .initial:
//                    collectionView.reloadData()
//                case .update(_, let deletion, let insertion, let modification):
//                    print("ОБНОВЛЕНИЕ ДАННЫХ В РЕАЛМ")
//                    //collectionView.be
//                    collectionView.insertRows(at: insertion.map({_ in IndexPath(row: 0, section: 0)}) , with: .automatic)
//                    collectionView.deleteRows(at: deletion.map({_ in IndexPath(row: 0, section: 0)}) , with: .automatic)
//                    collectionView.reloadRows(at: modification.map({_ in IndexPath(row: 0, section: 0)}) , with: .automatic)
//                   // collectionView.endUpdates()
//                case .error(let error):
//                    fatalError("\(error)")
//                }
//            }
//        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //загрузка списка альбомов выбранного друга из VK
        networkService.getFriendAlbums(userId: activeFriend.id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(friendAlbumsVK):
                
                guard !friendAlbumsVK.isEmpty else {
                    print("НЕ УДАЛОСЬ ЗАГРУЗИТЬ СПИСОК АЛЬБОМОВ ДРУГА: \(self.activeFriend.fullName)")
                    return }
                
                //удаляем старые записи об альбомах друга из базы и записываем полученные из VK
                guard let realm = try? Realm(configuration: RealmService.deleteIfMigration) else { fatalError() }
                guard let friendVK = realm.object(ofType: FriendVK.self, forPrimaryKey: self.activeFriend.id) else {
                    print("НЕ МОГУ ПОЛУЧИТЬ ОБЪЕКТ ДРУГ: \(self.activeFriend.fullName) ИЗ БД")
                    return }
                try? realm.write {
                    if self.albumsFromRealm.count > 0 {
                        realm.delete(self.albumsFromRealm) }
                    friendVK.albums.append(objectsIn: friendAlbumsVK)
                    
                }
                
               
                
//                DispatchQueue.main.async {
//                    self.collectionView.reloadData()
//                }
//
               
            case let .failure(error):
                print("ОШИБКА ПОЛУЧЕНИЕ СПИСКА АЛЬБОМОВ ИЗ VK \(error)")
            }
        }
        
        //ставим observer на БД
                       self.albumsToken = self.albumsFromRealm.observe { [weak self] (changes:RealmCollectionChange) in
                                       guard let collectionView = self?.collectionView else { return }
                                       switch changes {
                                       case .initial:
                                           collectionView.reloadData()
                                       case .update://(_, let deletion, let insertion, let modification):
                                           
                                           guard let self = self else { return }
                                           print("ОБНОВЛЕНИЕ ДАННЫХ В РЕАЛМ АЛЬБОМЫ")
                                           
                                           //self!.friendsVK = try! Realm(configuration: RealmService.deleteIfMigration).objects(FriendVK.self)
                                           // сохраняем в память новую версию данных из БД
                                          // self.mySortFriends = self.friendsVK.sorted(by: <)
                                          // self.mySortFriends = friends
                                           
                                          // self.FriendSetup()
                                           
                    //считываем данные из базы для размещения во вью
                                   self.albumsFromRealm = try! Realm(configuration: RealmService.deleteIfMigration).objects(FriendAlbum.self).filter("ownerId == %@", self.activeFriend.id)
                                           
                                           self.collectionView.reloadData()
                                                       
                                       case .error(let error):
                                           fatalError("\(error)")
                                       }
                       }
                       
        
    }
    
    
    deinit {
           albumsToken?.invalidate()
       }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumsFromRealm.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendProfileCell", for: indexPath) as! FriendAlbumCell
        cell.configure(witch: albumsFromRealm[indexPath.row])
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "FriendAlbumPhotosView" {
            
            guard let friendsProfileController = segue.source as? FriendAlbumsController else { return }
            guard let friendPhotosViewController = segue.destination as? FriendPhotosController else { return }
            guard let selectedIndexPaths = friendsProfileController.collectionView.indexPathsForSelectedItems else { return }
            guard let selectedIndexPath = selectedIndexPaths.first else { return }
            
            friendPhotosViewController.activeFriend = self.activeFriend
            friendPhotosViewController.activeAlbum = albumsFromRealm[selectedIndexPath.row]
            
        }
    }
    
}
