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
let FSOAuthAccessCodeKey = "kFourSquareOAuthAccessCodeKey"
let FSClientId = "K2EJ4LYIPLLVB42VMWRAADPETIAQIZGPERXJBRPWOICZYBHY"
let FSClientSecret = "TAOWRLEICGFO4F2VDNDAG2FOEKN1JK1FXLK42ZDBW1EUFRTV"

let FSRedirectURL = "foursquareapi://authorized"
let FSRedirectURLScheme = "foursquareapi"

let FSUsersURL = "https://api.foursquare.com/v2/users"
let FSVenuesURL = "https://api.foursquare.com/v2/venues/explore"


//MARK: SETUP

public func handleUrl(url :NSURL) {
    if url.scheme == FSRedirectURLScheme {
        var errorCode :FSOAuthErrorCode = .None
        var accessCode = FSOAuth.accessCodeForFSOAuthURL(url, error: &errorCode)
        
        if errorCode == FSOAuthErrorCode.None {
            println("Access Code: \(accessCode)")
            Manager.sharedInstance.latestAccessCode = accessCode
            NSUserDefaults.setFourSquareOAuthAccessKey(accessCode)
            
        } else {
            let errorMessage = oauthErrorMessageForCode(errorCode)
            //let errorMessage = ErrorHandling.errorMessageForCode(errorCode)
            println("Error Message: \(errorMessage)")
        }
    }
}

public func setupOAuthAccessCode() {
    //Note that OAuth Key will not be expired once set up.
    
    let accessCode = NSUserDefaults.getFourSquareOAuthAccessKey()
    if accessCode == nil {
        var statusCode :FSOAuthStatusCode = FSOAuth.authorizeUserUsingClientId(FSClientId, callbackURIString: FSRedirectURL)
        var errorMessage = FourSquareAPI.oauthStatusErrorMessageForCode(statusCode)
        println("OAuth Status: \(errorMessage)")
    } else {
        
        //Check if the OAuth key is valid.
        Manager.sharedInstance.latestAccessCode = accessCode
        println("Access key setup properly: \(accessCode)")
    }
}


//MARK: USERS - GENERAL
public func getUser(userId :String) {
    var fetchUsersURL = FSUsersURL + "/" + userId
    Manager.sharedInstance.request(method: .GET, URLString: fetchUsersURL, parameters: nil)
}

//MARK: USERS - ASPECTS
//public func requestUserFriendRequests

//MARK: USERS - ACTIONS


//MARK: VENUE
public func getVenueNearLocation(location :String, limit :Int = FourSquareDefaultFetchLimit) {
    var fetchParams = ["near":location, "limit":String(limit)]
    Manager.sharedInstance.request(method: .GET, URLString: FSVenuesURL, parameters: fetchParams)
}



//MARK: EXTENSION

extension NSUserDefaults {
    class func setFourSquareOAuthAccessKey(accessKey :NSString) {
        NSUserDefaults.standardUserDefaults().setObject(accessKey, forKey: FSOAuthAccessCodeKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func getFourSquareOAuthAccessKey() -> String? {
        return NSUserDefaults.standardUserDefaults().stringForKey(FSOAuthAccessCodeKey)
    }
}
