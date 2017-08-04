//
//  RavePayService.swift
//  RaveMobile
//
//  Created by Olusegun Solaja on 19/07/2017.
//  Copyright © 2017 Olusegun Solaja. All rights reserved.
//

import UIKit
import Alamofire

class RavePayService: NSObject {
    class func queryTransaction(_ bodyParam:Dictionary<String,String>,resultCallback:@escaping (_ result:Dictionary<String,AnyObject>?) -> Void ,errorCallback:@escaping (_ err:String) -> Void ){
        
        Alamofire.request(URLHelper.getURL("QUERY_TRANSACTION"),method: .post, parameters: bodyParam).responseJSON {
            (res) -> Void in
            
            if(res.result.isSuccess){
                let result = res.result.value as? Dictionary<String,AnyObject>
              //  let data = result?["data"] as? Dictionary<String,AnyObject>
               
                resultCallback(result)
                
                
            }else{
                errorCallback( res.result.error!.localizedDescription)
            }
        }
        
        
    }
    class func getFee(_ bodyParam:Dictionary<String,String>,resultCallback:@escaping (_ result:Dictionary<String,AnyObject>?) -> Void ,errorCallback:@escaping (_ err:String) -> Void ){
        
        Alamofire.request(URLHelper.getURL("FEE"),method: .post, parameters: bodyParam).responseJSON {
            (res) -> Void in
            
            if(res.result.isSuccess){
                let result = res.result.value as? Dictionary<String,AnyObject>
                //  let data = result?["data"] as? Dictionary<String,AnyObject>
                
                resultCallback(result)
                
                
            }else{
                errorCallback( res.result.error!.localizedDescription)
            }
        }
        
        
    }
    class func getBanks(resultCallback:@escaping (_ result:[Bank]?) -> Void ,errorCallback:@escaping (_ err:String) -> Void ){
        
        Alamofire.request(URLHelper.getURL("BANK_LIST"),method: .get, parameters: nil).responseJSON {
            (res) -> Void in
            
            if(res.result.isSuccess){
                let result = res.result.value as! [Dictionary<String,AnyObject>]
                
                let banks = result.map({ (item) -> Bank in
                    BankConverter.convert(item)
                })
                resultCallback(banks)
                
                
            }else{
                errorCallback( res.result.error!.localizedDescription)
            }
        }
        
        
    }
    class func charge(_ bodyParam:Dictionary<String,String>,resultCallback:@escaping (_ Result:Dictionary<String,AnyObject>?) -> Void ,errorCallback:@escaping (_ err:String) -> Void ){
        
        Alamofire.request(URLHelper.getURL("CHARGE_CARD"),method: .post, parameters: bodyParam).responseJSON {
            (res) -> Void in
        
                if(res.result.isSuccess){
                    let result = res.result.value as! Dictionary<String,AnyObject>
                    print(result)
                    
                       // let data = result["data"] as? Dictionary<String,AnyObject>
                        resultCallback(result)
                    
                    
                }else{
                    errorCallback( res.result.error!.localizedDescription)
                }
            }
        
        
     }
    class func chargeWithToken(_ bodyParam:Dictionary<String,String>,resultCallback:@escaping (_ Result:Dictionary<String,AnyObject>?) -> Void ,errorCallback:@escaping (_ err:String) -> Void ){
        
        Alamofire.request(URLHelper.getURL("CHARGE_WITH_TOKEN"),method: .post, parameters: bodyParam).responseJSON {
            (res) -> Void in
            
            if(res.result.isSuccess){
                let result = res.result.value as! Dictionary<String,AnyObject>
                print(result)
                
                // let data = result["data"] as? Dictionary<String,AnyObject>
                resultCallback(result)
                
                
            }else{
                errorCallback( res.result.error!.localizedDescription)
            }
        }
        
        
    }
    
    class func validateCardOTP(_ bodyParam:Dictionary<String,String>,resultCallback:@escaping (_ Result:Dictionary<String,AnyObject>?) -> Void ,errorCallback:@escaping (_ err:String) -> Void ){
        
        Alamofire.request(URLHelper.getURL("VALIDATE_CARD_OTP"),method: .post, parameters: bodyParam).responseJSON {
            (res) -> Void in
            
            if(res.result.isSuccess){
                let result = res.result.value as! Dictionary<String,AnyObject>
                //print(result)
                
              //  let data = result["data"] as? Dictionary<String,AnyObject>
                resultCallback(result)
                
                
            }else{
                errorCallback( res.result.error!.localizedDescription)
            }
        }
        
    }
    class func validateAccountOTP(_ bodyParam:Dictionary<String,String>,resultCallback:@escaping (_ Result:Dictionary<String,AnyObject>?) -> Void ,errorCallback:@escaping (_ err:String) -> Void ){
        
        Alamofire.request(URLHelper.getURL("VALIDATE_ACCOUNT_OTP"),method: .post, parameters: bodyParam).responseJSON {
            (res) -> Void in
            
            if(res.result.isSuccess){
                let result = res.result.value as! Dictionary<String,AnyObject>
                //print(result)
                
                //let data = result["data"] as? Dictionary<String,AnyObject>
                resultCallback(result)
                
                
            }else{
                errorCallback( res.result.error!.localizedDescription)
            }
        }
        
        
    }
}
