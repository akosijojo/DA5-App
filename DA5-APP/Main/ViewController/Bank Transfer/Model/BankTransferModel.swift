//
//  BankTransferModel.swift
//  DA5-APP
//
//  Created by Jojo on 1/13/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

class BankTransferModel {
     let jsonUrlString = "\(ApiConfig().getUrl())"
     let bankList = "/instapay/getInstaPayBanks"
     let submitTransfer = "/instapay/instaPayProcess"
     let eloadSubmit = "/partner/cashOut"
    
    func getBankList(param: [String:Any],token: String? ,completionHandler: @escaping (BankListDataCollection?,StatusList?) -> ()) {
         NetworkService<BankListDataCollection>().networkRequest(param,token: token, jsonUrlString: jsonUrlString + bankList) { (data,status) in
                 if let dataReceived = data {
                         completionHandler(dataReceived,nil)
                         return
                 }
                 completionHandler(nil,StatusList(status: 0, title: "",message: status?.message ?? "Something went wrong",tag: 1))
         }
     }
    
    func submitBankTransfer(param: [String:Any],token: String? ,completionHandler: @escaping (BankTransactionDetails?,StatusList?) -> ()) {
           NetworkService<BankTransactionDetails>().networkRequest(param,token: token, jsonUrlString: jsonUrlString + submitTransfer) { (data,status) in
                   if let dataReceived = data {
                           completionHandler(dataReceived,nil)
                           return
                   }
                   completionHandler(nil,StatusList(status: 0, title: "",message: status?.message ?? "Something went wrong",tag: 1))
           }
       }
      
}
