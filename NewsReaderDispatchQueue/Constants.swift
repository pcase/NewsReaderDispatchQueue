//
//  Constants.swift
//  NewsReaderCollectionView
//
//  Created by Patty Case on 3/31/20.
//  Copyright © 2020 Azure Horse Creations. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Keys {
        static let CNN_API_KEY = "2624297672fe4e60b7d9316027ccec42"
    }
    
    struct Urls {
        static let CNN_URL = "https://newsapi.org/v2/top-headlines?country=us"
        static let CNN_API_URL = Constants.Urls.CNN_URL + "&apiKey=" + Constants.Keys.CNN_API_KEY
    }
}
