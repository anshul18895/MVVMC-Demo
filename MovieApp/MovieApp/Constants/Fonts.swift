//
//  Fonts.swift
//  Zodiluv
//
//  Created by Anshul Shah on 1/16/18.
//  Copyright © 2018 Anshul Shah. All rights reserved.
//

import UIKit

enum FontSize: CGFloat {
    case sixteen = 16
    case small = 15.0
    case medium = 17.0
    case large = 19.0
}

struct Fonts {
    
    struct Helvetica {
        
        static func regular(of size: CGFloat) -> UIFont {
            return UIFont(name: "HelveticaNeue", size: size)!
        }
        
        static func italic(of size: CGFloat) -> UIFont {
            return UIFont(name: "HelveticaNeue-Italic", size: size)!
        }
        
        static func ultraLight(of size: CGFloat) -> UIFont {
            return UIFont(name: "HelveticaNeue-UltraLight", size: size)!
        }
        
        static func ultraLightItalic(of size: CGFloat) -> UIFont {
            return UIFont(name: "HelveticaNeue-UltraLightItalic", size: size)!
        }
        
        static func thin(of size: CGFloat) -> UIFont {
            return UIFont(name: "HelveticaNeue-Thin", size: size)!
        }
        
        static func thinItalic(of size: CGFloat) -> UIFont {
            return UIFont(name: "HelveticaNeue-ThinItalic", size: size)!
        }
        
        static func light(of size: CGFloat) -> UIFont {
            return UIFont(name: "HelveticaNeue-Light", size: size)!
        }
        
        static func lightItalic(of size: CGFloat) -> UIFont {
            return UIFont(name: "HelveticaNeue-LightItalic", size: size)!
        }
        
        static func medium(of size: CGFloat) -> UIFont {
            return UIFont(name: "HelveticaNeue-Medium", size: size)!
        }
        
        static func mediumItalic(of size: CGFloat) -> UIFont {
            return UIFont(name: "HelveticaNeue-MediumItalic", size: size)!
        }
        
        static func bold(of size: CGFloat) -> UIFont {
            return UIFont(name: "HelveticaNeue-Bold", size: size)!
        }
        
        static func boldItalic(of size: CGFloat) -> UIFont {
            return UIFont(name: "HelveticaNeue-BoldItalic", size: size)!
        }
        
        static func condensedBold(of size: CGFloat) -> UIFont {
            return UIFont(name: "HelveticaNeue-CondensedBold", size: size)!
        }
        
        static func condensedBlack(of size: CGFloat) -> UIFont {
            return UIFont(name: "HelveticaNeue-CondensedBlack", size: size)!
        }
    }
    
}
