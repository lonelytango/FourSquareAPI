//
//  FourSquareAPI.swift
//  FourSquareAPI
//
//  Created by Zian Chen on 8/19/15.
//  Copyright (c) 2015 Zian Mobile Development. All rights reserved.
//

import Foundation
import FSOAuth

let FourSquareDefaultFetchLimit = 1
let FSOAuthAccessTokenKey = "kFourSquareOAuthAccessToken"
let FSClientId = "K2EJ4LYIPLLVB42VMWRAADPETIAQIZGPERXJBRPWOICZYBHY"
let FSClientSecret = "TAOWRLEICGFO4F2VDNDAG2FOEKN1JK1FXLK42ZDBW1EUFRTV"

let FSRedirectURL = "foursquareapi://authorized"
let FSRedirectURLScheme = "foursquareapi"

let FSUsersURL = "https://api.foursquare.com/v2/users"
let FSVenuesURL = "https://api.foursquare.com/v2/venues/explore"
let FSUserEndpointRequest = "requests"

//MARK: SETUP

public func handleUrl(url :NSURL) {
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
                    let errorMessage = oauthErrorMessageForCode(errorCode)
                    println("Error Message: \(errorMessage)")
                }
            })
            
        } else {
            let errorMessage = oauthErrorMessageForCode(errorCode)
            println("Error Message: \(errorMessage)")
        }
    }
}

public func setupOAuthAccessCode() {
    //Note that OAuth Key will not be expired once set up.
    
    let accessToken = NSUserDefaults.getFSOAuthAccessToken()
    if accessToken == nil {
        var statusCode :FSOAuthStatusCode = FSOAuth.authorizeUserUsingClientId(FSClientId, callbackURIString: FSRedirectURL)
        var errorMessage = FourSquareAPI.oauthStatusErrorMessageForCode(statusCode)
        println("OAuth Status: \(errorMessage)")
    
    } else {
        //Check if the OAuth key is valid.
        Manager.sharedInstance.latestAccessToken = accessToken
        println("Access Token already setup: \(accessToken)")
    }
}


//MARK: USERS - GENERAL
public func getUser(userId :String) {
    var fetchUsersURL = FSUsersURL + "/" + userId
    Manager.sharedInstance.request(method: .GET, URLString: fetchUsersURL, parameters: nil)
}

//MARK: USERS - ASPECTS
public func getPendingFriendRequests() {
    var requestURL = FSUsersURL + "/" + FSUserEndpointRequest
    Manager.sharedInstance.request(method: .GET, URLString: requestURL, parameters: nil, isUserless:false)
}

//MARK: USERS - ACTIONS


//MARK: VENUE
public func getVenueNearLocation(location :String, limit :Int = FourSquareDefaultFetchLimit) {
    var fetchParams = ["near":location, "limit":String(limit)]
    Manager.sharedInstance.request(method: .GET, URLString: FSVenuesURL, parameters: fetchParams)
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
