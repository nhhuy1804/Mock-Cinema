//
//  Movie.swift
//  Mock-Cinema
//
//  Created by MrDummy on 6/8/17.
//  Copyright © 2017 Huy. All rights reserved.
//

import Foundation
import UIKit

class Movie {
    var id: Int?
    var title: String?
    var posterURL: String?
    var overview: String?
    var releaseInformation: String?
    var runTime: String?
    var originalLanguage: String?
    var budget: String?
    var image: UIImage?
    var urlTrailer: String?
    
    init(json: [String:Any]) {
        id = json["id"] as? Int
        title = json["title"] as? String
        posterURL = json["posterURL"] as? String
        overview = json["overview"] as? String
        releaseInformation = json["releaseInformation"] as? String
        runTime = json["runTime"] as? String
        originalLanguage = json["originalLanguage"] as? String
        budget = json["budget"] as? String
        urlTrailer = json["urlTrailer"] as? String
    }
    
}
