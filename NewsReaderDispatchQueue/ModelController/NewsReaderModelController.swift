//
//  NewsReaderModelController.swift
//  NewsReader
//
//  Created by Patty Case on 3/31/20.
//  Copyright © 2020 Azure Horse Creations. All rights reserved.
//

import Foundation
import UIKit

class NewsReaderModelController {
    
    typealias DownloadComplete = ([AnyObject]) -> ()
    typealias ImageDownloadComplete = (AnyObject) -> ()
    var newsDataList: [News] = []
    
    init() {
    }
    
    /**
     Make a network call to the CNN news API
     
     - Parameter completed: completion handler
     
     - Throws:
     
     - Returns: array of NewsData items
     */
    func downloadNews(apiUrl: String, completed: @escaping DownloadComplete) {
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf:  URL(string: apiUrl)!) {
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let jsonArray = json as? [String: AnyObject] {
                        if let articles = jsonArray["articles"] as? [[String : AnyObject]] {
                            for article in articles {
                                let news = News()
                                if let newsTitle = article["title"] as? String {
                                    news.title = newsTitle
                                }
                                if let desc = article["description"] as? String {
                                       news.desc = desc
                                }
                                if let url = article["url"] as? String {
                                    news.url = url
                                }
                                if let imageUrl = article["urlToImage"] as? String {
                                    news.image_url = imageUrl
                                }
                                if let publishDate = article["publishedAt"] as? String {
                                    news.publish_date = publishDate
                                }
                                if let content = article["content"] as? String {
                                       news.content = content
                                }
                                self.newsDataList.append(news)
                            }
                        }
                    }
                    completed(self.newsDataList)
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /**
     Fetch an image
     
     - Parameter completed: completion handler
     
     - Throws:
     
     - Returns: UIImage
     */
    func downloadImage(imageUrl: String, completed: @escaping ImageDownloadComplete) {
        DispatchQueue.global().async {
            if let tempImageUrl = URL(string: imageUrl) {
                if let data = try? Data(contentsOf: tempImageUrl) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            completed(image)
                        }
                    }
                }
            }
        }
    }
}
