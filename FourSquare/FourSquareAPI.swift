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
        Alamofire.request(.GET, "http://httpbin.org/get", parameters: ["foo": "bar"])
            .response { request, response, data, error in
                println(request)
                println(response)
                println(error)
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
