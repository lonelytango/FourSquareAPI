//
//  FourSquareAPI.swift
//  FourSquareAPI
//
//  Created by Zian Chen on 8/19/15.
//  Copyright (c) 2015 Zian Mobile Development. All rights reserved.
//

import Foundation
import FSOAuth
import CoreLocation

let FourSquareDefaultFetchLimit = 1
let FSDefaultFetchLimit = 10
let FSSelfUserId = "self"

let FSOAuthAccessTokenKey = "kFourSquareOAuthAccessToken"
let FSClientId = "K2EJ4LYIPLLVB42VMWRAADPETIAQIZGPERXJBRPWOICZYBHY"
let FSClientSecret = "TAOWRLEICGFO4F2VDNDAG2FOEKN1JK1FXLK42ZDBW1EUFRTV"

let FSRedirectURL = "foursquareapi://authorized"
let FSRedirectURLScheme = "foursquareapi"

//MARK: SETUP

enum FSCheckinSort: String {
    case NewestFirst = "newestfirst"
    case OldestFirst = "oldestfirst"
}

enum FSUserListGroup: String, Equatable {
    case Created = "created"
    case Followed = "followed"
    case Edited = "edited"
    case Friends = "friends"
    case Suggested = "suggested"
}
class FourSquareAPI :NSObject {
    
    class func handleUrl(url :NSURL) {
        if url.scheme == FSRedirectURLScheme {
            var errorCode :FSOAuthErrorCode = .None
            var accessCode = FSOAuth.accessCodeForFSOAuthURL(url, error: &errorCode)
            
            if errorCode == FSOAuthErrorCode.None {
                println("Access Code: \(accessCode)")
                
                FSOAuth.requestAccessTokenForCode(accessCode, clientId: FSClientId, callbackURIString:FSRedirectURL, clientSecret: FSClientSecret, completionBlock: { (accessToken, requestComplete, errorCode) -> Void in
                    if (requestComplete) {
                        Manager.sharedInstance.latestAccessToken = accessToken
                        NSUserDefaults.setFSOAuthAccessToken(accessToken)
                        println("Access Token: \(accessToken)")
                    } else {
                        let errorMessage = ErrorHandling.oauthErrorMessageForCode(errorCode)
                        println("Error Message: \(errorMessage)")
                    }
                })
                
            } else {
                let errorMessage = ErrorHandling.oauthErrorMessageForCode(errorCode)
                println("Error Message: \(errorMessage)")
            }
        }
    }
    
    class func setupOAuthAccessCode() {
        //Note that OAuth Key will not be expired once set up.
        
        let accessToken = NSUserDefaults.getFSOAuthAccessToken()
        if accessToken == nil {
            var statusCode :FSOAuthStatusCode = FSOAuth.authorizeUserUsingClientId(FSClientId, callbackURIString: FSRedirectURL)
            var errorMessage = ErrorHandling.oauthStatusErrorMessageForCode(statusCode)
            println("OAuth Status: \(errorMessage)")
            
        } else {
            //Check if the OAuth key is valid.
            Manager.sharedInstance.latestAccessToken = accessToken
            println("Access Token already setup: \(accessToken)")
        }
    }
    
    
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
    
    
    //MARK: VENUE
    class func getVenueNearLocation(location :String, limit :Int = FourSquareDefaultFetchLimit) {
        var fetchParams = ["near":location, "limit":String(limit)]
        var url = FSEndpoint.Venues.rawValue + "/explore"
        Manager.sharedInstance.request(method: .GET, URLString: url, parameters: fetchParams)
    }
}


//MARK: EXTENSION

extension NSUserDefaults {
    class func setFSOAuthAccessToken(accessKey :NSString) {
        NSUserDefaults.standardUserDefaults().setObject(accessKey, forKey: FSOAuthAccessTokenKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func getFSOAuthAccessToken() -> String? {
        return NSUserDefaults.standardUserDefaults().stringForKey(FSOAuthAccessTokenKey)
    }
}
