//
//  NewsController.swift
//  MH VK Client 1.0
//
//  Created by Vitaly Khomatov on 02/10/2019.
//  Copyright © 2019 Macrohard. All rights reserved.
//



import UIKit
import Kingfisher
import RealmSwift



@available(iOS 13.0, *)
class NewsController: UITableViewController, UITableViewDataSourcePrefetching {
    
    
    private let networkService = NetworkService(token: Session.shared.accessToken)
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var itemsVK = [NewsItemVK]()
    var profilesVK = [NewsProfileVK]()
    var groupsVK = [GroupVK]()
    
    var newsForTable = [NewsForTable]()
    
    var lastNewsDate: Double = 0
    var isFetchingMoreNews = false
    var nextFrom: String?
    var updateNews: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(getNewNews), for: .valueChanged)
        self.refreshControl = refreshControl
        refreshControl.tintColor = .tintColor
        // refreshControl.attributedTitle = NSAttributedString(string: "Refreshing News ...")
        
        getNews(lastNewsDateG: nil, nextFromG: nil)
        
        //  DispatchQueue.global().async {
        
        //            self.networkService.loadNews() { [weak self] result in
        //                guard let self = self else { return }
        //                switch result {
        //                case let .success(newsVK):
        //
        //                    self.newsVK = newsVK
        //
        //                    print("Загружено новостей: \(self.newsVK.items.count)")
        //                    print("Загружено профилей: \(self.newsVK.profiles.count)")
        //                    print("Загружено групп: \(self.newsVK.groups.count)\n")
        //
        //                    // функция формирования новостного массива
        //                    self.newsAdapter()
        //
        //                    DispatchQueue.main.async {
        //                        self.tableView.reloadData()
        //                    }
        //
        //                case let .failure(error):
        //                    print("ОШИБКА ЗАГРУЗКИ ОБЪЕКТА NEWS: \(error)")
        //                }
        //            }
        //  }
        
        
        
    }
    
    
    func getNews(lastNewsDateG: Double?, nextFromG: String?){
        
        networkService.loadNews(lastNewsDate: lastNewsDateG, nextFrom: nextFromG) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(itemsVK, profilesVK, groupsVK, nextFrom):
                
                self.itemsVK = itemsVK
                self.profilesVK = profilesVK
                self.groupsVK = groupsVK
                
                if ( self.itemsVK.count > 0 ) {
                    print("Загружено новостей: \(self.itemsVK.count)")
                    print("Загружено профилей: \(self.profilesVK.count)")
                    print("Загружено групп: \(self.groupsVK.count)\n")
                    
                    // если не обновление ленты то получаем новый параметр nextFrom
                    if self.updateNews == false && nextFrom != "" {
                        self.nextFrom = nextFrom
                    }
                    
                    print("STARTFROM: \(String(describing: self.nextFrom))")
                    
                    DispatchQueue.main.async {
                        
                        // функция формирования новостного массива
                        self.newsAdapter()
                        self.tableView.reloadData()
                        self.isFetchingMoreNews = false
                        self.updateNews = false
                        
                    }
                    
                } else {
                    print("НОВЫХ НОВОСТЕЙ НЕТ\n")
                    self.updateNews = false
                    
                }
                
            case let .failure(error):
                print("ОШИБКА ЗАГРУЗКИ ОБЪЕКТА NEWS: \(error)")
            }
        }
    }
    
    
    @objc func getNewNews() {
                
        print("\nОБНОВЛЕНИЕ НОВОСТЕЙ ....\n ")
        
        self.refreshControl?.beginRefreshing()
        
        // ставим флаг обновления новостей в true
        self.updateNews = true
        
        // запращиваем новости начиная с даты первой новости в массиве + 1 секунда
        self.lastNewsDate = newsForTable[0].dateVK + 1
        
        //получаем новые новости с последней даты последней новости в массиве новостей
        getNews(lastNewsDateG: lastNewsDate, nextFromG: nil)
                
        self.refreshControl?.endRefreshing()
        
        print("ОБНОВЛЕНИЕ НОВОСТЕЙ ЗАКОНЧЕНО\n")
        
    }
    
    
    // функция конвертации даты
    func convertTime(time: Double) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM 'at' HH:mm"
        dateFormatter.timeZone = .current
        let timeStamp = Date(timeIntervalSince1970: time)
        return dateFormatter.string(from: timeStamp)
    }
    
    // функция формирования новостного массива
    func newsAdapter() {
        
        
        for new in 0...(itemsVK.count - 1) {
            
            let newForTable = NewsForTable()
            // конвертируем время публикации новости
            newForTable.date = convertTime(time: itemsVK[new].date)
            newForTable.dateVK =  itemsVK[new].date
            
            // проверяем соответсвует ли автор новости другу или группе
            if itemsVK[new].source_id >= 0 {
                for i in (0...profilesVK.count - 1) {
                    if (itemsVK[new].source_id == profilesVK[i].id) {
                        newForTable.fullName = profilesVK[i].fullName
                        newForTable.avaPhoto = profilesVK[i].mainPhoto
                    }
                }
            } else  {   // автор новости соответсвует группе
                
                for i in (0...groupsVK.count - 1) {
                    if (itemsVK[new].source_id == (groupsVK[i].id * -1))  {
                        newForTable.fullName = groupsVK[i].name
                        newForTable.avaPhoto = groupsVK[i].imageName
                    }
                }
            }
            
            newForTable.post_type = itemsVK[new].post_type
            newForTable.copy_owner_id = itemsVK[new].copy_owner_id
            newForTable.copy_post_id = itemsVK[new].copy_post_id
            
            print("\nАвтор новости: \(newForTable.fullName)")
            print("Тип новости: \(itemsVK[new].type)")
            print("Время публикации: \(newForTable.date)")
            print("Тип записи: \(newForTable.post_type)")
            
            //если тип новости wall_photo
            if itemsVK[new].type == "wall_photo" && itemsVK[new].photos.count > 0 {
                
                newForTable.wallphotos = itemsVK[new].photos
                newForTable.wallphoto = true
                newForTable.rowsCount += 1
                
                // вытаскиеваем отметки лайкс и т.д. из первого объекта фото
                newForTable.likeUser = itemsVK[new].photos[0].likeUser
                newForTable.likesCount = itemsVK[new].photos[0].likesCount
                newForTable.reposts = itemsVK[new].photos[0].reposts
                newForTable.views = itemsVK[new].photos[0].views
                print("Фото со стены обнаружено: \(itemsVK[new].photos[0].imageCellURLString)")
                
            }
            
            //если тип новости post
            if itemsVK[new].type == "post" {
                
                newForTable.post = true
                
                //если тип новости repost
                if  itemsVK[new].post_type == "copy" {
                    newForTable.rowsCount += 1
                    newForTable.perepost = true
                    print("Обнаружена новость типа репост: \(itemsVK[new].post_type)")
                    print("Автор репоста: \(newForTable.copy_owner_id)")
                    print("ID репоста: \(newForTable.copy_post_id)")
                } else { // если тип новости post
                    
                    // проверяем содержит ли новость текстовый блок
                    if itemsVK[new].text != "" {
                        newForTable.text = itemsVK[new].text
                        newForTable.rowsCount += 1
                        newForTable.textrow = true
                        print("Текст новости: \(itemsVK[new].text)")
                        
                    } else if itemsVK[new].attachments!.count == 0 {
                        newForTable.rowsCount += 1
                        newForTable.emptynews = true
                        print("Обнаружена пустая новость: \(itemsVK[new].post_type)")
                    }
                    
                    
                    // вычисляем аттачмент какого типа содержит новость и вытаскиваем объект аттачмента
                    if  (itemsVK[new].attachments != nil && itemsVK[new].attachments!.count > 0)  {
                        
                        print("Кол-во аттачментов: \(String(describing: itemsVK[new].attachments!.count))")
                        
                        itemsVK[new].attachments!.forEach { print("Тип аттачмента: \($0.typeStr)") }
                        
                        //проверяем есть ли среди аттачментов тип photo и вытаскиваем первый аттачмент photo если он есть
                        let photoObj = itemsVK[new].attachments!.first(where: { $0.typeStr == "photo" })
                        
                        if photoObj != nil {
                            
                            print("Аттачмент photo обнаружен : \(String(describing: photoObj!.photoObj!.imageCellURLString))")
                            
                            newForTable.attachType = photoObj!.typeStr
                            newForTable.photo = photoObj!.photoObj
                            newForTable.rowsCount += 1
                            newForTable.photorow = true
                        }
                        
                        //проверяем есть ли среди аттачментов тип link и вытаскиваем первый аттачмент link если он есть
                        let linkObj = itemsVK[new].attachments!.first(where: { $0.typeStr == "link" })
                        
                        if linkObj != nil {
                            newForTable.attachType = linkObj!.typeStr
                            newForTable.link = linkObj!.linkObj
                            newForTable.rowsCount += 1
                            newForTable.linkrow = true
                            
                            print("Аттачмент link обнаружен : \(String(describing: linkObj!.linkObj!.url ))")
                            print("Аттачмент link фото : \(String(describing: linkObj!.linkObj!.photo!.imageCellURLString  ))")
                        }
                        
                        //ставим залушку если тип аттачмента не соответсвует photo или link
                        if linkObj == nil && photoObj == nil {
                            newForTable.attachType = itemsVK[new].attachments!.first!.typeStr
                            newForTable.rowsCount += 1
                            newForTable.otherrow = true
                            
                            print("Обнаружен аттачмент типа: \(newForTable.attachType)")
                        }
                        
                    }
                    
                    // вытаскиеваем отметки лайкс и т.д. из новости
                    newForTable.likeUser = itemsVK[new].likeUser
                    newForTable.likesCount = itemsVK[new].likesCount
                    newForTable.reposts = itemsVK[new].reposts
                    newForTable.views = itemsVK[new].views
                }
            }
            
            if (itemsVK[new].type != "wall_photo") && (itemsVK[new].type != "post")   {
                newForTable.rowsCount += 1
                newForTable.othernews = true
                newForTable.attachType = itemsVK[new].type
                print("Обнаружена новость типа: \(itemsVK[new].type)")
                
            }
            
            print("Кол-во ячеек: \(newForTable.rowsCount)")
                        
            // если произошло обновление новостей добавляем новую новость в начало массива с новостями
            if self.updateNews {
                newsForTable.insert(newForTable, at: new)
            } else {
                // если получение следующего блока новостей то добавляем новость в конец массива с новостями
                newsForTable.append(newForTable)
            }
            
        }

        self.updateNews = false
        
        
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return newsForTable.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsForTable[section].rowsCount
    }
    
    
    //    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //
    //        return " "
    //
    //    }
    
    //        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //
    //         return 100
    //
    //        }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4.0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        let headCell = tableView.dequeueReusableCell(withIdentifier: "newsHeadCell", for: indexPath) as! NewsHeadCell
        headCell.configure(witch: newsForTable[indexPath.section])
        
        let textCell = tableView.dequeueReusableCell(withIdentifier: "newsTextCell", for: indexPath) as! NewsTextCell
        textCell.configure(witch: newsForTable[indexPath.section])
        
        let photoCell = tableView.dequeueReusableCell(withIdentifier: "newsPhotoCell", for: indexPath) as! NewsPhotoCell
        photoCell.configure(witch: newsForTable[indexPath.section])
        
        let linkCell = tableView.dequeueReusableCell(withIdentifier: "newsLinkCell", for: indexPath) as! NewsLinkCell
        linkCell.configure(witch: newsForTable[indexPath.section])
        
        let actionsCell = tableView.dequeueReusableCell(withIdentifier: "newsActionsCell", for: indexPath) as! NewsActionsCell
        actionsCell.configure(witch: newsForTable[indexPath.section])
        
        
        // обновляем ячейку с текстовым блоком после увеличения/уменьшения высоты
        textCell.onSeeMoreDidTap {
            tableView.beginUpdates()
            textCell.setNeedsLayout()
            tableView.endUpdates()
        }
//        
//        photoCell.cellLayout {
////            tableView.beginUpdates()
////            photoCell.frame.size.height = 200
////            photoCell.setNeedsDisplay()
////            tableView.endUpdates()
//
//        }
        
        // новость содержит только неизвестный контент
        if newsForTable[indexPath.section].othernews {
            
            switch indexPath.row {
            case 0 : cell = headCell
            case 1 : cell = textCell
            case 2 : cell = actionsCell
            default : return cell
            }
        }
        
        // тип новости wallPhoto
        if newsForTable[indexPath.section].wallphoto {
            switch indexPath.row {
            case 0 : cell = headCell
            case 1 : cell = photoCell
            case 2 : cell = actionsCell
            default : return cell
            }
        }
        
        //тип новости Post
        if newsForTable[indexPath.section].post {
            
            // тип новости репост
            if  newsForTable[indexPath.section].perepost  {
                switch indexPath.row {
                case 0 : cell = headCell
                case 1 : cell = textCell
                case 2 : cell = actionsCell
                default: return cell
                }
            } else {
                
                // пустая новость или аттачмент нераспознан
                if  newsForTable[indexPath.section].emptynews && !newsForTable[indexPath.section].textrow && !newsForTable[indexPath.section].photorow && !newsForTable[indexPath.section].linkrow && !newsForTable[indexPath.section].otherrow   {
                    
                    switch indexPath.row {
                    case 0 : cell = headCell
                    case 1 : cell = textCell
                    case 2 : cell = actionsCell
                    default: return cell
                    }
                }
                
                // новость содержит только текст
                if newsForTable[indexPath.section].textrow && !newsForTable[indexPath.section].photorow && !newsForTable[indexPath.section].linkrow && !newsForTable[indexPath.section].emptynews && !newsForTable[indexPath.section].otherrow {
                    
                    switch indexPath.row {
                    case 0 : cell = headCell
                    case 1 : cell = textCell
                    case 2 : cell = actionsCell
                    default: return cell
                    }
                }
                
                // новость содержит только неизвестный аттач
                if !newsForTable[indexPath.section].textrow  && !newsForTable[indexPath.section].photorow && !newsForTable[indexPath.section].linkrow && newsForTable[indexPath.section].otherrow  && !newsForTable[indexPath.section].emptynews {
                    
                    switch indexPath.row {
                    case 0 : cell = headCell
                    case 1 : cell = textCell
                    case 2 : cell = actionsCell
                    default: return cell
                    }
                }
                
                
                // новость содержит текст и неизвестный аттач
                if newsForTable[indexPath.section].textrow && newsForTable[indexPath.section].otherrow && !newsForTable[indexPath.section].linkrow  && !newsForTable[indexPath.section].photorow  {
                    
                    switch indexPath.row {
                    case 0 : cell = headCell
                    case 1 : cell = textCell
                    case 2 :
                        textCell.messageLabel.text = "Новость содержит \(newsForTable[indexPath.section].attachType) аттачмент"
                        textCell.moreLessButton.isHidden = true
                        cell = textCell
                    case 3 : cell = actionsCell
                    default: return cell
                    }
                }
                
                //новость содержит только ссылочный аттач
                if !newsForTable[indexPath.section].textrow && !newsForTable[indexPath.section].photorow && newsForTable[indexPath.section].linkrow && !newsForTable[indexPath.section].otherrow  {
                    
                    switch indexPath.row {
                    case 0 : cell = headCell
                    case 1 : cell = linkCell
                    case 2 : cell = actionsCell
                    default: return cell
                    }
                }
                
                // новость содержит только фото аттач
                if !newsForTable[indexPath.section].textrow && newsForTable[indexPath.section].photorow && !newsForTable[indexPath.section].linkrow && !newsForTable[indexPath.section].otherrow  {
                    
                    
                    switch indexPath.row {
                    case 0 : cell = headCell
                    case 1 : cell = photoCell
                    case 2 : cell = actionsCell
                    default: return cell
                    }
                }
                
                //новость содержит текст и фото и не содержит ссылку
                if newsForTable[indexPath.section].textrow && newsForTable[indexPath.section].photorow && !newsForTable[indexPath.section].linkrow && !newsForTable[indexPath.section].otherrow {
                    
                    switch indexPath.row {
                    case 0 : cell = headCell
                    case 1 : cell = textCell
                    case 2 : cell = photoCell
                    case 3 : cell = actionsCell
                    default: return cell
                    }
                }
                
                //новость содержит текст и ссылку и не содержит фото
                if newsForTable[indexPath.section].textrow && !newsForTable[indexPath.section].photorow &&  newsForTable[indexPath.section].linkrow && !newsForTable[indexPath.section].otherrow  {
                    
                    
                    switch indexPath.row {
                    case 0 : cell = headCell
                    case 1 : cell = textCell
                    case 2 : cell = linkCell
                    case 3 : cell = actionsCell
                    default: return cell
                    }
                }
                
                //новость содержит текст и ссылку и фото
                if newsForTable[indexPath.section].textrow && newsForTable[indexPath.section].photorow && newsForTable[indexPath.section].linkrow && !newsForTable[indexPath.section].otherrow {
                    
                    switch indexPath.row {
                    case 0 : cell = headCell
                    case 1 : cell = textCell
                    case 2 : cell = photoCell
                    case 3 : cell = linkCell
                    case 4 : cell = actionsCell
                    default: return cell
                        
                    }
                }
            }
        }
        
        return cell
        
    }
    
    
    //    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //                cell.layoutIfNeeded()
    //    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        guard !isFetchingMoreNews,
            let maxSection = indexPaths.map({ $0.section }).max(),
            newsForTable.count <= maxSection + 20  else { return }
        
        isFetchingMoreNews = true
        
        getNews(lastNewsDateG: nil, nextFromG: nextFrom ?? nil)
        
        
        
    }
    
}

