//
//  RavePayManager.swift
//  RaveMobile
//
//  Created by Olusegun Solaja on 19/07/2017.
//  Copyright © 2017 Olusegun Solaja. All rights reserved.
//

import UIKit
public protocol RavePaymentManagerDelegate:class {
    func ravePaymentManagerDidCancel(_ ravePaymentManager:RavePayManager)
    func ravePaymentManager(_ ravePaymentManager:RavePayManager, didSucceedPaymentWithResult result:[String:AnyObject])
    func ravePaymentManager(_ ravePaymentManager:RavePayManager, didFailPaymentWithResult result:[String:AnyObject])
}

public class RavePayManager: UIViewController,RavePayControllerDelegate {
    public weak var delegate:RavePaymentManagerDelegate?
    public var email:String?
    public var transcationRef:String?
    public var amount:String?
    public var country:String = "NG"
    public var currencyCode:String = "NGN"
    public var narration:String?
    public var savedCardsAllow = true
    
    
    
    
    
    public func show(withController controller:UIViewController){
        guard let email = email else {
            fatalError("Email address is missing")
        }
        guard let transcationRef = transcationRef else {
            fatalError("transactionRef is missing")
        }
        
        let identifier = Bundle(identifier: "flutterwave.RaveSDK")
        let storyboard = UIStoryboard(name: "RaveSDK", bundle: identifier)
        let _controller = storyboard.instantiateViewController(withIdentifier: "raveNav") as! UINavigationController
        let raveController = _controller.childViewControllers[0] as! RavePayController
        raveController.email = email
        raveController.merchantTransRef = transcationRef
        raveController.amount = amount
        raveController.country = country
        raveController.delegate = self
        raveController.manager = self
        raveController.saveCardsAllow = savedCardsAllow
        raveController.currencyCode = currencyCode
        controller.present(_controller, animated: true, completion: nil)
    }
    
    func ravePay(_ ravePayController: RavePayController, didFailPaymentWithResult result: [String : AnyObject]) {
        self.delegate?.ravePaymentManager(self, didFailPaymentWithResult: result)
    }
    func ravePayDidCancel(_ ravePayController: RavePayController) {
        self.delegate?.ravePaymentManagerDidCancel(self)
    }
    func ravePay(_ ravePayController: RavePayController, didSucceedPaymentWithResult result: [String : AnyObject]) {
        self.delegate?.ravePaymentManager(self, didSucceedPaymentWithResult: result)
    }
    
}
