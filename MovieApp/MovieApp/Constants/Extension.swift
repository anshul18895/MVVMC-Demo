//
//  Extension.swift
//  MovieApp
//
//  Created by Anshul Shah on 12/11/18.
//  Copyright © 2018 Anshul Shah. All rights reserved.
//

import Foundation
import UIKit


//MARK:- UIDevice

extension UIDevice {
    var isSimulator: Bool {
        #if arch(i386) || arch(x86_64)
        return true
        #else
        return false
        #endif
    }
}

//MARK:- Float

extension Float {
    
    var convertAsLocaleCurrency :String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: self as NSNumber)!
    }
    
    var convertAsUSDCurrency :String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: self as NSNumber)!
    }
}

//MARK:- Double

extension Double {
    
    /// Returns propotional height according to device height
    var propotionalHeight: CGFloat {
        return Screen.height / CGFloat(IPHONE6_HEIGHT) * CGFloat(self)
    }
    
    /// Returns propotional width according to device width
    var propotional: CGFloat {
        if isIpad {
            return CGFloat(IPHONE6_WIDTH) / CGFloat(IPHONE6_WIDTH) * CGFloat(self)
        }
        return CGFloat(Screen.width) / CGFloat(IPHONE6_WIDTH) * CGFloat(self)
    }
    
    var propotionalFont: CGFloat {
        if isIpad {
            return CGFloat(IPHONE6_WIDTH) / CGFloat(IPHONE6_WIDTH) * CGFloat(self)
        }
        if UIDevice.current.orientation == UIDeviceOrientation.portrait {
            return CGFloat(Screen.width) / CGFloat(IPHONE6_WIDTH) * CGFloat(self)
        } else {
            return CGFloat(Screen.height) / CGFloat(IPHONE6_WIDTH) * CGFloat(self)
        }
    }
    
    /// Returns rounded value for passed places
    ///
    /// - parameter places: Pass number of digit for rounded value off after decimal
    ///
    /// - returns: Returns rounded value with passed places
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
}

//MARK:- UILabel

extension UILabel {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
}


//MARK:- UIButton

extension UIButton {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
}

//MARK:- UIApplication

extension UIApplication {
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    static var isDeviceWithSafeArea:Bool {
        
        if #available(iOS 11.0, *) {
            if let topPadding = shared.keyWindow?.safeAreaInsets.top,
                topPadding > 0 {
                return true
            }
        }
        
        return false
    }
}

//MARK:- UIViewController

extension UIViewController{
    func showAlert(withMessage message:String, withActions actions: UIAlertAction... ,withStyle style:UIAlertController.Style = .alert) {
        
        let alert = UIAlertController(title: AppDisplayName, message: message, preferredStyle: style)
        if actions.count == 0 {
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
        } else {
            for action in actions {
                alert.addAction(action)
            }
        }
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK:- UIColor

extension UIColor {
    convenience init(hex: String) {
        let hexString = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hexString).scanHexInt32(&int)
        let a, r, g, b: UInt32
        
        switch hexString.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

