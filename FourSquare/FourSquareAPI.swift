//
//  FourSquareAPI.swift
//  FourSquareAPI
//
//  Created by Zian Chen on 8/19/15.
//  Copyright (c) 2015 Zian Mobile Development. All rights reserved.
//

import Foundation

public let FourSquareDefaultFetchLimit = 1

public func requestUser(userId :String) {
    
}

public func requestVenueNearLocation(location :String) {
    var fetchParams = Dictionary(dictionaryLiteral:("near", location), ("limit", String(FourSquareDefaultFetchLimit)))
    Manager.sharedInstance.request("https://api.foursquare.com/v2/venues/explore", parameters: fetchParams)
}