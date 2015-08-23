//
//  FSEndPointUser.swift
//  FourSquareAPI
//
//  Created by Zian Chen on 8/22/15.
//  Copyright (c) 2015 Zian Mobile Development. All rights reserved.
//

import Foundation
import CoreLocation

extension FourSquareAPI {
    
    //MARK: USERS - GENERAL
    class func getUser(userId :String) {
        var url = FSEndpoint.Users.rawValue + "/" + userId
        Manager.sharedInstance.request(method: .GET, URLString: url, parameters: nil, isUserless:!(userId == FSSelfUserId))
    }
    
    //https://developer.foursquare.com/docs/users/requests
    class func userPendingFriendRequests() {
        var url = FSEndpoint.Users.rawValue + "/" + "/requests"
        Manager.sharedInstance.request(method: .GET, URLString: url, parameters: nil, isUserless:false)
    }
    
    //https://developer.foursquare.com/docs/users/search
    class func userSearch(#phone :String?, email :String?, twitter :String?, twitterSource :String?, fbid :String?, name :String?, onlyPages :Bool = false) {
        var params = Dictionary<String, String>()
        if (phone != nil)               {params["phone"] = phone}
        if (email != nil)               {params["email"] = email}
        if (twitter != nil)             {params["twitter"] = twitter}
        if (twitterSource != nil)       {params["twitterSource"] = twitterSource}
        if (fbid != nil)                {params["fbid"] = fbid}
        if (name != nil)                {params["name"] = name}
        if (onlyPages)                  {params["onlyPages"] = "true"}
        
        var url = FSEndpoint.Users.rawValue + "/search"
        Manager.sharedInstance.request(method: .GET, URLString: url, parameters: params, isUserless:false)
    }
    
    //MARK: USERS - ASPECTS
    //https://developer.foursquare.com/docs/users/checkins
    class func userCheckinsHistory(limit :Int = FSDefaultFetchLimit, offset :Int = 0, sort :FSCheckinSort = .NewestFirst, afterTimestamp :NSTimeInterval, beforeTimestamp :NSTimeInterval) {
        
        var params = Dictionary<String, String>()
        params["limit"] = String(limit)
        params["offset"] = String(offset)
        params["sort"] = sort.rawValue
        
        if afterTimestamp > 0 {params["afterTimestamp"] = String(format: "%.0f", afterTimestamp)}
        if beforeTimestamp > 0 {params["beforeTimestamp"] = String(format: "%.0f", beforeTimestamp)}
        
        var url = FSEndpoint.Users.rawValue + "/" + FSSelfUserId + "/checkins"
        Manager.sharedInstance.request(method: .GET, URLString: url, parameters: params, isUserless:false)
    }
    
    //https://developer.foursquare.com/docs/users/friends
    class func userListFriends(#userId :String, limit :Int = FSDefaultFetchLimit, offset :Int = 0) {
        
        var params = Dictionary<String, String>()
        params["limit"] = String(limit)
        params["offset"] = String(offset)
        
        var url = FSEndpoint.Users.rawValue + "/" + userId + "/friends"
        Manager.sharedInstance.request(method: .GET, URLString: url, parameters: params, isUserless:!(userId == FSSelfUserId))
    }
    
    class func userLists(#userId :String, group :String = FSUserListGroup.Edited.rawValue, ll: CLLocationCoordinate2D, limit :Int = FSDefaultFetchLimit, offset :Int = 0) {
        
        var params = Dictionary<String, String>()
        params["limit"] = "\(limit)"
        params["offset"] = "\(offset)"
        params["group"] = group
        if CLLocationCoordinate2DIsValid(ll) {params["ll"] = "\(ll.latitude), \(ll.longitude)"}
        
        var url = FSEndpoint.Users.rawValue + "/" + userId + "/lists"
        Manager.sharedInstance.request(method: .GET, URLString: url, parameters: params, isUserless:!(userId == FSSelfUserId))
    }
    
    //MARK: USERS - ACTIONS

}