//
//  FourSquareAPI.swift
//  FourSquareAPI
//
//  Created by Zian Chen on 8/19/15.
//  Copyright (c) 2015 Zian Mobile Development. All rights reserved.
//

import Alamofire

class FourSquareAPI: NSObject {
    
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
    
    
    //Singleton
    class var sharedInstance: FourSquareAPI {
        struct Singleton {
            static let instance = FourSquareAPI()
        }
        return Singleton.instance
    }
    
    
    
}
