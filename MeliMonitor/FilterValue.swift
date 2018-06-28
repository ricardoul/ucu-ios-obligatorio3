//
//  Item.swift
//  MeliMonitor
//
//  Created by Ricardo Umpierrez on 6/2/18.

//

import Foundation
import ObjectMapper

class FilterValue: Mappable {
    var id: String = ""
    var name: String?;
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}
