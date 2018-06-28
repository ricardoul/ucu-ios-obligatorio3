//
//  MLResponse.swift
//  MeliMonitor
//
//  Created by Ricardo Umpierrez on 6/2/18.

//

import Foundation

//
//  Item.swift
//  MeliMonitor
//
//  Created by Ricardo Umpierrez on 6/2/18.

//

import Foundation
import ObjectMapper

class MLResponse: Mappable {
    var query: String?;
    var results: [Item]?;
    var availabeFilters :[Filters]?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        query <- map["query"]
        results <- map["results"]
        availabeFilters <- map["available_filters"]

    }
}
