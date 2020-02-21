//
//  NewsController.swift
//  MH VK Client 1.0
//
//  Created by Vit on 02/10/2019.
//  Copyright © 2019 Macrohard. All rights reserved.
//

import UIKit

class NewsController: UITableViewController {
    
    var myNews =  News(news: [("Общество", UIImage(named: "News1")), ("Политика", UIImage(named: "News2")), ("Экономика", UIImage(named: "News3"))])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myNews.news.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        
        cell.newsNameLabel.text = myNews.news[indexPath.row].name
        cell.newsPicImage?.image = myNews.news[indexPath.row].pic
        
        return cell
        // Configure the cell...
        
    }
    
    
}
