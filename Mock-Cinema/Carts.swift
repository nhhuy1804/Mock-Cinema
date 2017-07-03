//
//  Carts.swift
//  Mock-Cinema
//
//  Created by Cntt35 on 6/14/17.
//  Copyright © 2017 Huy. All rights reserved.
//

import Foundation

class Carts {
    var title: String?
    var seat: String?
    var time: String?
    var bookingDate: String?
    var status: String?
    var dateShown: String?
    
    init(json: [String:Any]) {
        title = json["title"] as? String
        seat = json["seat"] as? String
        time = json["time"] as? String
        bookingDate = json["bookingDate"] as? String
        status = json["status"] as? String
        dateShown = json["dateShown"] as? String
    }
}
