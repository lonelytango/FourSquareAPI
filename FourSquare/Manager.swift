//
//  Manager.swift
//  FourSquareAPI
//
//  Created by Chen, Zian on 8/19/15.
//  Copyright (c) 2015 Zian Mobile Development. All rights reserved.
//

import Alamofire

extension Dictionary {
    mutating func merge<K, V>(dict: [K: V]){
        for (k, v) in dict {
            self.updateValue(v as! Value, forKey: k as! Key)
        }
    }
}

let FSClientId = "K2EJ4LYIPLLVB42VMWRAADPETIAQIZGPERXJBRPWOICZYBHY"
let FSClientSecret = "TAOWRLEICGFO4F2VDNDAG2FOEKN1JK1FXLK42ZDBW1EUFRTV"
let FSDefaultParameters = ["v":"20140806", "m":"foursquare", "client_id":FSClientId, "client_secret":FSClientSecret]

public class Manager {
    
    func request(URLString: URLStringConvertible, parameters: Dictionary <String, String>) {
        
        var fetchParams = parameters
        fetchParams.merge(FSDefaultParameters)
        
        Alamofire.request(.GET, URLString, parameters: fetchParams)
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