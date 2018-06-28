//
//  Synchronizer.swift
//


import Foundation
import AlamofireObjectMapper
import Alamofire

class Synchronizer{
    
    var failureCounter = 0
    
    static let sharedInstance = Synchronizer()
    
    func fetchItemsBySearchQuery(query:String, completion: @escaping(Bool, [Item]) -> Void){
        
        Alamofire.request(ApiHelper.apiUrl + query).responseArray { (response: DataResponse<[Item]>) in
            if (response.result.isFailure && self.failureCounter < 3){
                self.failureCounter += 1
                self.fetchItemsBySearchQuery(query: query){
                    result, items in
                        completion(result,items)
                }
            }else{
                let responseArray = response.result.value
                if let items = responseArray{
                    completion(true, items)
                }
            }
            
            
            
        }
    }
}
