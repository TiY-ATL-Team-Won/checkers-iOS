//
//  APICall.swift
//  checkers-iOS
//
//  Created by Bobby Towers on 2/19/15.
//  Copyright (c) 2015 Bobby Towers. All rights reserved.
//
import Foundation

// base url
let API_URL = "http://protected-forest-2584.herokuapp.com/"

// our singleton
private let _currentUser = User()

class User {
    
    
    
    // custom initializer
    init() {
        
        // when we run the app, this will check to see if token was previously set
        
        let defaults = NSUserDefaults.standardUserDefaults()
        token = defaults.objectForKey("token") as? String
        
    }
    
    // this is our singleton method
    class func currentUser() -> User { return _currentUser }
    
    var token: String? {
        
        didSet {
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(token, forKey: "token")
            defaults.synchronize()
            
        }
        
    }
    
    func getUserToken(email: String, password: String) {
        
        let options: [String:AnyObject] = [
            
            "endpoint" : "users",
            "method" : "POST",
            "body" : [
                
                "user" : [ "email" : email, "password" : password]
                
            ]
            
        ]
        
        
        // responseInfo is json
        
        APIRequest.requestWithOptions(options, andCompletion: { (responseInfo) -> () in
            
            println(responseInfo)
            
            let dataInfo = responseInfo["data"] as [String:String]
            
            self.token = dataInfo["auth_token"]
            
        })
        
    }
    
}

class APIRequest {
    
    class func requestWithOptions(options: [String:AnyObject], andCompletion completion: (responseInfo: [String:AnyObject]) -> ()) {
        
        var url = NSURL(string: API_URL + (options["endpoint"] as String))
        
        // force unwrap needs to be changed to if-let optional binding
        var request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = options["method"] as String
        
        
        ///// BODY
        let bodyInfo = options["body"] as [String:AnyObject]
        
        let requestData = NSJSONSerialization.dataWithJSONObject(bodyInfo, options: NSJSONWritingOptions.allZeros, error: nil)
        
        let jsonString = NSString(data: requestData!, encoding: NSUTF8StringEncoding)
        
        let postLength = "\(jsonString!.length)"
        
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        
        let postData = jsonString?.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = postData
        
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            if error == nil {
                
                // do something with data
                // convert data into JSON
                // json is the actual response
                
                let json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil) as [String:AnyObject]
                
                completion(responseInfo: json)
                
                // completion is the parameter name
                // then we open up the time capsule after it is called
                // responseInfo now equals json because that is the argument passed into the function
                
                
            } else {
                
                println(error)
                
            }
            
        }
        
    }
    
}