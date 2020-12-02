//
//  LoginViewModel.swift
//  DA5-APP
//
//  Created by Jojo on 11/27/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

class LoginViewModel {
    var model : LoginModel?
    
    var onSuccessGettingList : ((Customer?) -> Void)?
    var returnNationalityList : ((Nationality?) -> Void)?
    var onSuccessRequest : ((StatusList?) -> Void)?
    var onErrorHandling : ((StatusList?) -> Void)?
       
    
    func login(param: [String:Any],fb: Bool = false) {
        
        guard let dataModel = model else { return }
        
        var error : StatusList?
        
        if param["username"] as? String == "" || param["password"] as? String == "" {
          self.onErrorHandling?(StatusList(status: 0, title: "", message: "Please enter your login credentials", tag: 0))
            return
        }else {
            let completionHandler = { (data : LoginData?,status: StatusList?) in
                
                if status == nil {
                    print("DATA : \(data)")
                    if let dataReceived = data, dataReceived.customer != nil {
                        print("DATA GET LOGIN : \(dataReceived)")
                        self.onSuccessGettingList?(dataReceived.customer)
                        return
                    }else {
                         print("NO DAT")
                         self.onErrorHandling?(StatusList(status: 0, title: "", message: "Incorrect email/phone or password", tag: 0))
                         return
                    }
                }else {
                   self.onErrorHandling?(status)
                   return
                }
            }
            
//        if fb {
//            dataModel.loginFb(param: param, completionHandler: completionHandler)
//        }else {
            dataModel.login(param: param, completionHandler: completionHandler)
//        }
        }
        
        
      
    }
    
    func getNationality() {
         guard let dataModel = model else { return }
                
         let completionHandler = { (data : Nationality?,status: StatusList?) in
            
            if let dataReceived = data {
                self.returnNationalityList?(dataReceived)
                return
            }
            
            self.onErrorHandling?(status)
         }
        
//        if fb {
//            dataModel.loginFb(param: param, completionHandler: completionHandler)
//        }else {
        dataModel.getNationality(param: [:], completionHandler: completionHandler)
    }
}
