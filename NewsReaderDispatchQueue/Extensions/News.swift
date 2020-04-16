//
//  News.swift
//  NewsReader
//
//  Created by Patty Case on 3/30/19.
//  Copyright © 2019 Azure Horse Creations. All rights reserved.
//

import Foundation
import UIKit

/// Major parts of news stories
class News: NSObject {
    
    var title: String = ""
    var publish_date: String = ""
    var summary: String = ""
    var image_url: String = ""
    var image: UIImage?
    var imageName: String = ""
}
