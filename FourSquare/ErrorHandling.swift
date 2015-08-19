//
//  ErrorHandling.swift
//  FourSquareAPI
//
//  Created by Chen, Zian on 8/19/15.
//  Copyright (c) 2015 Zian Mobile Development. All rights reserved.
//

import Foundation
import FSOAuth

public func oauthErrorMessageForCode(errorCode :FSOAuthErrorCode) -> String? {
    switch errorCode {
        case .None:
            return nil
        case .InvalidClient:
            return "Invalid client error."
        case .InvalidGrant:
            return "Invalid grant error."
        case .InvalidRequest:
            return "Invalid request error"
        case .UnauthorizedClient:
            return "Invalid unauthorized client error"
        case .UnsupportedGrantType:
            return "Invalid unsupported grant error"
        case .Unknown:
            fallthrough
        default:
            return "Unknown error"
    }
}


public func oauthStatusErrorMessageForCode(errorCode :FSOAuthStatusCode) -> String? {
    switch errorCode {
        case .Success:
            return "Connect Success"
        case .ErrorInvalidCallback:
            return "Invalid Callback URL"
        case .ErrorFoursquareNotInstalled:
            return "Four square not installed"
        case .ErrorInvalidClientID:
            return "Invalid Client ID"
        case .ErrorFoursquareOAuthNotSupported:
            return "Installed FSQ app does not support oauth"
        default:
            return "Unknown Status"
    }
}