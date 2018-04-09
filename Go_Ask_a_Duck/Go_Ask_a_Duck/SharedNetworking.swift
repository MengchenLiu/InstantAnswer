//
//  SharedNetworking.swift
//  Go_Ask_a_Duck
//
//  Created by Mengchen Liu on 2/15/17.
//  Copyright © 2017 Mengchen Liu. All rights reserved.
//

import Foundation
import UIKit

class SharedNetworking{
    var results = [result]()
    func hhh(_ add:String?, _ completionHandler: (([result]?) -> Void)?){
        
        results.removeAll()
        //- Attribution:https://www.ioscreator.com/tutorials/display-activity-indicator-status-bar-ios8-swift
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let defaultConfiguration = URLSessionConfiguration.default
        
        let sessionWithoutADelegate = URLSession(configuration: defaultConfiguration)
        
        let url = URL(string: add!)
        

        
        let task = sessionWithoutADelegate.dataTask(with: url!){
                (data, response, error) in
            
                if error != nil {
                    print("Error: \(error)")
                } else if let _ = response,
                    let data = data,
                    let _ = String(data: data, encoding: .utf8) {
                    self.updateSearchResults(data)
                    completionHandler!(self.results)
                }
                else{fatalError("error was nil, but no data. This should never happen")}
            }
            
        task.resume()
    }
    
    func updateSearchResults(_ data: Data?) {
        do {
            if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]{
                if let ele = json["RelatedTopics"] as? [Any]{
                    for res in ele{
                        if let res=res as? [String:Any]{
                            if let uu = res["FirstURL"] as? String, let rr = res["Result"] as? String{
                                let text = rr.components(separatedBy: "</a>")
                                let tt = text[1]
                              results.append(result(url: uu, text: tt))
                            }
                        }else{
                            print("Not a dictionary")
                        }
                    }
                }else{
                    print("Not an array")
                }
            } else {
                print("Results key not found in dictionary")
            }
        }
    }
    
}
