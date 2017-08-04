//
//  RavePayConfig.swift
//  RaveMobile
//
//  Created by Olusegun Solaja on 19/07/2017.
//  Copyright © 2017 Olusegun Solaja. All rights reserved.
//

import UIKit

public class RavePayConfig: NSObject {
    public var publicKey:String?
    public var secretKey:String?
    public var isStaging:Bool = true
    public var themeColor:UIColor = UIColor(hex: "#382E4B")
    public var secondaryThemeColor:UIColor = UIColor(hex: "#E1E2E2")
    public var buttonThemeColor:UIColor = UIColor(hex: "#00A384")

    
   public class func sharedConfig() -> RavePayConfig {
        
        struct Static {
            static let kbManager = RavePayConfig()
        }
        
        return Static.kbManager
    }
    
    

}
