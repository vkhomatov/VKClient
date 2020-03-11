//
//  NewsController.swift
//  MH VK Client 1.0
//
//  Created by Vit on 02/10/2019.
//  Copyright © 2019 Macrohard. All rights reserved.
//



import UIKit
import Kingfisher


@available(iOS 13.0, *)
class NewsController: UITableViewController {
    
    private let networkService = NetworkService(token: Session.shared.accessToken)
    var newsVK = NewsVK()
    var newsForTable = [NewsForTable]()
    //var newForTable = NewsForTable()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        DispatchQueue.global().async {
            
            self.networkService.loadNews() { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(newsVK):
                    
                    self.newsVK = newsVK
                    
                    print("Загружено новостей: \(self.newsVK.items.count)")
                    print("Загружено профилей: \(self.newsVK.profiles.count)")
                    print("Загружено групп: \(self.newsVK.groups.count)\n")
                    
                    // функция формирования новостного массива
                    self.newsAdapter()
                    
//                    for _ in 1...10 {
//                        print("1")
//                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
//                        for _ in 1...10 {
//                            print("2")
//                        }
                    }
                    
                case let .failure(error):
                    print("ОШИБКА ЗАГРУЗКИ ОБЪЕКТА NEWS: \(error)")
                }
            }
        }
        
        
        
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
        
        for new in 0...(newsVK.items.count - 1) {
            
            let newForTable = NewsForTable()
            // конвертируем время публикации новости
            newForTable.date = convertTime(time: newsVK.items[new].date)
            
            // проверяем соответсвует ли автор новости другу или группе
            if newsVK.items[new].source_id >= 0 {
                for i in (0...newsVK.profiles.count - 1) {
                    if (newsVK.items[new].source_id == newsVK.profiles[i].id) {
                        newForTable.fullName = newsVK.profiles[i].fullName
                        newForTable.avaPhoto = newsVK.profiles[i].mainPhoto
                    }
                }
            } else  {   // автор новости соответсвует группе
                
                for i in (0...newsVK.groups.count - 1) {
                    if (newsVK.items[new].source_id == (newsVK.groups[i].id * -1))  {
                        newForTable.fullName = newsVK.groups[i].name
                        newForTable.avaPhoto = newsVK.groups[i].imageName
                    }
                }
            }
            
            newForTable.post_type = newsVK.items[new].post_type
            newForTable.copy_owner_id = newsVK.items[new].copy_owner_id
            newForTable.copy_post_id = newsVK.items[new].copy_post_id
            
            print("\nАвтор новости: \(newForTable.fullName)")
            print("Тип новости: \(newsVK.items[new].type)")
            print("Время публикации: \(newForTable.date)")
            print("Тип записи: \(newForTable.post_type)")
            
            //если тип новости wall_photo
            if newsVK.items[new].type == "wall_photo" && newsVK.items[new].photos.count > 0 {
                
                newForTable.wallphotos = newsVK.items[new].photos
                newForTable.wallphoto = true
                newForTable.rowsCount += 1
                
                // вытаскиеваем отметки лайкс и т.д. из первого объекта фото
                newForTable.likeUser = newsVK.items[new].photos[0].likeUser
                newForTable.likesCount = newsVK.items[new].photos[0].likesCount
                newForTable.reposts = newsVK.items[new].photos[0].reposts
                newForTable.views = newsVK.items[new].photos[0].views
                print("Фото со стены обнаружено: \(newsVK.items[new].photos[0].imageCellURLString)")
                
            }
            
            //если тип новости post
            if newsVK.items[new].type == "post" {
                
                newForTable.post = true
                
                //если тип новости repost
                if  newsVK.items[new].post_type == "copy" {
                    newForTable.rowsCount += 1
                    newForTable.perepost = true
                    print("Обнаружена новость типа репост: \(newsVK.items[new].post_type)")
                    print("Автор репоста: \(newForTable.copy_owner_id)")
                    print("ID репоста: \(newForTable.copy_post_id)")
                } else { // если тип новости post
                    
                    // проверяем содержит ли новость текстовый блок
                    if newsVK.items[new].text != "" {
                        newForTable.text = newsVK.items[new].text
                        newForTable.rowsCount += 1
                        newForTable.textrow = true
                        print("Текст новости: \(newsVK.items[new].text)")
                        
                    } else if newsVK.items[new].attachments!.count == 0 {
                        newForTable.rowsCount += 1
                        newForTable.emptynews = true
                        print("Обнаружена пустая новость: \(newsVK.items[new].post_type)")
                    }
                    
                    
                    // вычисляем аттачмент какого типа содержит новость и вытаскиваем объект аттачмента
                    if  (newsVK.items[new].attachments != nil && newsVK.items[new].attachments!.count > 0)  {
                        
                        print("Кол-во аттачментов: \(String(describing: newsVK.items[new].attachments!.count))")
                        
                        newsVK.items[new].attachments!.forEach { print("Тип аттачмента: \($0.typeStr)") }
                        
                        //проверяем есть ли среди аттачментов тип photo и вытаскиваем первый аттачмент photo если он есть
                        let photoObj = newsVK.items[new].attachments!.first(where: { $0.typeStr == "photo" })
                        
                        if photoObj != nil {
                            
                            print("Аттачмент photo обнаружен : \(String(describing: photoObj!.photoObj!.imageCellURLString))")
                            
                            newForTable.attachType = photoObj!.typeStr
                            newForTable.photo = photoObj!.photoObj
                            newForTable.rowsCount += 1
                            newForTable.photorow = true
                        }
                        
                        //проверяем есть ли среди аттачментов тип link и вытаскиваем первый аттачмент link если он есть
                        let linkObj = newsVK.items[new].attachments!.first(where: { $0.typeStr == "link" })
                        
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
                            newForTable.attachType = newsVK.items[new].attachments!.first!.typeStr
                            newForTable.rowsCount += 1
                            newForTable.otherrow = true
                            
                            print("Обнаружен аттачмент типа: \(newForTable.attachType)")
                        }
                        
                    }
                    
                    // вытаскиеваем отметки лайкс и т.д. из новости
                    newForTable.likeUser = newsVK.items[new].likeUser
                    newForTable.likesCount = newsVK.items[new].likesCount
                    newForTable.reposts = newsVK.items[new].reposts
                    newForTable.views = newsVK.items[new].views
                }
            }
            
            if (newsVK.items[new].type != "wall_photo") && (newsVK.items[new].type != "post")   {
                newForTable.rowsCount += 1
                newForTable.othernews = true
                newForTable.attachType = newsVK.items[new].type
                print("Обнаружена новость типа: \(newsVK.items[new].type)")
                
            }
            
            print("Кол-во ячеек: \(newForTable.rowsCount)")
            
            //записываем объект новость в массив
            newsForTable.append(newForTable)
            
        }
        
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
    
    //    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //
    //        if newsForTable[indexPath.row]. {
    //            return 60.0
    //        } else  { return 15.0 }
    //    }
    
    
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
    
    
}
