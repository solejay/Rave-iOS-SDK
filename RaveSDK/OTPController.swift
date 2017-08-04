//
//  OTPController.swift
//  RaveMobile
//
//  Created by Olusegun Solaja on 18/07/2017.
//  Copyright © 2017 Olusegun Solaja. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftValidator
import KVNProgress
import BSErrorMessageView
protocol OTPControllerDelegate:class {
    func raveOTP(_ webController:OTPController, didSucceedPaymentWithResult result:[String:AnyObject])
    func raveOTP(_ webController:OTPController, didFailPaymentWithResult result:[String:AnyObject])
}

class OTPController: UIViewController,UITextFieldDelegate,ValidationDelegate{
    weak var delegate:OTPControllerDelegate?
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    var transactionReference:String?
    var isCardValidation:Bool = true
    var saveCard = false
    var cardNumber:String?
    var email:String?
    var otpChargeMessage:String?
    let validator = Validator()
    
    @IBOutlet weak var otpTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView(){
        styleTextField(otpTextField)
        containerView.layer.cornerRadius = 6
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = RavePayConfig.sharedConfig().secondaryThemeColor.cgColor
        
        continueButton.layer.cornerRadius =  continueButton.frame.height / 2
        continueButton.layer.borderWidth = 0.5
        continueButton.backgroundColor = RavePayConfig.sharedConfig().buttonThemeColor
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        otpTitle.text = otpChargeMessage
        validator.registerField(self.otpTextField, errorLabel: nil, rules: [RequiredRule(message:"OTP is required")])
        otpTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.barTintColor =  RavePayConfig.sharedConfig().themeColor
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),for: .default)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        self.title = "OTP"
    }
    @objc private func continueButtonTapped(){
        self.view.endEditing(true)
        validator.validate(self)
    }
    
    @objc private func docontinueButtonTapped(){
        guard let otp = self.otpTextField.text else {return}
        
        if (isCardValidation){
            let reqbody = [
                "PBFPubKey": RavePayConfig.sharedConfig().publicKey!,
                "transaction_reference": transactionReference!,
                "otp": otp
            ]

            self.validateCard(reqbody: reqbody)
        }else{
            let reqbody = [
                "PBFPubKey": RavePayConfig.sharedConfig().publicKey!,
                "transactionreference": transactionReference!,
                "otp": otp
            ]

            self.validateAccount(reqbody: reqbody)
        }
    }
    
    func validateCard(reqbody:[String:String]){
        KVNProgress.show(withStatus: "Processing..")
        RavePayService.validateCardOTP(reqbody, resultCallback: { (result) in
            print(result ?? "nil")
            
            if let res =  result{
                if let data = res ["data"] as? [String:AnyObject]{
                    print(data)
                    if let tx = data["tx"] as? [String:AnyObject]{
                        if let flwRef = tx["flwRef"] as? String{
                            self.queryTransaction(flwRef: flwRef)
                        }
                    }
                }
//                if let status = res["status"] as? String{
//                    if status == "success"{
//                        DispatchQueue.main.async {
//                            KVNProgress.showSuccess(completion: {
//                                self.delegate?.raveOTP(self, didSucceedPaymentWithResult: res)
//                                self.dismissView()
//                            })
//                        }
//                    }else{
//                        DispatchQueue.main.async {
//                            KVNProgress.dismiss()
//                            self.delegate?.raveOTP(self, didFailPaymentWithResult: res)
//                            self.dismissView()
//                        }
//                    }
//                }
            }
            
        }) { (err) in
            print(err)
            KVNProgress.dismiss()
            showMessageDialog("Error", message: err, image: nil, axis: .horizontal, viewController: self, handler: {
                
            })
        }
    }
    
    func validateAccount(reqbody:[String:String]){
        KVNProgress.show(withStatus: "Processing..")
        RavePayService.validateAccountOTP(reqbody, resultCallback: { (result) in
            print(result ?? "nil")
            if let res =  result{
                if let data = res ["data"] as? [String:AnyObject]{
                    if let flwRef = data["flwRef"] as? String{
                        self.queryTransaction(flwRef: flwRef)
                    }
                }

//                if let status = res["status"] as? String{
//                    if status == "success"{
//                        DispatchQueue.main.async {
//                            KVNProgress.showSuccess(completion: {
//                                self.delegate?.raveOTP(self, didSucceedPaymentWithResult: res)
//                                self.dismissView()
//                            })
//                        }
//                    }else{
//                        DispatchQueue.main.async {
//                            self.delegate?.raveOTP(self, didFailPaymentWithResult: res)
//                            KVNProgress.dismiss()
//                            self.dismissView()
//                        }
//                    }
//                }
            }
            
        }) { (err) in
            print(err)
            KVNProgress.dismiss()
            showMessageDialog("Error", message: err, image: nil, axis: .horizontal, viewController: self, handler: {
                
            })

        }
    }
    func queryTransaction(flwRef:String?){
        
        if let secret = RavePayConfig.sharedConfig().secretKey ,let  ref = flwRef{
            let param = ["SECKEY":secret,"flw_ref":ref]
            RavePayService.queryTransaction(param, resultCallback: { (result) in
                if let  status = result?["status"] as? String{
                    if (status == "success"){
                        DispatchQueue.main.async {
                             KVNProgress.showSuccess(completion: {
                            
                                print(result!)
                                let callbackResult = ["status":"success","payload":result!] as [String : Any]
                                if (self.saveCard){
                                    self.addOrUpdateCardToken(cardNumber: self.cardNumber!, data: result!,withFlwRef: ref)
                                }
                                self.delegate?.raveOTP(self, didSucceedPaymentWithResult:  callbackResult as [String : AnyObject])
                                self.dismissView()
                            })
                        }
                    }else{
                        DispatchQueue.main.async {
                            let callbackResult = ["status":"success","payload":result!] as [String : Any]
                            self.delegate?.raveOTP(self, didSucceedPaymentWithResult:  callbackResult as [String : AnyObject])
                            KVNProgress.dismiss()
                            self.dismissView()
                            
                        }
                    }
                }
            }, errorCallback: { (err) in
                
                print(err)
                 KVNProgress.dismiss()
                showMessageDialog("Error", message: err, image: nil, axis: .horizontal, viewController: self, handler: {
                    
                })

            })
        }
    }
    func validationSuccessful() {
        // submit the form
        docontinueButtonTapped()
    }
    
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        // turn the fields to red
        for (field, error) in errors {
            if let field = field as? UITextField {
                //  field.layer.borderColor = UIColor(hex: "#FB4F3B").cgColor
                // field.layer.borderWidth = 1.0
                field.bs_setupErrorMessageView(withMessage: error.errorMessage)
                field.bs_showError()
            }
            error.errorLabel?.text = error.errorMessage
            error.errorLabel?.textColor = UIColor(hex: "#FB4F3B")
            error.errorLabel?.isHidden = false
        }
    }
    
    private func addOrUpdateCardToken(cardNumber:String,data:[String:AnyObject], withFlwRef ref:String){
    if let _data = data["data"] as? [String:AnyObject]{
        if let card = _data["card"] as? [String:AnyObject]{
            if let cards = card["card_tokens"] as? [[String:AnyObject]]{
            let _cardToken = cards.last!
            if let token = _cardToken["embedtoken"] as? String{
                let first6 = cardNumber.substring(to: cardNumber.index(cardNumber.startIndex, offsetBy: 6))
                let last4 = cardNumber.substring(from: cardNumber.index(cardNumber.endIndex, offsetBy: -4))
                let cardDetails = ["card_token":token,"first6":first6,"last4":last4, "flwRef":ref]
                if let cards  = UserDefaults.standard.object(forKey: "cards-\(email!)") as? [[String:String]]{
                    var theCards = cards
                    theCards = cards.filter({ (item) -> Bool in
                        let _first6 = item["first6"]!
                        return _first6 != first6
                    })
                    theCards.append(cardDetails)
                    UserDefaults.standard.set(theCards, forKey: "cards-\(email!)")
                    
                }else{
                    UserDefaults.standard.set([cardDetails], forKey: "cards-\(email!)")
                    
                }
              }
            }
        }
         }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.bs_hideError()
        
    }

    
    func dismissView(){
        self.navigationController?.popViewController(animated: true)
    }

    

}
