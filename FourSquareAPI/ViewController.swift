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
        
        //FourSquareAPI.requestVenueNearLocation("Elmhurst")
        //FourSquareAPI.getUser("31662724")
        FourSquareAPI.getPendingFriendRequests()
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

