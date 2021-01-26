//
//  LoadWalletModel.swift
//  DA5-APP
//
//  Created by Jojo on 1/7/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

class LoadWalletModel {
    let jsonUrlString = "\(ApiConfig().getUrl())"
    let eloadProducts = "/partner/cashIn"
    let eloadSubmit = "/partner/cashOut"
    let walletTransfer = "/customer/sendMoney"
    var token: String? = ""
   
    func cashIn(param: [String:Any],completionHandler: @escaping (SubmitCashInOutData?,StatusList?) -> ()) {
        NetworkService<SubmitCashInOutData>().networkRequest(param,token: token, jsonUrlString: jsonUrlString + eloadProducts) { (data,status) in
                if let dataReceived = data {
                        completionHandler(dataReceived,nil)
                        return
                }
                completionHandler(nil,StatusList(status: 0, title: "",message: status?.message ?? "Something went wrong",tag: 1))
        }
    }
    func cashOut(param: [String:Any],completionHandler: @escaping (SubmitCashInOutData?,StatusList?) -> ()) {
          NetworkService<SubmitCashInOutData>().networkRequest(param,token: token, jsonUrlString: jsonUrlString + eloadProducts) { (data,status) in
                  if let dataReceived = data {
                          completionHandler(dataReceived,nil)
                          return
                  }
                  completionHandler(nil,StatusList(status: 0, title: "",message: status?.message ?? "Something went wrong",tag: 1))
          }
    }
    func sendMoney(param: [String:Any],completionHandler: @escaping (ReturReferenceData?,StatusList?) -> ()) {
          NetworkService<ReturReferenceData>().networkRequest(param,token: token, jsonUrlString: jsonUrlString + walletTransfer) { (data,status) in
                  if let dataReceived = data {
                          completionHandler(dataReceived,nil)
                          return
                  }
                  completionHandler(nil,StatusList(status: 0, title: "",message: status?.message ?? "Something went wrong",tag: 1))
          }
    }
}
