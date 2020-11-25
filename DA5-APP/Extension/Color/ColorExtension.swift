//
//  ColorExtension.swift
//  DA5-APP
//
//  Created by Jojo on 8/18/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit
extension UIColor {
    convenience init(hex: String) {
        let scanner                 = Scanner(string: hex)
        scanner.scanLocation        = 0
        
        var rgbValue: UInt64        = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r                       = (rgbValue & 0xff0000) >> 16
        let g                       = (rgbValue & 0xff00) >> 8
        let b                       = rgbValue & 0xff
        
        self.init(
            red                     : CGFloat(r) / 0xff,
            green                   : CGFloat(g) / 0xff,
            blue                    : CGFloat(b) / 0xff, alpha: 1
        )
    }
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
