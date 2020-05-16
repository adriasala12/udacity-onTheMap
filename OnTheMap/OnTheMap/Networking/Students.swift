//
//  Students.swift
//  OnTheMap
//
//  Created by Adrià Sala Roget on 30/04/2020.
//  Copyright © 2020 Adrià Sala Roget. All rights reserved.
//

import Foundation
import UIKit

class Students {
    
    static var results = [Location]()
    
    struct Location: Codable {
        var objectId: String
        var uniqueKey: String
        var firstName: String
        var lastName: String
        var mapString: String
        var mediaURL: String
        var latitude: Float
        var longitude: Float
    }
    
    class func getLocationsRequest(completion: ((Bool) -> Void)? = nil) {
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt")!)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: {(data, request, error) in
            
            guard let data = data else {
                completion?(false)
                return
            }
            
            var t: [String: [Location]]
            
            let decoder = JSONDecoder()
            t = try! decoder.decode([String: [Location]].self, from: data)
            
            for value in t.values {
                results.append(contentsOf: value)
            }
            
            if (results.count != 0) { completion?(true) }
            
//            print(results)
        })
        task.resume()

    }
    
    class func reload() {
        getLocationsRequest()
    }
    
}
