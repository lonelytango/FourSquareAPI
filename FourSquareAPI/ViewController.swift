//
//  ViewController.swift
//  FourSquareAPI
//
//  Created by Zian Chen on 8/19/15.
//  Copyright (c) 2015 Zian Mobile Development. All rights reserved.
//

import UIKit
import FSOAuth
import CoreLocation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //FourSquareAPI.getVenueNearLocation("Elmhurst")
        //FourSquareAPI.getUser(FSSelfUserId)
        //FourSquareAPI.getUserPendingFriendRequests()
        //FourSquareAPI.searchUsers(phone: nil, email: nil, twitter: nil, twitterSource: "lonelytango", fbid: nil, name: nil)
        //FourSquareAPI.userListFriends(userId:FSSelfUserId, limit: 10, offset: 0)
        
        let timeSquareCoord = CLLocationCoordinate2DMake(40.758895, -73.985131)
        FourSquareAPI.userLists(userId: FSSelfUserId, group: FSUserListGroup.Created.rawValue, ll: timeSquareCoord, limit: 10, offset: 0)
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

