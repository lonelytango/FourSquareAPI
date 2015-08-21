//
//  ViewController.swift
//  FourSquareAPI
//
//  Created by Zian Chen on 8/19/15.
//  Copyright (c) 2015 Zian Mobile Development. All rights reserved.
//

import UIKit
import FSOAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //FourSquareAPI.getVenueNearLocation("Elmhurst")
        //FourSquareAPI.getActingUser()
        //FourSquareAPI.getUserPendingFriendRequests()
        //FourSquareAPI.searchUsers(phone: nil, email: nil, twitter: nil, twitterSource: "lonelytango", fbid: nil, name: nil)
        FourSquareAPI.userListFriends(userId:"self", limit: 10, offset: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //Action Handler
    @IBAction func handleConnectFourSquare(sender :AnyObject) {
        FourSquareAPI.setupOAuthAccessCode()
    }
}

