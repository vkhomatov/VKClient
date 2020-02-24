//
//  NewsController.swift
//  MH VK Client 1.0
//
//  Created by Vit on 02/10/2019.
//  Copyright © 2019 Macrohard. All rights reserved.
//

//typealias Constraint = NSLayoutConstraint
//typealias Constraints = [NSLayoutConstraint]


import UIKit

class NewsController: UITableViewController {
    
    var myNews =  News(news: [("Процессор Сергеевич Изморозь","01.01.2001","Привет, никак не могу настроить правильное отображение картинки в UIImage, UIImage у меня в ячейке, делаю через сториборд, фото то растягивается по вертикали с искажением пропорций, то отображается в нормальных пропорциях но посередине UIImage, но сам UIImage сохраняет прежний размер по вертикали.", UIImage(named: "News1")), ("Политика","01.02.2001","Привет, никак не могу настроить правильное отображение картинки в UIImage, UIImage у меня в ячейке, делаю через сториборд, фото то растягивается по вертикали с искажением пропорций, то отображается в нормальных пропорциях но посередине UIImage, но сам UIImage сохраняет прежний размер по вертикали.", UIImage(named: "News2")), ("Экономика", "01.03.2001","Привет, никак не могу настроить правильное отображение картинки в UIImage, UIImage у меня в ячейке, делаю через сториборд, фото то растягивается по вертикали с искажением пропорций, то отображается в нормальных пропорциях но посередине UIImage, но сам UIImage сохраняет прежний размер по вертикали.", UIImage(named: "News3"))])
    
    var myNewsAction = NewsActions(newsAction: [(likeUser: true, likes: 10, comments: 200, reposts: 3000, views: 40000), (likeUser: false, likes: 20, comments: 300, reposts: 4000, views: 50000), (likeUser: false, likes: 30, comments: 400, reposts: 5000, views: 60000)])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return myNews.news.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
           
        return " "
           
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell: UITableViewCell
        var cellsCount: Int = 0
       // var photoPresent: Bool = true
        
        switch indexPath.row {
        case 0 :
            let headCell = tableView.dequeueReusableCell(withIdentifier: "newsHeadCell", for: indexPath) as! NewsHeadCell
            headCell.nameLabel.text = myNews.news[indexPath.section].name
            headCell.dateLabel.text = myNews.news[indexPath.section].date
            headCell.headPhoto.image = myNews.news[indexPath.section].pic
            cell = headCell
            
        case 1 :
            let textCell = tableView.dequeueReusableCell(withIdentifier: "newsTextCell", for: indexPath) as! NewsTextCell
            textCell.messageLabel.text = myNews.news[indexPath.section].text
            cell = textCell
            
        case 2 :
            // написать условия
            //if photoPresent {
            let photoCell = tableView.dequeueReusableCell(withIdentifier: "newsPhotoCell", for: indexPath) as! NewsPhotoCell
            photoCell.newsPhoto.image = myNews.news[indexPath.section].pic
           // }
            cell = photoCell
            cellsCount += 1
            
            
        case 3://2+cellsCount :
            let actionsCell = tableView.dequeueReusableCell(withIdentifier: "newsActionsCell", for: indexPath) as! NewsActionsCell
            actionsCell.likeCount.text = String(myNewsAction.newsAction[indexPath.section].likes)
            actionsCell.commentsCount.text = String(myNewsAction.newsAction[indexPath.section].comments)
            actionsCell.repostCount.text = String(myNewsAction.newsAction[indexPath.section].reposts)
            actionsCell.viewsCount.text = String(myNewsAction.newsAction[indexPath.section].views)
            
            
            cell = actionsCell
            
                        
        default:
            let headCell = tableView.dequeueReusableCell(withIdentifier: "newsHeadCell", for: indexPath) as! NewsHeadCell
            cell = headCell
    
        }
        
        return cell
        
        
     
    }
    
    
}
