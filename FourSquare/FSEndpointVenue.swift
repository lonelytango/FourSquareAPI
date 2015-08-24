//
//  FSEndpointVenue.swift
//  FourSquareAPI
//
//  Created by Zian Chen on 8/23/15.
//  Copyright (c) 2015 Zian Mobile Development. All rights reserved.
//

import Foundation
import CoreLocation

extension FourSquareAPI {
    
    //https://developer.foursquare.com/docs/venues/categories
    class func venusCategories() {
        var url = FSEndpoint.Venues.rawValue + "/categories"
        Manager.sharedInstance.request(method: .GET, URLString: url)
    }
    
    //https://developer.foursquare.com/docs/venues/explore
    class func getVenueNearLocation(near :String, ll: CLLocationCoordinate2D, limit :Int = FourSquareDefaultFetchLimit) {
        
        var params = Dictionary<String, String>()
        
        if near != nil {params["near"] = near}
        if CLLocationCoordinate2DIsValid(ll) {params["ll"] = "\(ll.latitude), \(ll.longitude)"}
        
        var url = FSEndpoint.Venues.rawValue + "/explore"
        Manager.sharedInstance.request(method: .GET, URLString: url, parameters: params)
    }
}