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
     let uploadImage = "/upload/image"
     let getOtp = "/auth/getOTP"
     let createAccount = "/auth/getOTP"
     
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
}
