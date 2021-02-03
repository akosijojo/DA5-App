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
    let getListPartner = "/partner/getList"
    let loadWalletCashIn = "/partner/cashIn"
    let loadWalletCashOut = "/partner/cashOut"
    let walletTransferDetails = "/customer/checkWalletTransfer"
    let walletTransfer = "/customer/sendMoney"
    var token: String? = ""

    func getList(param: [String:Any],completionHandler: @escaping (PartnerList?,StatusList?) -> ()) {
       NetworkService<PartnerList>().networkRequest(param,token: token, jsonUrlString: jsonUrlString + getListPartner) { (data,status) in
               if let dataReceived = data {
                       completionHandler(dataReceived,nil)
                       return
               }
               completionHandler(nil,StatusList(status: 0, title: "",message: status?.message ?? "Something went wrong",tag: 1))
       }
    }
    
    func cashIn(param: [String:Any],completionHandler: @escaping (SubmitCashInOutData?,StatusList?) -> ()) {
        NetworkService<SubmitCashInOutData>().networkRequest(param,token: token, jsonUrlString: jsonUrlString + loadWalletCashIn) { (data,status) in
                if let dataReceived = data {
                        completionHandler(dataReceived,nil)
                        return
                }
                completionHandler(nil,StatusList(status: 0, title: "",message: status?.message ?? "Something went wrong",tag: 1))
        }
    }
    func cashOut(param: [String:Any],completionHandler: @escaping (SubmitCashInOutData?,StatusList?) -> ()) {
          NetworkService<SubmitCashInOutData>().networkRequest(param,token: token, jsonUrlString: jsonUrlString + loadWalletCashOut) { (data,status) in
                  if let dataReceived = data {
                          completionHandler(dataReceived,nil)
                          return
                  }
                  completionHandler(nil,StatusList(status: 0, title: "",message: status?.message ?? "Something went wrong",tag: 1))
          }
    }
    
    func sendMoneyDetails(param: [String:Any],completionHandler: @escaping (WalletTransferDetailsData?,StatusList?) -> ()) {
          NetworkService<WalletTransferDetailsData>().networkRequest(param,token: token, jsonUrlString: jsonUrlString + walletTransferDetails) { (data,status) in
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
