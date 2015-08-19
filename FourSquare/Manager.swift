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


public class Manager {
    
    public static let sharedInstance: Manager = {
        struct Singleton {
            static let instance = Manager()
        }
        return Singleton.instance
    }()
    
    
    func testCall() {
        //client_id=CLIENT_ID&client_secret=CLIENT_SECRET
        var parameters = Dictionary(dictionaryLiteral:
            ("near", "New York, NY"),
            ("v", "20140806"),
            ("m", "foursquare"),
            ("client_id", "K2EJ4LYIPLLVB42VMWRAADPETIAQIZGPERXJBRPWOICZYBHY"),
            ("client_secret", "TAOWRLEICGFO4F2VDNDAG2FOEKN1JK1FXLK42ZDBW1EUFRTV"),
            ("limit", 5))
        
        Alamofire.request(.GET, "https://api.foursquare.com/v2/venues/explore", parameters:parameters)
            .responseJSON { request, response, JSON, _ in
                println(request)
                println(JSON)
        }
    }
    
    func request(URLString: URLStringConvertible, parameters: [String: AnyObject]) {
        
        var defaultParameters = Dictionary(dictionaryLiteral:
            ("v", "20140806"),
            ("m", "foursquare"),
            ("client_id", "K2EJ4LYIPLLVB42VMWRAADPETIAQIZGPERXJBRPWOICZYBHY"),
            ("client_secret", "TAOWRLEICGFO4F2VDNDAG2FOEKN1JK1FXLK42ZDBW1EUFRTV"))
        
        var fetchParams = parameters
        fetchParams.merge(defaultParameters)
        
        Alamofire.request(.GET, URLString, parameters: fetchParams)
            .responseJSON { request, response, JSON, _ in
                println(request)
                println(JSON)
        }
    }

}