//
//  Manager.swift
//  FourSquareAPI
//
//  Created by Chen, Zian on 8/19/15.
//  Copyright (c) 2015 Zian Mobile Development. All rights reserved.
//

import Alamofire

let FSDefaultParameters = ["v":"20140806", "client_id":FSClientId, "client_secret":FSClientSecret]
let FSUsersURL = "https://api.foursquare.com/v2/users"
let FSVenuesURL = "https://api.foursquare.com/v2/venues/explore"

enum FSMode: String {
    case FourSquare = "foursquare"
    case Swarm = "swarm"
}

public class Manager {
    
    var latestAccessToken = NSUserDefaults.getFSOAuthAccessToken()
    
    func request(#method :Method, URLString :URLStringConvertible, parameters :Dictionary <String, String>?, isUserless :Bool = true, mode :FSMode = .FourSquare) {
        
        var fetchParams = parameters
        if (parameters != nil) {
            fetchParams!.merge(FSDefaultParameters)
        } else {
            fetchParams = FSDefaultParameters
        }
        
        fetchParams!["m"] = mode.rawValue //Support swarm
        
        if !isUserless && latestAccessToken != nil {
            fetchParams!["oauth_token"] = latestAccessToken
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
