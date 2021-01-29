//
//  HomeModel.swift
//  DA5-APP
//
//  Created by Jojo on 12/15/20.
//  Copyright © 2020 OA. All rights reserved.
//

import Foundation

class HomeModel {
    var token : String = ""
    let jsonUrlString = "\(ApiConfig().getUrl())"

    let homePath = "/customer/getHomeData"
    let apiToken = "/auth/generateAPIToken"
    let declineTransact = "/customer/cancelPendingTransaction"
    let logoutUser = "/auth/logout"
    
    func logout(param: [String:Any],completionHandler: @escaping (StatusList?) -> ()) {
        NetworkService<StatusMessage>().networkRequest(param,jsonUrlString: jsonUrlString + logoutUser) { (data,status) in
    
             completionHandler(StatusList(status: 1, title: "",message: status?.message ?? "Something went wrong",tag: nil))
        }
    }

    func getHomeData(param: [String:Any],completionHandler: @escaping (HomeData?,StatusList?) -> ()) {
        NetworkService<HomeData>().networkRequest(param, token: token,jsonUrlString: jsonUrlString + homePath) { (data,status) in
             if let dataReceived = data {
                     completionHandler(dataReceived,nil)
                     return
             }
             completionHandler(nil,StatusList(status: 0, title: "",message: status?.message ?? "Something went wrong",tag: 1))
        }
    }
    
    func generateAPIToken(param: [String:Any],completionHandler: @escaping (APIToken?,StatusList?) -> ()) {
        NetworkService<APIToken>().networkRequest(param, jsonUrlString: jsonUrlString + apiToken) { (data,status) in
           if let res = data {
                self.token  = res.accessToken ?? ""
               completionHandler(res,nil)
               return
           }
          completionHandler(nil,StatusList(status: 0, title: "",message: status?.message ?? "Something went wrong",tag: 1))
        }
     }
    
    func declineTransaction(param: [String:Any],completionHandler: @escaping (StatusList?,StatusList?) -> ()) {
        NetworkService<StatusListData>().networkRequest(param, token: token, jsonUrlString: jsonUrlString + declineTransact) { (data,status) in
            if let res = data {
                completionHandler(StatusList(status: 0, title: "", message: res.message, tag: 2),nil)
                return
            }
           completionHandler(StatusList(status: 0, title: "",message: "Transaction cancelled",tag: 2),nil)
         }
      }
}
