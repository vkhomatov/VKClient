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
    
    let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    
    //чтение списка альбомов выбранного друга из базы
    private lazy var albumsFromRealm: Results<FriendAlbum> = try! Realm(configuration: deleteIfMigration).objects(FriendAlbum.self).filter("ownerId == %@", activeFriend.id)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //  загружаем альбомы из базы, если в существующей базе есть друзья
             if albumsFromRealm.count > 0 {
                 print("АЛЬБОМЫ ЗАГРУЖЕНЫ ИЗ БАЗЫ")
                 collectionView.reloadData()
             }
        
        
        //загрузка списка альбомов выбранного друга из VK
        self.networkService.getFriendAlbums(userId: self.activeFriend.id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(friendAlbumsVK):
                
                guard !friendAlbumsVK.isEmpty else {
                    print("НЕ УДАЛОСЬ ЗАГРУЗИТЬ СПИСОК АЛЬБОМОВ ДРУГА: \(self.activeFriend.fullName)")
                    return }
                
                //  DispatchQueue.main.async {
                
                //удаляем старые записи об альбомах друга из базы и записываем полученные из VK
                guard let realm = try? Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true)) else { fatalError() }
                
                guard let friendVK = realm.object(ofType: FriendVK.self, forPrimaryKey: self.activeFriend.id) else {
                    print("НЕ МОГУ ПОЛУЧИТЬ ОБЪЕКТ ДРУГ: \(self.activeFriend.fullName) ИЗ БД")
                    return }
                try? realm.write {
                    if self.albumsFromRealm.count > 0 {
                        realm.delete(self.albumsFromRealm) }
                    friendVK.albums.append(objectsIn: friendAlbumsVK)
                    
                }
                //    }
                
                
            case let .failure(error):
                print("ОШИБКА ПОЛУЧЕНИЕ СПИСКА АЛЬБОМОВ ИЗ VK \(error)")
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
                    
                    //считываем данные из базы для размещения во вью
                    self.albumsFromRealm = try! Realm(configuration: self.deleteIfMigration).objects(FriendAlbum.self).filter("ownerId == %@", self.activeFriend.id)
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    
                case .error(let error):
                    fatalError("\(error)")
                }
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
