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

     let logIn = "/auth/login"
     let nationality = "/auth/getNationals"
     let register = "/auth/register"
     let uploadImage = "/upload/image"
     let getOtp = "/auth/getOTP"
     let createAccount = "/auth/getOTP"
     let saveMpin = "/customer/saveMPIN"
     let checkMpinOtp = "/customer/checkMPINOTP"
     let apiToken = "/auth/generateAPIToken"
     let fbLogin = "/auth/facebookLogin"
     
     func login(param: [String:Any],completionHandler: @escaping (LoginData?,StatusList?) -> ()) {
         NetworkService<LoginData>().networkRequest(param, jsonUrlString: jsonUrlString + logIn) { (data,status) in
             if let dataReceived = data {
                     completionHandler(dataReceived,nil)
                     return
             }
             completionHandler(nil,StatusList(status: 0, title: "",message: status?.message ?? "Something went wrong",tag: nil))
         }
     }

    func loginByFb(param: [String:Any],completionHandler: @escaping (LoginFb?,StatusList?) -> ()) {
        NetworkService<LoginFb>().networkRequest(param, jsonUrlString: jsonUrlString + fbLogin) { (data,status) in
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
    
     func createAccount(param: [String:Any],completionHandler: @escaping (LoginData?,StatusList?) -> ()) {
         NetworkService<LoginData?>().networkRequest(param, jsonUrlString: jsonUrlString + register) { (data,status) in
             if let dataReceived = data {
                 completionHandler(dataReceived,nil)
                 return
             }
            completionHandler(nil,StatusList(status: 0, title: "",message: status?.message ?? "Something went wrong",tag: nil))
     
         }
     }
    
    func uploadImage(image: [Media],param: Parameter?, session: URLSession,completionHandler: @escaping (ImageUploadData?,StatusList?) -> ()) {
        NetworkService<ImageUploadData?>().uploadFile(image, param, jsonUrlString: jsonUrlString + uploadImage, session: session) { (data, status) in
             if let dataReceived = data {
//                 if let dataList = dataReceived.data {
                     completionHandler(dataReceived,nil)
                     return
//                 }
             }
            completionHandler(nil,StatusList(status: 0, title: "",message: status?.message ?? "Something went wrong",tag: nil))
        }
    }
    
    func getOtp(param: [String:Any],completionHandler: @escaping (StatusList) -> ()) {
        NetworkService<StatusMessage>().networkRequest(param, jsonUrlString: jsonUrlString + getOtp) { (data,status) in
            if let res = data {
            print("DATA :", res)
                completionHandler(StatusList(status:res.message.contains("Success") ? 1 : 0, title: "",message: res.message ,tag: 1))
                return
            }
            completionHandler(StatusList(status: 0, title: "",message: status?.message ?? "Something went wrong",tag: nil))
        }
    }
    
    func generateAPIToken(param: [String:Any],completionHandler: @escaping (APIToken?,StatusList?) -> ()) {
       NetworkService<APIToken>().networkRequest(param, jsonUrlString: jsonUrlString + apiToken) { (data,status) in
          if let res = data {
              completionHandler(res,nil)
              return
          }
         completionHandler(nil,StatusList(status: 0, title: "",message: status?.message ?? "Something went wrong",tag: nil))
       }
    }
    
    func saveMpin(param: [String:Any],token: String,completionHandler: @escaping (LoginData?,StatusList?) -> ()) {
       NetworkService<LoginData>().networkRequest(param,token: token, jsonUrlString: jsonUrlString + saveMpin) { (data,status) in
           if let res = data {
               completionHandler(res,nil)
               return
           }
           completionHandler(nil,StatusList(status: 0, title: "",message: status?.message ?? "Something went wrong",tag: nil))
       }
    }
    
    func checkMpin(param: [String:Any],token: String?,completionHandler: @escaping (StatusList) -> ()) {
        NetworkService<StatusList>().networkRequest(param,token: token, jsonUrlString: jsonUrlString + checkMpinOtp) { (data,status) in
           if let res = data {
               completionHandler(StatusList(status:res.message.contains("Success") ? 1 : 0, title: "",message: res.message ,tag: 1))
               return
           }
           completionHandler(StatusList(status: 0, title: "",message: status?.message ?? "Something went wrong",tag: nil))
       }
    }
}
