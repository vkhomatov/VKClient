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
    private var newsVK = NewsVK()
    private var newsForTable = [NewsForTable]()
    private var newForTable = NewsForTable()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        networkService.loadNews() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(newsVK):
                
                self.newsVK = newsVK
                print("Загружено новостей: \(self.newsVK.items.count)")
                print("Загружено профилей: \(self.newsVK.profiles.count)")
                print("Загружено групп: \(self.newsVK.groups.count)\n\n")
                
                //                self.newsVK.profiles.forEach { print("\nID Друга: \($0.id)") }
                //
                //                self.newsVK.groups.forEach { print("ID Группы: \($0.id)") }
                //
                //                self.newsVK.items.forEach { print("source_id: \($0.source_id)") }
                
                
                self.newsAdapter()
                
                
                self.tableView.reloadData()
                
                
            case let .failure(error):
                print("ОШИБКА ЗАГРУЗКИ ОБЪЕКТА NEWS: \(error)")
            }
        }
        
        
        
    }
    
    
    func newsAdapter() {
        
        newsForTable.removeAll()
        
        for new in 0...(newsVK.items.count - 1) {
            
            print("\n\nSource_id: \(newsVK.items[new].source_id)")
            
            // проверяем соответсвует ли автор новости другу
            if newsVK.items[new].source_id >= 0 {
                for i in (0...newsVK.profiles.count - 1) {
                    if (newsVK.items[new].source_id == newsVK.profiles[i].id) {
                        newForTable.fullName = newsVK.profiles[i].fullName
                        newForTable.avaPhoto = newsVK.profiles[i].mainPhoto
                        print("Имя друга: \(newsVK.profiles[i].fullName)")
                    }
                }
                print("Тип новости: \(newsVK.items[new].type)")
                
                // проверяем содержит ли новость текстовый блок
                if newsVK.items[new].text != "" {
                    newForTable.text = newsVK.items[new].text
                    newForTable.rowsCount += 1
                    newForTable.textrow = true
                    print("Текст новости: \(newsVK.items[new].text)")
                    
                }
                
                // конвертируем время публикации новости
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMM 'at' HH:mm"
                dateFormatter.timeZone = .current
                let timeStamp = Date(timeIntervalSince1970: newsVK.items[new].date)
                newForTable.date = dateFormatter.string(from: timeStamp)
                print("Время публикации: \(newForTable.date)")
                
                if newsVK.items[new].attachments!.count > 0 {
                    newForTable.attachType = newsVK.items[new].attachments!.first.self!.typeStr
                    
                    if newForTable.attachType != "photo" && newForTable.attachType != "link" {
                        newForTable.rowsCount += 1
                        newForTable.otherrow = true
                        
                    }
                    
                }
                
                // вычислем аттачмент какого типа содержит новость и вытаскиваем объект аттачмента
                if  (newsVK.items[new].attachments != nil && newsVK.items[new].attachments!.count > 0)  {
                    
                    print("Кол-во аттачментов: \(String(describing: newsVK.items[new].attachments!.count))")
                    
                    newsVK.items[new].attachments!.forEach { print("Тип аттачмента: \($0.typeStr)") }
                    
                    
                    let photoObj = newsVK.items[new].attachments!.first(where: { $0.typeStr == "photo" })
                    
                    if photoObj != nil {
                        
                        print("Аттачмент photo обнаружен : \(String(describing: photoObj!.photoObj!.imageCellURLString))")
                        
                        newForTable.attachType = photoObj!.typeStr
                        newForTable.photo = photoObj!.photoObj!
                        newForTable.rowsCount += 1
                        newForTable.photorow = true
                        
                    }
                    
                    let linkObj = newsVK.items[new].attachments!.first(where: { $0.typeStr == "link" })
                    
                    if linkObj != nil {
                        
                        print("Аттачмент link обнаружен : \(String(describing: linkObj!.linkObj!.url ))")
                        print("Аттачмент link фото : \(String(describing: linkObj!.linkObj!.photo?.imageCellURLString  ))")
                        
                        
                        newForTable.attachType = linkObj!.typeStr
                        newForTable.link = linkObj!.linkObj!
                        newForTable.rowsCount += 1
                        newForTable.linkrow = true
                        
                    }
                    
                }
                
                newForTable.likeUser = newsVK.items[new].likeUser
                newForTable.likesCount = newsVK.items[new].likesCount
                newForTable.reposts = newsVK.items[new].reposts
                newForTable.views = newsVK.items[new].views
                
                print("Кол-во ячеек: \(newForTable.rowsCount)")
                
            } else  {   // автор новости соответсвует группе
                
                for i in (0...newsVK.groups.count - 1) {
                    if (newsVK.items[new].source_id == (newsVK.groups[i].id * -1))  {
                        newForTable.fullName = newsVK.groups[i].name
                        newForTable.avaPhoto = newsVK.groups[i].imageName
                        print("Имя группы: \(newsVK.groups[i].name)")
                    }
                }
                
                print("Тип новости: \(newsVK.items[new].type)")
                
                // проверяем содержит ли новость текстовый блок
                if newsVK.items[new].text != "" {
                    newForTable.text = newsVK.items[new].text
                    newForTable.rowsCount += 1
                    newForTable.textrow = true
                    print("Текст новости: \(newsVK.items[new].text)")
                }
                
                // конвертируем время публикации новости
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMM 'at' HH:mm"
                dateFormatter.timeZone = .current
                let timeStamp = Date(timeIntervalSince1970: newsVK.items[new].date)
                newForTable.date = dateFormatter.string(from: timeStamp)
                
                if newsVK.items[new].attachments!.count > 0 {
                    newForTable.attachType = newsVK.items[new].attachments!.first.self!.typeStr
                    if newForTable.attachType != "photo" && newForTable.attachType != "link" {
                        newForTable.rowsCount += 1
                        newForTable.otherrow = true
                        
                    }
                }
                
                
                // вычислем аттачмент какого типа содержит новость и вытаскиваем объект аттачмента
                if  (newsVK.items[new].attachments != nil && newsVK.items[new].attachments!.count > 0) {
                    
                    print("Кол-во аттачментов: \(String(describing: newsVK.items[new].attachments!.count))")
                    
                    newsVK.items[new].attachments!.forEach { print("Тип аттачмента: \($0.typeStr)") }
                    
                    
                    let photoObj = newsVK.items[new].attachments!.first(where: { $0.typeStr == "photo" })
                    
                    if photoObj != nil {
                        
                        print("Аттачмент photo обнаружен : \(String(describing: photoObj!.photoObj!.imageCellURLString))")
                        
                        newForTable.attachType = photoObj!.typeStr
                        newForTable.photo = photoObj!.photoObj!
                        newForTable.rowsCount += 1
                        newForTable.photorow = true
                        
                    }
                    
                    let linkObj = newsVK.items[new].attachments!.first(where: { $0.typeStr == "link" })
                    
                    if linkObj != nil {
                        
                        print("Аттачмент link обнаружен : \(String(describing: linkObj!.linkObj!.url ))")
                        print("Аттачмент link фото : \(String(describing: linkObj!.linkObj!.photo?.imageCellURLString  ))")
                        
                        
                        newForTable.attachType = linkObj!.typeStr
                        newForTable.link = linkObj!.linkObj!
                        newForTable.rowsCount += 1
                        newForTable.linkrow = true
                        
                    }
                    
                }
                
                newForTable.likeUser = newsVK.items[new].likeUser
                newForTable.likesCount = newsVK.items[new].likesCount
                newForTable.reposts = newsVK.items[new].reposts
                newForTable.views = newsVK.items[new].views
                print("Кол-во ячеек: \(newForTable.rowsCount)")
                
                
            }
            
            newsForTable.append(newForTable)
            
            
            newForTable.avaPhoto = ""
            newForTable.attachType = ""
            newForTable.date = ""
            newForTable.fullName = ""
            
            newForTable.text = ""
            newForTable.photo = nil
            newForTable.link = nil
            
            newForTable.likesCount = 0
            newForTable.likeUser = 0
            newForTable.reposts = 0
            newForTable.views = 0
            newForTable.comments = 0
            
            newForTable.rowsCount = 2
            
            newForTable.textrow = false
            newForTable.photorow = false
            newForTable.linkrow = false
            newForTable.otherrow = false
            
        }
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return newsForTable.count//myNews.news.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //  print("numberOfRowsInSection = \(newsForTable[section].rowsCount)")
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
        //  rowCount = 0
        return 4.0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //  print("indexpathSection : \(newsForTable[indexPath.section])")
        
        var cell = UITableViewCell()
        
        
        // новость не содержит контент
        if !newsForTable[indexPath.section].textrow && !newsForTable[indexPath.section].photorow && !newsForTable[indexPath.section].linkrow && !newsForTable[indexPath.section].otherrow {
            
            //   print("Новость \(newsForTable[indexPath.section].text) не содержит контента")
            
            switch indexPath.row {
                
            case 0 :
                let headCell = tableView.dequeueReusableCell(withIdentifier: "newsHeadCell", for: indexPath) as! NewsHeadCell
                headCell.configure(witch: newsForTable[indexPath.section])
                cell = headCell
                return cell
                
                //                   case 1 :
                //                       let textCell = tableView.dequeueReusableCell(withIdentifier: "newsTextCell", for: indexPath) as! NewsTextCell
                //                       textCell.configure(witch: newsForTable[indexPath.section])
                //                       cell = textCell
                //                       return cell
                
            case 1 :
                
                let actionsCell = tableView.dequeueReusableCell(withIdentifier: "newsActionsCell", for: indexPath) as! NewsActionsCell
                actionsCell.configure(witch: newsForTable[indexPath.section])
                cell = actionsCell
                return cell
                
            default:
                return cell
                
            }
            
        }
        
        // новость содержит только неизвестный контент
        if !newsForTable[indexPath.section].textrow && !newsForTable[indexPath.section].photorow && !newsForTable[indexPath.section].linkrow && newsForTable[indexPath.section].otherrow {
            
            //  print("Новость \(newsForTable[indexPath.section].text) не содержит контента")
            
            switch indexPath.row {
                
            case 0 :
                let headCell = tableView.dequeueReusableCell(withIdentifier: "newsHeadCell", for: indexPath) as! NewsHeadCell
                headCell.configure(witch: newsForTable[indexPath.section])
                cell = headCell
                return cell
                
            case 1 :
                let textCell = tableView.dequeueReusableCell(withIdentifier: "newsTextCell", for: indexPath) as! NewsTextCell
                textCell.configure(witch: newsForTable[indexPath.section])
                cell = textCell
                return cell
                
            case 2 :
                
                let actionsCell = tableView.dequeueReusableCell(withIdentifier: "newsActionsCell", for: indexPath) as! NewsActionsCell
                actionsCell.configure(witch: newsForTable[indexPath.section])
                cell = actionsCell
                return cell
                
            default:
                return cell
                
            }
            
        }
        
        // новость содержит текст и неизвестный контент
        if newsForTable[indexPath.section].textrow && !newsForTable[indexPath.section].photorow && !newsForTable[indexPath.section].linkrow && newsForTable[indexPath.section].otherrow {
            
            // print("Новость \(newsForTable[indexPath.section].text) не содержит контента")
            
            switch indexPath.row {
                
            case 0 :
                let headCell = tableView.dequeueReusableCell(withIdentifier: "newsHeadCell", for: indexPath) as! NewsHeadCell
                headCell.configure(witch: newsForTable[indexPath.section])
                cell = headCell
                return cell
                
            case 1 :
                let textCell = tableView.dequeueReusableCell(withIdentifier: "newsTextCell", for: indexPath) as! NewsTextCell
                textCell.configure(witch: newsForTable[indexPath.section])
                cell = textCell
                return cell
                
            case 2 :
                let textCell = tableView.dequeueReusableCell(withIdentifier: "newsTextCell", for: indexPath) as! NewsTextCell
                textCell.configure(witch: newsForTable[indexPath.section])
                cell = textCell
                return cell
                
            case 3 :
                
                let actionsCell = tableView.dequeueReusableCell(withIdentifier: "newsActionsCell", for: indexPath) as! NewsActionsCell
                actionsCell.configure(witch: newsForTable[indexPath.section])
                cell = actionsCell
                return cell
                
            default:
                return cell
                
            }
            
        }
        
        
        // новость содержит только текстовый контент
        if newsForTable[indexPath.section].textrow && !newsForTable[indexPath.section].photorow &&  !newsForTable[indexPath.section].linkrow {
            
            //  print("Новость \(newsForTable[indexPath.section].text)\n содержит только ТЕКСТ")
            
            
            switch indexPath.row {
                
            case 0 :
                let headCell = tableView.dequeueReusableCell(withIdentifier: "newsHeadCell", for: indexPath) as! NewsHeadCell
                headCell.configure(witch: newsForTable[indexPath.section])
                cell = headCell
                return cell
                
            case 1 :
                let textCell = tableView.dequeueReusableCell(withIdentifier: "newsTextCell", for: indexPath) as! NewsTextCell
                textCell.configure(witch: newsForTable[indexPath.section])
                cell = textCell
                return cell
                
            case 2 :
                let actionsCell = tableView.dequeueReusableCell(withIdentifier: "newsActionsCell", for: indexPath) as! NewsActionsCell
                actionsCell.configure(witch: newsForTable[indexPath.section])
                cell = actionsCell
                return cell
                
            default:
                return cell
                
            }
            
        }
        
        //новость содержит только ссылочный контент
        if !newsForTable[indexPath.section].textrow && !newsForTable[indexPath.section].photorow &&  newsForTable[indexPath.section].linkrow {
            
            //  print("Новость \(newsForTable[indexPath.section].text) \nсодержит только ССЫЛКУ")
            
            switch indexPath.row {
                
            case 0 :
                let headCell = tableView.dequeueReusableCell(withIdentifier: "newsHeadCell", for: indexPath) as! NewsHeadCell
                headCell.configure(witch: newsForTable[indexPath.section])
                cell = headCell
                return cell
                
            case 1 :
                let linkCell = tableView.dequeueReusableCell(withIdentifier: "newsLinkCell", for: indexPath) as! NewsLinkCell
                linkCell.configure(witch: newsForTable[indexPath.section])
                cell = linkCell
                return cell
                
            case 2 :
                let actionsCell = tableView.dequeueReusableCell(withIdentifier: "newsActionsCell", for: indexPath) as! NewsActionsCell
                actionsCell.configure(witch: newsForTable[indexPath.section])
                cell = actionsCell
                return cell
                
            default:
                return cell
                
            }
            
        }
        
        // новость содержит только фото контент
        if !newsForTable[indexPath.section].textrow && newsForTable[indexPath.section].photorow &&  !newsForTable[indexPath.section].linkrow {
            
            //   print("Новость \(newsForTable[indexPath.section].text) \nсодержит только ФОТО")
            
            
            switch indexPath.row {
                
            case 0 :
                let headCell = tableView.dequeueReusableCell(withIdentifier: "newsHeadCell", for: indexPath) as! NewsHeadCell
                headCell.configure(witch: newsForTable[indexPath.section])
                cell = headCell
                return cell
                
                
            case 1 :
                let photoCell = tableView.dequeueReusableCell(withIdentifier: "newsPhotoCell", for: indexPath) as! NewsPhotoCell
                photoCell.configure(witch: newsForTable[indexPath.section])
                cell = photoCell
                return cell
                
                
            case 2 :
                let actionsCell = tableView.dequeueReusableCell(withIdentifier: "newsActionsCell", for: indexPath) as! NewsActionsCell
                actionsCell.configure(witch: newsForTable[indexPath.section])
                cell = actionsCell
                return cell
                
                
            default:
                return cell
                
            }
            
        }
        
        //новость содержит текст и фото и не содержит ссылку
        if newsForTable[indexPath.section].textrow && newsForTable[indexPath.section].photorow &&  !newsForTable[indexPath.section].linkrow {
            
            
            
            //  print("Новость \(newsForTable[indexPath.section].text) \nсодержит ТЕКСТ и ФОТО и несодержит ССЫЛКУ")
            
            switch indexPath.row {
                
            case 0 :
                let headCell = tableView.dequeueReusableCell(withIdentifier: "newsHeadCell", for: indexPath) as! NewsHeadCell
                headCell.configure(witch: newsForTable[indexPath.section])
                cell = headCell
                return cell
                
                
                
            case 1 :
                let textCell = tableView.dequeueReusableCell(withIdentifier: "newsTextCell", for: indexPath) as! NewsTextCell
                textCell.configure(witch: newsForTable[indexPath.section])
                cell = textCell
                return cell
                
                
            case 2 :
                let photoCell = tableView.dequeueReusableCell(withIdentifier: "newsPhotoCell", for: indexPath) as! NewsPhotoCell
                photoCell.configure(witch: newsForTable[indexPath.section])
                cell = photoCell
                return cell
                
                
            case 3 :
                let actionsCell = tableView.dequeueReusableCell(withIdentifier: "newsActionsCell", for: indexPath) as! NewsActionsCell
                actionsCell.configure(witch: newsForTable[indexPath.section])
                cell = actionsCell
                return cell
                
                
            default:
                return cell
                
            }
            
        }
        
        //новость содержит текст и ссылку и не содержит фото
        if newsForTable[indexPath.section].textrow && !newsForTable[indexPath.section].photorow &&  newsForTable[indexPath.section].linkrow {
            
            //  print("Новость \(newsForTable[indexPath.section].text) \nсодержит ТЕКСТ и ССЫЛКУ и несодержит ФОТО")
            
            
            switch indexPath.row {
                
            case 0 :
                let headCell = tableView.dequeueReusableCell(withIdentifier: "newsHeadCell", for: indexPath) as! NewsHeadCell
                headCell.configure(witch: newsForTable[indexPath.section])
                cell = headCell
                return cell
                
                
                
            case 1 :
                let textCell = tableView.dequeueReusableCell(withIdentifier: "newsTextCell", for: indexPath) as! NewsTextCell
                textCell.configure(witch: newsForTable[indexPath.section])
                cell = textCell
                return cell
                
                
            case 2 :
                let linkCell = tableView.dequeueReusableCell(withIdentifier: "newsLinkCell", for: indexPath) as! NewsLinkCell
                linkCell.configure(witch: newsForTable[indexPath.section])
                cell = linkCell
                return cell
                
                
            case 3 :
                let actionsCell = tableView.dequeueReusableCell(withIdentifier: "newsActionsCell", for: indexPath) as! NewsActionsCell
                actionsCell.configure(witch: newsForTable[indexPath.section])
                cell = actionsCell
                return cell
                
                
            default:
                return cell
                
            }
            
        }
        
        //новость содержит текст и ссылку и фото
        if newsForTable[indexPath.section].textrow && newsForTable[indexPath.section].photorow && newsForTable[indexPath.section].linkrow {
            
            //  print("Новость \(newsForTable[indexPath.section].text) \nсодержит ТЕКСТ и ССЫЛКУ и ФОТО")
            
            
            switch indexPath.row {
                
            case 0 :
                let headCell = tableView.dequeueReusableCell(withIdentifier: "newsHeadCell", for: indexPath) as! NewsHeadCell
                headCell.configure(witch: newsForTable[indexPath.section])
                cell = headCell
                return cell
                
                
                
            case 1 :
                let textCell = tableView.dequeueReusableCell(withIdentifier: "newsTextCell", for: indexPath) as! NewsTextCell
                textCell.configure(witch: newsForTable[indexPath.section])
                cell = textCell
                return cell
                
                
            case 2 :
                let photoCell = tableView.dequeueReusableCell(withIdentifier: "newsPhotoCell", for: indexPath) as! NewsPhotoCell
                photoCell.configure(witch: newsForTable[indexPath.section])
                cell = photoCell
                return cell
                
                
            case 3 :
                let linkCell = tableView.dequeueReusableCell(withIdentifier: "newsLinkCell", for: indexPath) as! NewsLinkCell
                linkCell.configure(witch: newsForTable[indexPath.section])
                cell = linkCell
                return cell
                
                
            case 4 :
                let actionsCell = tableView.dequeueReusableCell(withIdentifier: "newsActionsCell", for: indexPath) as! NewsActionsCell
                actionsCell.configure(witch: newsForTable[indexPath.section])
                cell = actionsCell
                return cell
                
                
            default:
                return cell
                
            }
            
        }
        
        return cell
        
    }
}
