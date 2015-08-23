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
