//
//  Extension.swift
//  RaveMobile
//
//  Created by Olusegun Solaja on 18/07/2017.
//  Copyright © 2017 Olusegun Solaja. All rights reserved.
//

import UIKit
import PopupDialog
import CommonCrypto
//import ifaddrs


func MD5(string: String) -> Data? {
    guard let messageData = string.data(using:String.Encoding.utf8) else { return nil }
    var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
    
    _ = digestData.withUnsafeMutableBytes {digestBytes in
        messageData.withUnsafeBytes {messageBytes in
            CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
        }
    }
    
    return digestData
}

func showMessageDialog (_ title:String, message:String , image:UIImage?, axis:UILayoutConstraintAxis,viewController:UIViewController, handler:(() -> Void)?){
    let popUp = PopupDialog(title: title, message: message, image: image, buttonAlignment: axis, transitionStyle: PopupDialogTransitionStyle.zoomIn, gestureDismissal: true, completion: handler)
    
    if let  _ = handler{
        let button =  DefaultButton(title: "OK"){
            handler!()
        }
        popUp.addButtons([button])
    }
    
    
    _ = viewController.present(popUp, animated: true)
}

func getEncryptionKey(_ secretKey:String)->String {
    let md5Data = MD5(string:secretKey)
    let md5Hex =  md5Data!.map { String(format: "%02hhx", $0) }.joined()
    
    var secretKeyHex = ""
    
    if secretKey.contains("FLWSECK-") {
        secretKeyHex = secretKey.replacingOccurrences(of: "FLWSECK-", with: "")
    }
    if secretKey.contains("-X") {
        secretKeyHex = secretKeyHex.replacingOccurrences(of: "-X", with: "")
    }
    
    let index = secretKeyHex.index(secretKeyHex.startIndex, offsetBy: 12)
    let first12 = secretKeyHex.substring(to: index)
    
    let last12 = md5Hex.substring(from:md5Hex.index(md5Hex.endIndex, offsetBy: -12))
    return first12 + last12
    
}

func getIFAddresses() -> [String] {
    //    var addresses = [String]()
    //
    //    // Get list of all interfaces on the local machine:
    //    var ifaddr : UnsafeMutablePointer<ifaddrs>?
    //    guard getifaddrs(&ifaddr) == 0 else { return [] }
    //    guard let firstAddr = ifaddr else { return [] }
    //
    //    // For each interface ...
    //    for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
    //        let flags = Int32(ptr.pointee.ifa_flags)
    //        let addr = ptr.pointee.ifa_addr.pointee
    //
    //        // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
    //        if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
    //            if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
    //
    //                // Convert interface address to a human readable string:
    //                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
    //                if (getnameinfo(ptr.pointee.ifa_addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
    //                                nil, socklen_t(0), NI_NUMERICHOST) == 0) {
    //                    let address = String(cString: hostname)
    //                    addresses.append(address)
    //                }
    //            }
    //        }
    //    }
    //
    //    freeifaddrs(ifaddr)
    //    return addresses
    return["127.0.0.1"]
}

let themeColor:UIColor = UIColor(hex: "#382E4B")
let secondaryThemeColor:UIColor = UIColor(hex: "#E1E2E2")

func styleTextField(_ textField:UITextField, leftView:UIView? = nil){
    textField.layer.borderWidth = 1
    textField.layer.borderColor = UIColor(hex: "#E1E2E2").cgColor
    textField.layer.cornerRadius = textField.frame.height / 2
    //textField.layer.cornerRadius = 4
    if let v = leftView{
        textField.leftView = v
        textField.leftViewMode = .always
    }else{
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
        textField.leftViewMode = .always
    }
}

extension String{
    func toCurrency(_ withFraction:Int = 0, locale:String = "ig_NG") -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = withFraction
        formatter.locale = Locale(identifier: locale)
        if self == ""{
            return formatter.string(from: NSNumber(value: 0))!
        }else{
            let val = (self as NSString).doubleValue
            return formatter.string(from: NSNumber(value: val))!
        }
    }
    
    func index(of target: String) -> Int? {
        if let range = self.range(of: target) {
            return characters.distance(from: startIndex, to: range.lowerBound)
        } else {
            return nil
        }
    }
    
    func lastIndex(of target: String) -> Int? {
        if let range = self.range(of: target, options: .backwards) {
            return characters.distance(from: startIndex, to: range.lowerBound)
        } else {
            return nil
        }
    }
    func toCountryCurrency(code:String) -> String{
        var str:String = ""
        switch code {
        case "NGN":
            str = self.toCurrency(2)
        case "USD":
            str = self.toCurrency(2,locale:"en_US")
        case "GBP":
            str = self.toCurrency(2,locale:"en_GB")
        case "KES":
            str = self.toCurrency(2,locale:"kam_KE")
        case "GHS":
            str = self.toCurrency(2,locale:"ak_GH")
        case "ZAR":
            str = self.toCurrency(2, locale: "en_ZA")
        default:
            str = self.toCurrency(2)
            
        }
        return str
    }
    
}

public extension Dictionary{
    func jsonStringify()-> String {
        var str = ""
        do
        {
            let data = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions(rawValue: 0))
            if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            {
                str = string as String
            }
        }
        catch
        {
        }
        
        return str
    }
    
    mutating func merge<K, V>(_ dict: [K: V]){
        for (k, v) in dict {
            self.updateValue(v as! Value, forKey: k as! Key)
        }
    }
}

public extension UIColor {
    convenience init(hex: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        var hex:   String = hex
        
        if hex.hasPrefix("#") {
            let index   = hex.characters.index(hex.startIndex, offsetBy: 1)
            hex         = hex.substring(from: index)
        }
        
        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.characters.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default:
                print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
            }
        } else {
            print("Scan hex error")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
