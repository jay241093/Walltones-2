//
//  webservices.swift
//  Walltones
//
//  Created by Ravi Dubey on 7/4/18.
//  Copyright © 2018 Ravi Dubey. All rights reserved.
//

import UIKit
import PKHUD

class webservices: NSObject {

    var baseurl =  "http://innoviussoftware.com/walltones/api/"

    static let sharedInstance : webservices = {
        let instance = webservices()
        return instance
    }()
    func nointernetconnection()
    {
        let button2Alert: UIAlertView = UIAlertView(title: nil, message: "Please check your internet connection",delegate: nil, cancelButtonTitle: "OK")
        button2Alert.show()
        
        
    }
    func AlertBuilder(title:String, message: String) -> UIAlertController{
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
   
    
}
