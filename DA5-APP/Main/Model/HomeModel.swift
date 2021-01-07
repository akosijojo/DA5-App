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
     
}
