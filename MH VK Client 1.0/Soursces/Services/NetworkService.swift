 //
 //  SessionManager.swift
 //  MH VK Client 1.0
 //
 //  Created by Vitaly Khomatov on 14.12.2019.
 //  Copyright © 2019 Macrohard. All rights reserved.
 //
 
 import Foundation
 import Alamofire
 import SwiftyJSON
 
 
 class NetworkService {
    
    static let session: Alamofire.Session = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 20
        let session = Alamofire.Session(configuration: config)
        return session
    }()
    
    private let baseUrl = "https://api.vk.com"
    private let versionAPI = "5.92"
    private let token: String
    
    
    init(token: String) {
        self.token = token
    }
    
    // Получение списка друзей
    func loadFriends(completion: ((Result<[FriendVK], Error>) -> Void)? = nil) {
        
        let path = "/method/friends.get"
        
        let params: Parameters = [
            "access_token":  token,
            "v": versionAPI,
            "fields": "photo_100"
        ]
        
        //получение друзей пользователя
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
                
            case let .success(data):
                let json = JSON(data)
                let friendJSONs = json["response"]["items"].arrayValue
                let friends = friendJSONs.map { FriendVK(from: $0) }
                completion?(.success(friends))
                print("СПИСОК ДРУЗЕЙ ЗАГРУЖЕН: \(friends.count)")
                
            case let .failure(error):
                completion?(.failure(error))
                print("ОШИБКА ЗАГРУЗКИ СПИСКА ДРУЗЕЙ \(error)")
                
            }
        }
        
    }
    
    
    //получение альбомов пользователя
    func getFriendAlbums(userId: Int, completion: ((Result<[FriendAlbum], Error>) -> Void)? = nil) {
        
        let path = "/method/photos.getAlbums"
        
        let params: Parameters = [
            "access_token": token,
            "owner_id": userId,
            "need_covers": 1,
            "need_system": 1,
            "v": versionAPI
        ]
        
        
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case let .success(data):
                let json = JSON(data)
                let albumsJSONs = json["response"]["items"].arrayValue
                let albums = albumsJSONs.map { FriendAlbum(from: $0) }
                completion?(.success(albums))
                print("АЛЬБОМЫ ПОЛЬЗОВАТЕЛЯ ЗАГРУЖЕНЫ: \(albums.count)")
            case let .failure(error):
                completion?(.failure(error))
                print("ОШИБКА ЗАГРУЗКИ АЛЬБОМОВ ПОЛЬЗОВАТЕЛЯ \(error)")
                
            }
        }
        
    }
    
    
    // Получение фото в альбоме
    func getFriendPhotosFromAlbum(userId: Int, albumId: Int, completion: ((Result<[FriendPhoto], Error>) -> Void)? = nil) {
        
        let path = "/method/photos.get"
        
        let params: Parameters = [
            "access_token": token,
            "extended": 1,
            "owner_id": userId,
            "album_id": albumId,
            "v": versionAPI
            
        ]
        
        
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case let .success(data):
                let json = JSON(data)
                let photosJSONs = json["response"]["items"].arrayValue
                let photos = photosJSONs.map { FriendPhoto(from: $0) }
                completion?(.success(photos))
                print("ФОТО ИЗ ТЕКУЩЕГО АЛЬБОМА ЗАГРУЖЕНЫ: \(photos.count)")
                
            case let .failure(error):
                completion?(.failure(error))
                print("ОШИБКА ЗАГРУЗКИ ФОТО ИЗ ТЕКУЩЕГО АЛЬБОМА")
                
            }
        }
        
    }
    
    
    // Получение групп активного пользователя
    func loadGroups(userId: Int, completion: ((Result<[GroupVK], Error>) -> Void)? = nil) {
        let path = "/method/groups.get"
        
        let params: Parameters = [
            "access_token":  Session.shared.accessToken,
            "extended": 1,
            "v": versionAPI
        ]
        
        
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case let .success(data):
                let json = JSON(data)
                let groupJSONs = json["response"]["items"].arrayValue
                let groups = groupJSONs.map { GroupVK(from: $0) }
                completion?(.success(groups))
                print("ГРУППЫ ПОЛЬЗОВАТЕЛЯ ЗАГРУЖЕНЫ: \(groups.count)")
                
            case let .failure(error):
                completion?(.failure(error))
                print("ОШИБКА ЗАГРУЗКИ ГРУПП ПОЛЬЗОВАТЕЛЯ")
                
            }
        }
        
    }
    
    // Получение групп по поисковому запросу
    func searchGroups(userId: Int, search: String, completion: ((Result<[GroupVK], Error>) -> Void)? = nil) {
        
        let path = "/method/groups.search"
        
        let params: Parameters = [
            "access_token":  Session.shared.accessToken,
            "extended": 1,
            "v": versionAPI,
            "q": search,
            "count": 100,
            "type": "group, page"
        ]
        
        
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case let .success(data):
                let json = JSON(data)
                let groupJSONs = json["response"]["items"].arrayValue
                let groups = groupJSONs.map { GroupVK(from: $0) }
                completion?(.success(groups))
                print("ГРУППЫ ПО ПОИСКОВОМУ ЗАПРОСУ \(search) ЗАГРУЖЕНЫ")
            case let .failure(error):
                completion?(.failure(error))
                print("ОШИБКА ЗАГРУЗКИ ГРУПП ПО ПОИСКОВОМУ ЗАПРОСУ \(search)")
                
            }
            
        }
        
    }
    
    
    
    // MARK: - Загрузка новостей
    
    
    func loadNews(completion: ((Result<NewsVK, Error>) -> Void)? = nil) {
        let path = "/method/newsfeed.get"
        
        let params: Parameters = [
            "access_token":  Session.shared.accessToken,
            "v": versionAPI,
            "filters": "post"
        ]
        
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case let .success(data):
                let json = JSON(data)
                let newsVK = NewsVK(from: json["response"])
                
                completion?(.success(newsVK))
                print("ОБЪЕКТ NEWS ЗАГРУЖЕН")
                
                
            case let .failure(error):
                completion?(.failure(error))
                print("ОШИБКА ЗАГРУЗКИ ОБЪЕКТА NEWS")
                
            }
        }
        
    }


 }
 
 
 

