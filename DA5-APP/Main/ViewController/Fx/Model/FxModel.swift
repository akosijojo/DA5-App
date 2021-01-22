//
//  FxModel.swift
//  DA5-APP
//
//  Created by Jojo on 1/16/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

class FxModel {
    let jsonUrlString = "\(ApiConfig().getUrl())"
    let getCurrency = "\(ApiConfig().currencyApi)?"
    let sumbitFxExchange = "/customer/fxExchange"


    func getCurrency(param: [String:Any],completionHandler: @escaping (CurrencyList?,StatusList?) -> ()) {
        NetworkService<CurrencyList>().networkRequest(param,type: .get, jsonUrlString: getCurrency+"base=\(param["base"] ?? "")") { (data,status) in
            if let dataReceived = data {
                    completionHandler(dataReceived,nil)
                    return
            }
            completionHandler(nil,StatusList(status: 0, title: "",message: status?.message ?? "Something went wrong",tag: 1))
       }
    }
    
    func fxExchange(param: [String:Any] ,token: String?,completionHandler: @escaping (ReturReferenceData?,StatusList?) -> ()) {
          NetworkService<ReturReferenceData>().networkRequest(param,token: token, jsonUrlString: jsonUrlString + sumbitFxExchange) { (data,status) in
              if let dataReceived = data {
                      completionHandler(dataReceived,nil)
                      return
              }
              completionHandler(nil,StatusList(status: 0, title: "",message: status?.message ?? "Something went wrong",tag: 1))
         }
    }
}
