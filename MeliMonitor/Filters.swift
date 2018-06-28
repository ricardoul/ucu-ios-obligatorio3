//
//  Item.swift
//  MeliMonitor
//
//  Created by Ricardo Umpierrez on 6/2/18.

//

import Foundation
import ObjectMapper

class Filters: Mappable {
    var id: String = ""
    var name: String?;
    var values: [FilterValue]?;
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        values <- map["values"]
    }
}
