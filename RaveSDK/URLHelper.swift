//
//  URLHelper.swift
//  RaveMobile
//
//  Created by Segun Solaja on 10/5/15.
//  Copyright © 2015 Segun Solaja. All rights reserved.
//

import UIKit

class URLHelper: NSObject {
    static let isStaging = RavePayConfig.sharedConfig().isStaging
    class func getURL(_ URLKey:String) ->String{
        return self.getURL(URLKey, withURLParam: [:])
    }
    
    class func getURL(_ URLKey:String ,withURLParam:Dictionary<String,String>) -> String{
        if (!withURLParam.isEmpty){
            var str:String!
           str =  Constants.relativeURL()[URLKey]!
            for (key,value) in withURLParam{     
               str = str.replacingOccurrences(of: ":" + key, with: value)
            }
            return (isStaging ? Constants.baseURL(): Constants.liveBaseURL()) + str!
            
        }else{
            print((isStaging ? Constants.baseURL(): Constants.liveBaseURL()) + Constants.relativeURL()[URLKey]!)
            return (isStaging ? Constants.baseURL(): Constants.liveBaseURL()) + Constants.relativeURL()[URLKey]!
        }
    }
    

}
