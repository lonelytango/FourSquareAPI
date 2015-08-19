//
//  Manager.swift
//  FourSquareAPI
//
//  Created by Chen, Zian on 8/19/15.
//  Copyright (c) 2015 Zian Mobile Development. All rights reserved.
//

import Alamofire

let FSDefaultParameters = ["v":"20140806", "m":"foursquare", "client_id":FSClientId, "client_secret":FSClientSecret]

public class Manager {
    
    var latestAccessCode = NSUserDefaults.getFourSquareOAuthAccessKey()
    
    func request(#method: Method, URLString: URLStringConvertible, parameters: Dictionary <String, String>?) {
        
        var fetchParams = parameters
        if (parameters != nil) {
            fetchParams!.merge(FSDefaultParameters)
        } else {
            fetchParams = FSDefaultParameters
        }
        
        Alamofire.request(method, URLString, parameters: fetchParams)
            .responseJSON { request, response, JSON, _ in
                println(request)
                println(JSON)
        }
    }
    
    //Singleton
    public static let sharedInstance: Manager = {
        struct Singleton {
            static let instance = Manager()
        }
        return Singleton.instance
    }()
}

extension Dictionary {
    mutating func merge<K, V>(dict: [K: V]){
        for (k, v) in dict {
            self.updateValue(v as! Value, forKey: k as! Key)
        }
    }
}
