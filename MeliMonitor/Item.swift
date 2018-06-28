//
//  Item.swift
//  MeliMonitor
//
//  Created by Ricardo Umpierrez on 6/2/18.

//

import Foundation
import ObjectMapper

class Item: Mappable {
    var id: String = ""
    var title: String?;
    var price: Int = 0;
    var permalink: String?
    var thumbnail: String?;

    required init?(map: Map){
        
    }

    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        price <- map["price"]
        permalink <- map["permalink"]
        thumbnail <- map["thumbnail"]
    }
}
