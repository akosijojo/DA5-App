//
//  String Extension.swift
//  DA5-APP
//
//  Created by Jojo on 9/9/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

extension String {
    func heightForView(font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 999999999))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.height
    }
    
    func widthForView(font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 999999999))
        label.numberOfLines = 1
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.width
    }
    
    func formatDate(format: String? = "MMM dd, yyyy") -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = format!

        if let date = dateFormatterGet.date(from: self) {
            return dateFormatterPrint.string(from: date)
        }
        return self
    }
}



//MARK: - NUMBER FORMATTER

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}
extension Numeric {
    var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
}

extension Double {
    func returnDoubleToString(decimalPlaces: Int = 2) -> String {
          var number: NSNumber!
          let formatter = NumberFormatter()
          formatter.numberStyle = .decimal
          formatter.currencySymbol = ""
          formatter.minimumFractionDigits = decimalPlaces
          formatter.maximumFractionDigits = decimalPlaces
        
          let double = self
          number = NSNumber(value: double)

          guard number != 0 as NSNumber else {
              return "0"
          }
        return formatter.string(from: number) ?? "0"
  }
       
}


extension String {
    
    
    // formatting text phone number
    func returnPhoneNumber() -> String{
        let amountString = self.replacingOccurrences(of: "+63", with: "")
        return amountString
    }
    
    // formatting text for currency textField
    func amountEntered(wDecimal : Bool = true,wSeparator: Bool = true) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = wSeparator ? "," : ""
        formatter.maximumFractionDigits = wDecimal ? 2 : 0
        formatter.minimumFractionDigits = wDecimal ? 2 : 0
        let amountString = self.replacingOccurrences(of: ",", with: "")
        
        var double : Double = 0.00
            double = Double(amountString) ?? 0.00
        
        if self.last == "." {
            return "\(self)00"
        }
        return formatter.string(from: NSNumber(value: double))!
    }
    
    // formatting text for currency textField
    func currencyInputFormatting(wDecimal: Bool? = nil) -> String {

        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "PHP"
        formatter.minimumFractionDigits = wDecimal == true ? 2 : 0
        formatter.maximumFractionDigits = wDecimal == true ? 2 : 0

        var amountWithPrefix = self

        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")

        let double = (amountWithPrefix as NSString).doubleValue
//        if double > 100 {
//            number = NSNumber(value: (double / 100))
//        }else {
            number = NSNumber(value: double)
//        }

        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return wDecimal == true ? "PHP 0.00" : "PHP 0"
        }

        return formatter.string(from: number)!
    }
    
     // formatting text for currency textField
    func removeStringsAmount() -> Double {
//
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.currencySymbol = ""
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        var amountWithPrefix = self
        
        let regex = try! NSRegularExpression(pattern: "[^0-9.]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
//        if double > 100 {
//            number = NSNumber(value: (double / 100))
//        }else {
        number = NSNumber(value: double)

        guard number != 0 as NSNumber else {
            return 0
        }
        
        print("amountWithPrefix : \(amountWithPrefix)")
        return Double(amountWithPrefix) ?? 0
    }
    
    func returnDoubletoStrings(wDecimal: Bool = false,wSeparator: Bool = true) -> String {
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.currencySymbol = ""
        formatter.groupingSeparator = wSeparator ? "," : ""
        formatter.minimumFractionDigits = wDecimal ? 2 : 0
        formatter.maximumFractionDigits = wDecimal ? 2 : 0
        
        var amountWithPrefix = self
        
        let regex = try! NSRegularExpression(pattern: "[^0-9.]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
//        if double > 100 {
//            number = NSNumber(value: (double / 100))
//        }else {
        number = NSNumber(value: double)

        guard number != 0 as NSNumber else {
            return wDecimal ? "0.00": "0"
        }
        
        print("amountWithPrefix : \(amountWithPrefix)")
        return formatter.string(from: number) ?? "0"
    }
    
    func returnAmount() -> Double {
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.currencySymbol = ""
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
 
        var amountWithPrefix = self.replacingOccurrences(of: ",", with: "")
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: double)

        guard number != 0 as NSNumber else {
            return 0
        }
        
        return Double(amountWithPrefix) ?? 0
    }
    
    func returnDouble() -> Double {
           var number: NSNumber!
           let formatter = NumberFormatter()
           formatter.numberStyle = .decimal
           formatter.currencySymbol = ""
           formatter.minimumFractionDigits = 2
           formatter.maximumFractionDigits = 2
    
           let amountWithPrefix = self.replacingOccurrences(of: ",", with: "")
           let double = (amountWithPrefix as NSString).doubleValue
           number = NSNumber(value: double)

           guard number != 0 as NSNumber else {
               return 0
           }
           
        return Double(truncating: number)
    }
    
    
    func returnDecimalAmount(wDecimal: Bool = true) -> String {

        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "PHP"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        var amountWithPrefix = self

        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")

        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: double)
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return "PHP 0.00"
        }

        return formatter.string(from: number)!
    }
}
