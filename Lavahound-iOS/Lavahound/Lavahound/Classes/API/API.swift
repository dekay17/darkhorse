//
//  API.swift
//  Lavahound
//
//  Created by Daniel Kelley on 8/29/15.
//  Copyright (c) 2015 LavaHound. All rights reserved.
//

import UIKit


//var baseUrl = "http://localhost:3001/api/"

@objc class API : NSObject {
    
        class func postToServer(endPoint:String, parameters:NSDictionary, successBlock: (apiToken :NSString, totalPoints:NSString) ->(), failureBlock: (error :NSError) ->()){
            let url: NSURL = NSURL(string: endPoint)!
            let request1: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
            request1.HTTPMethod = "POST"
        //var error: NSError?
        
        var JSONData: NSData?
        do {
            JSONData = try NSJSONSerialization.dataWithJSONObject(parameters, options: NSJSONWritingOptions.PrettyPrinted)
        } catch let error1 as NSError {
            failureBlock(error: error1);
//            error = error1
            JSONData = nil
        }

        request1.timeoutInterval = 10
        request1.HTTPBody=JSONData
        request1.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request1.HTTPShouldHandleCookies=false
        
        let queue:NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request1, queue: queue, completionHandler:{ (response: NSURLResponse?, data: NSData?, var error: NSError?) -> Void in
            print("response = \(response)")
            var statusCode = 000;
            if (response != nil){
                statusCode = (response as! NSHTTPURLResponse).statusCode
            }
            print("Data\(data) \(error)");
            if (statusCode == 200){
                //var err: NSError?
                let jsonResult: NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                let apiToken:NSString = jsonResult["api_token"] as! NSString
                let totalPoints:NSString = jsonResult["total_points"] as! NSString
                successBlock(apiToken: apiToken, totalPoints: totalPoints)
            }else{
                if (error == nil){
                    error = NSError(domain: "lavahound", code: 100, userInfo: [:])
                }
                failureBlock(error: error!);
            }
        })
        
    }
}