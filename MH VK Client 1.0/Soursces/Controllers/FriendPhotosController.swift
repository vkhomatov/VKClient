//
//  FriendPhotosViewController.swift
//  MH VK Client 1.0
//
//  Created by Vitaly Khomatov on 06/10/2019.
//  Copyright © 2019 Macrohard. All rights reserved.
//

import UIKit
import RealmSwift

class FriendPhotosController: UIViewController  {
    
    enum AnimationDirection {
        case left
        case right
    }
    
    @IBOutlet weak var heartView: HeartView​!
    @IBOutlet var friendPhotosShow: AlbumPhotosView!
    
    private let networkService = NetworkService(token: Session.shared.accessToken)
    var activeFriend = FriendVK()
    var activeAlbum = FriendAlbum()
    
    private var propertyAnimator: UIViewPropertyAnimator!
    private var animationDirection: AnimationDirection = .left
    
    let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)

    
    private lazy var photosFromRealm: Results<FriendPhoto> = try! Realm(configuration: deleteIfMigration).objects(FriendPhoto.self).filter("albumId == %@", activeAlbum.id)
    
    var photosToken: NotificationToken?
    
    
    
    @IBAction func FriendPhotoWinCloseButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    // функция установки статуса userLike и кол-ва просмотров фото
    func isLiked(likeCount: Int, likeUser: Int) {
        heartView.likeCount =  likeCount
        
        if likeUser == 1 {
            heartView.isLiked = true
        } else {
            heartView.isLiked = false }
        
        heartView.drawHeart(red: heartView.isLiked)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  self.view.backgroundColor = .mainColor

     //   DispatchQueue.global().async {

        //загрузка фото из выбранного альбома
            self.networkService.getFriendPhotosFromAlbum(userId: self.activeFriend.id, albumId: self.activeAlbum.id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                
            case let .success(albumPhotosVK):
                guard !albumPhotosVK.isEmpty else {
                    print("НЕ УДАЛОСЬ ЗАГРУЗИТЬ ФОТО ИЗ АЛЬБОМА: \(self.activeAlbum.title)")
                    return
                }
                
          //      DispatchQueue.main.async {

                //удаляем старые записи о фото из базы и записываем полученные из VK
                guard let realm = try? Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true)) else { fatalError() }
                guard let albumVK = realm.object(ofType: FriendAlbum.self, forPrimaryKey: self.activeAlbum.idRealm) else {
                    print("НЕ УДАЛОСЬ ПОЛУЧИТЬ ОБЪЕКТ АЛЬБОМ: \(self.activeAlbum.id)")
                    return }
                try? realm.write {
                    if self.photosFromRealm.count > 0 {
                        realm.delete(self.photosFromRealm) }
                    albumVK.photos.append(objectsIn: albumPhotosVK)
                    
                }
            //    }
                
            case let .failure(error):
                print("ОШИБКА ПОЛУЧЕНИЕ СПИСКА ФОТО В АЛЬБОМЕ ИЗ VK \(error)")
            }
        }
   //     }
        
        //ставим observer на БД
        self.photosToken = self.photosFromRealm.observe { [weak self] (changes:RealmCollectionChange) in
            guard let viewPhotos = self?.friendPhotosShow else { return }
            switch changes {
            case .initial:
                viewPhotos.setNeedsDisplay()
            case .update://(_, let deletion, let insertion, let modification):
                
                guard let self = self else { return }
                
                print("ОБНОВЛЕНИЕ ДАННЫХ В РЕАЛМ ФОТОГРАФИИ")
                
                //считываем данные из базы для размещения во вью
                self.photosFromRealm = try! Realm(configuration: self.deleteIfMigration).objects(FriendPhoto.self).filter("albumId == %@", self.activeAlbum.id)
                
                DispatchQueue.main.async {

                //загружаем фото во вью
                self.friendPhotosShow.FriendPhotoImageView1.kf.setImage(with: URL(string: self.photosFromRealm[self.friendPhotosShow.selectedAlbumPhotoIndex].imageFullURLString))
                
                //устанавливаем кол-во лайков и юзерлайк для фото
                self.isLiked(likeCount: self.photosFromRealm[self.friendPhotosShow.selectedAlbumPhotoIndex].likesCount, likeUser: self.photosFromRealm[self.friendPhotosShow.selectedAlbumPhotoIndex].likeUser)
                }
                
                print("КОЛ-ВО ЛАЙКОВ: \(self.photosFromRealm[self.friendPhotosShow.selectedAlbumPhotoIndex].likesCount)")
                
                
            case .error(let error):
                fatalError("\(error)")
            }
        }
            
            
        DispatchQueue.main.async {
        
            let panGR = UIPanGestureRecognizer(target: self, action: #selector(self.viewPanned(_:)))
            self.view.addGestureRecognizer(panGR)
            }
        
    
    }
    
    
    deinit {
        photosToken?.invalidate()
    }
    
    
    //функция перелистывания вью с фото
    @objc func viewPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {
        switch panGestureRecognizer.state {
            
        case .began:
            
            //  print(panGestureRecognizer.translation(in: view).x)
            
            if panGestureRecognizer.translation(in: view).x > 0 {
                guard friendPhotosShow.selectedAlbumPhotoIndex >= 1 else { return }
                
                animationDirection = .right
                // начальная трансформация
                
                friendPhotosShow.FriendPhotoImageView3.transform = CGAffineTransform(translationX: -self.friendPhotosShow.FriendPhotoImageView3.bounds.width, y: 0)
                
                friendPhotosShow.FriendPhotoImageView3.kf.setImage(with: URL(string: photosFromRealm[friendPhotosShow.selectedAlbumPhotoIndex - 1].imageFullURLString))
                
                // создаем аниматор для движения направо
                propertyAnimator = UIViewPropertyAnimator(duration: 0.7, curve: .easeInOut, animations: {
                    self.friendPhotosShow.FriendPhotoImageView1.transform = CGAffineTransform(translationX: self.friendPhotosShow.FriendPhotoImageView1.bounds.width, y: 0)
                    
                    self.friendPhotosShow.FriendPhotoImageView3.transform = .identity
                    
                })
                
                propertyAnimator.addCompletion { position in
                    switch position {
                    case .end:
                        self.friendPhotosShow.selectedAlbumPhotoIndex -= 1
                        
                        
                        self.friendPhotosShow.FriendPhotoImageView1.kf.setImage(with: URL(string: self.photosFromRealm[self.friendPhotosShow.selectedAlbumPhotoIndex].imageFullURLString))
                        
                        self.friendPhotosShow.FriendPhotoImageView1.transform = .identity
                        self.friendPhotosShow.FriendPhotoImageView3.image = nil
                        
                        
                        print("КОЛ-ВО ЛАЙКОВ: \(self.photosFromRealm[self.friendPhotosShow.selectedAlbumPhotoIndex].likesCount)")
                        
                        self.isLiked(likeCount: self.photosFromRealm[self.friendPhotosShow.selectedAlbumPhotoIndex].likesCount, likeUser: self.photosFromRealm[self.friendPhotosShow.selectedAlbumPhotoIndex].likeUser)
                        
                        
                    case .start:
                        self.friendPhotosShow.FriendPhotoImageView3.transform = CGAffineTransform(translationX: -self.friendPhotosShow.FriendPhotoImageView3.bounds.width, y: 0)
                        
                    case .current:
                        
                        break
                    @unknown default:
                        break
                    }
                }
            }else {
                // создаем аниматор для движения налево
                guard friendPhotosShow.selectedAlbumPhotoIndex + 1 <= photosFromRealm.count - 1 else { return }
                
                animationDirection = .left
                
                
                // начальная трансформация
                friendPhotosShow.FriendPhotoImageView3.transform = CGAffineTransform(translationX: self.friendPhotosShow.FriendPhotoImageView3.bounds.width, y: 0)
                
                friendPhotosShow.FriendPhotoImageView3.kf.setImage(with: URL(string: photosFromRealm[friendPhotosShow.selectedAlbumPhotoIndex + 1].imageFullURLString))
                
                // создаем аниматор для движения направо
                propertyAnimator = UIViewPropertyAnimator(duration: 0.7, curve: .easeInOut, animations: {
                    self.friendPhotosShow.FriendPhotoImageView1.transform = CGAffineTransform(translationX: -self.friendPhotosShow.FriendPhotoImageView1.bounds.width, y: 0)
                    
                    self.friendPhotosShow.FriendPhotoImageView3.transform = .identity
                    
                })
                
                // print("Left animation property animator has been created")
                propertyAnimator.addCompletion { position in
                    switch position {
                    case .end:
                        self.friendPhotosShow.selectedAlbumPhotoIndex += 1
                        
                        self.friendPhotosShow.FriendPhotoImageView1.kf.setImage(with: URL(string: self.photosFromRealm[self.friendPhotosShow.selectedAlbumPhotoIndex].imageFullURLString))
                        
                        self.friendPhotosShow.FriendPhotoImageView1.transform = .identity
                        self.friendPhotosShow.FriendPhotoImageView3.image = nil
                        print("КОЛ-ВО ЛАЙКОВ: \(self.photosFromRealm[self.friendPhotosShow.selectedAlbumPhotoIndex].likesCount)")
                        
                        self.isLiked(likeCount: self.photosFromRealm[self.friendPhotosShow.selectedAlbumPhotoIndex].likesCount, likeUser: self.photosFromRealm[self.friendPhotosShow.selectedAlbumPhotoIndex].likeUser)
                        
                    case .start:
                        self.friendPhotosShow.FriendPhotoImageView3.transform = CGAffineTransform(translationX: self.friendPhotosShow.FriendPhotoImageView3.bounds.width, y: 0)
                        
                    case .current:
                        break
                        
                        
                    @unknown default:
                        break
                    }
                }
            }
            
        case .changed:
            guard let propertyAnimator = self.propertyAnimator else { return }
            switch animationDirection {
            case .right:
                let percent = min(max(0, panGestureRecognizer.translation(in: view).x / 200), 1)
                propertyAnimator.fractionComplete = percent
            case .left:
                let percent = min(max(0, -panGestureRecognizer.translation(in: view).x / 200), 1)
                propertyAnimator.fractionComplete = percent
            }
            
        case .ended:
            guard let propertyAnimator = self.propertyAnimator else { return }
            if propertyAnimator.fractionComplete > 0.33 {
                propertyAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0.5)
                
                
            } else {
                propertyAnimator.isReversed = true
                propertyAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0.5)
            }
            
        default:
            break
        }
        
        
    }
    
    
}

