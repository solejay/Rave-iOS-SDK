//
//  Constants.swift
//  RaveMobile
//
//  Created by Segun Solaja on 10/5/15.
//  Copyright © 2015 Segun Solaja. All rights reserved.
//

import UIKit
import Alamofire

class Constants: NSObject {

    class func baseURL () -> String{
        return "http://flw-pms-dev.eu-west-1.elasticbeanstalk.com"
    }
    class func liveBaseURL() -> String{
        return "https://api.ravepay.co"
    }
   

    
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
   
 
    class func relativeURL()->Dictionary<String,String>{
        return [
            "CHARGE_CARD" :"/flwv3-pug/getpaidx/api/charge",
            "VALIDATE_CARD_OTP" :"/flwv3-pug/getpaidx/api/validatecharge",
            "VALIDATE_ACCOUNT_OTP":"/flwv3-pug/getpaidx/api/validate",
            "BANK_LIST":"/flwv3-pug/getpaidx/api/flwpbf-banks.js?json=1",
            "CHARGE_WITH_TOKEN":"/flwv3-pug/getpaidx/api/tokenized/charge",
            "QUERY_TRANSACTION":"/flwv3-pug/getpaidx/api/verify",
            "FEE":"/flwv3-pug/getpaidx/api/fee"
        ]
    }
    
    
    class func headerConstants(_ headerParam:Dictionary<String,String>)->Dictionary<String,String> {
     
       /* var defaultsDict:Dictionary<String,String>  =  [
            "apikey":apiKey,
            "secret": apiSecret]*/
      
        
//        if(headerParam.isEmpty){
//            return defaultsDict
//        }else{
//            defaultsDict.merge(headerParam)
//            return defaultsDict
//        }
        
       return  headerParam

    }

    

}
