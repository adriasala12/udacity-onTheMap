//
//  Authentication.swift
//  OnTheMap
//
//  Created by Adrià Sala Roget on 30/04/2020.
//  Copyright © 2020 Adrià Sala Roget. All rights reserved.
//

import Foundation
import MapKit

class User {
    
    static var authData: Auth?
    static var userData: UserInfo?
    static var userLocation: CLLocationCoordinate2D?
    static var userURL: String?
    
    struct Auth: Codable {
        var account: Account
        var session: Session
    }
    
    struct Account: Codable {
        var registered: Bool
        var key: String
    }
    
    struct Session: Codable {
        var id: String
        var expiration: String
    }
    
    struct UserInfo : Codable {
        let first_name : String
        let last_name : String
        let key : String
        
    }
    
    class func authenticationRequest(username: String, password: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            
            guard let data = data else {
                completionHandler(false, error)
                return
            }
            
            let range = 5..<data.count
            let newData = data.subdata(in: range)

            let decoder = JSONDecoder()
            do {
                authData = try decoder.decode(Auth.self, from: newData)
                completionHandler(true, nil)
            } catch {
                completionHandler(false, error)
            }
        })
        task.resume()
    }
    
    class func postLocationRequest(completion: ((Bool) -> Void)? = nil) {
        
        getUserDataRequest(completion: {
            var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\"uniqueKey\": \"\(userData!.key)\", \"firstName\": \"\(userData!.first_name)\", \"lastName\": \"\(userData!.last_name)\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil {
                    completion?(false)
                    return
                }
//                 print(String(data: data!, encoding: .utf8)!)
            }
            task.resume()
            completion?(true)
        })
    }
    
    class func getUserDataRequest(completion: (() -> Void)? = nil) {
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(User.authData!.account.key)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error...
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
//          print(String(data: newData!, encoding: .utf8)!)
            
        let decoder = JSONDecoder()
        do {
            userData = try decoder.decode(UserInfo.self, from: newData!)
//            print(userData!)
            completion!()
        } catch {
            print("error")
        }
            
        }
        task.resume()
    }
    
    class func deleteSessionRequest() {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
          print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
    
}
