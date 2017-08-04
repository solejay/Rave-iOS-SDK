//
//  CustomerBank.swift
//  RaveMobile
//
//  Created by Segun Solaja on 5/28/17.
//  Copyright © 2017 Segun Solaja. All rights reserved.
//

import UIKit

class Bank: NSObject,NSCoding {
    var bankCode:String?
    var isInternetBanking:Bool?
    var name:String?
    
    override init () {
        super.init()
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(bankCode, forKey: "bankCode")
        aCoder.encode(isInternetBanking, forKey: "isInternetBanking")
        aCoder.encode(name, forKey: "name")
           }
    
    required init(coder aDecoder: NSCoder){
        
        self.bankCode = aDecoder.decodeObject(forKey: "bankCode") as? String
        
        self.isInternetBanking = aDecoder.decodeObject(forKey: "isInternetBanking") as? Bool
        self.name = aDecoder.decodeObject(forKey: "name") as? String
    }
}

