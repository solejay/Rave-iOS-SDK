//
//  BankConverter.swift
//  RaveMobile
//
//  Created by Olusegun Solaja on 20/07/2017.
//  Copyright © 2017 Olusegun Solaja. All rights reserved.
//

import UIKit

class BankConverter: NSObject {
    class func convert(_ bankJson:Dictionary<String,AnyObject>) -> Bank{
        let bank = Bank()
        bank.name = bankJson["bankname"] as? String
        bank.isInternetBanking = bankJson["internetbanking"] as? Bool
        bank.bankCode = bankJson["bankcode"] as? String
        
        return bank
    }
}
