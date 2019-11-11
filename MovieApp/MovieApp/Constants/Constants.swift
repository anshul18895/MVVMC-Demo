//
//  Constants.swift
//  MovieApp
//
//  Created by Anshul Shah on 12/11/18.
//  Copyright © 2018 Anshul Shah. All rights reserved.
//

import Foundation
import UIKit

enum InternetConnectionErrorCode: Int {
    case offline = 10101
}

//MARK:- Global Variables
let Application                         = UIApplication.shared.delegate as! AppDelegate
var AppName: String {return Bundle.main.infoDictionary!["CFBundleName"] as! String}
var AppDisplayName: String {return Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String}

var AppVersion: String {return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String}

var buildVersion: String {return Bundle.main.infoDictionary!["CFBundleVersion"] as! String}


//MARK:- UIDevice Static Constants

let IS_IPHONE_5             = 568.0
let IPHONE6_PLUS_WIDTH      = 414.0
let IPHONE6_PLUS_HEIGHT     = 736.0
let IPHONE6_WIDTH           = 375.0
let IPHONE6_HEIGHT          = 667.0
let IPHONEX_HEIGHT          = 812.0

let isIpad = UIDevice.current.userInterfaceIdiom == .pad

let Screen                  = UIScreen.main.bounds.size

let IMAGE_URL           = "https://image.tmdb.org/t/p/w200"
let BACK_IMAGE_URL      = "https://image.tmdb.org/t/p/w500"

var SAFE_AREA_NOTCH_INSET: CGFloat{
    if #available(iOS 11.0, *) {
        let inset = UIApplication.shared.keyWindow?.safeAreaInsets
        return (inset?.top ?? 0) +  (inset?.bottom ?? 0)
    }else{
        return 0
    }
}


//MARK:- Delay Methods
public func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
    let dispatchTime = DispatchTime.now() + seconds
    dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
}

public enum DispatchLevel {
    case main, userInteractive, userInitiated, utility, background
    var dispatchQueue: DispatchQueue {
        switch self {
        case .main:                 return DispatchQueue.main
        case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
        case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
        case .utility:              return DispatchQueue.global(qos: .utility)
        case .background:           return DispatchQueue.global(qos: .background)
        }
    }
}
