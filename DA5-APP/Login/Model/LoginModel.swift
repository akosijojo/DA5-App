//
//  LoginModel.swift
//  DA5-APP
//
//  Created by Jojo on 11/27/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

class LoginModel {
     let jsonUrlString = "\(ApiConfig().getUrl())"
    
//     let logFb = "/facebookLogin"
//     let getCode = "/getcode"
//     let signUp = "/signup"

     let logIn = "/auth/login"
     let nationality = "/auth/getNationals"
     
     func login(param: [String:Any],completionHandler: @escaping (LoginData?,StatusList?) -> ()) {
         NetworkService<LoginData>().networkRequest(param, jsonUrlString: jsonUrlString + logIn) { (data,status) in
             if let dataReceived = data {
                     completionHandler(dataReceived,nil)
                     return
             }
             completionHandler(nil,StatusList(status: 0, title: "",message: status?.message ?? "Something went wrong",tag: nil))
         }
     }
    
     func getNationality(param: [String:Any],completionHandler: @escaping (Nationality?,StatusList?) -> ()) {
         NetworkService<Nationality>().networkRequest(param, jsonUrlString: jsonUrlString + nationality) { (data,status) in
             if let dataReceived = data {
//                 if let dataList = dataReceived.data {
                     completionHandler(dataReceived,nil)
                     return
//                 }
             }
            completionHandler(nil,StatusList(status: 0, title: "",message: status?.message ?? "Something went wrong",tag: nil))
     
         }
     }
}
