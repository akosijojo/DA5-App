//
//  HomeFullListModel.swift
//  DA5-APP
//
//  Created by Jojo on 1/25/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

class HomeFullListModel {
    let jsonUrlString = "\(ApiConfig().getUrl())"
    let getPendingList = "/customer/getPendingTransactions"
   let declineTransact = "/customer/cancelPendingTransaction"
    let getTransactionHistory = "/customer/getTransactionHistories"

    func getAllPendingTransaction(param: [String:Any],token: String?,completionHandler: @escaping (PendinguFullData?,StatusList?) -> ()) {
        NetworkService<PendinguFullData>().networkRequest(param,token: token, type: .post, jsonUrlString: jsonUrlString + getPendingList) { (data,status) in
            if let dataReceived = data {
                completionHandler(dataReceived,nil)
                return
            }
            completionHandler(nil,StatusList(status: 0, title: "",message: status?.message ?? "Something went wrong",tag: 1))
       }
    }
    
    func declineTransaction(param: [String:Any],token: String?,completionHandler: @escaping (StatusList?,StatusList?) -> ()) {
          NetworkService<StatusListData>().networkRequest(param, token: token, jsonUrlString: jsonUrlString + declineTransact) { (data,status) in
              if let res = data {
                  completionHandler(StatusList(status: 0, title: "", message: res.message, tag: 2),nil)
                  return
              }
            completionHandler(StatusList(status: 0, title: "",message: "Transaction cancelled",tag: 2),nil)
           }
    }
    
    func getAllTransactionHistory(param: [String:Any],token: String?,completionHandler: @escaping (TransactHistoryFullData?,StatusList?) -> ()) {
         NetworkService<TransactHistoryFullData>().networkRequest(param, token: token, jsonUrlString: jsonUrlString + getTransactionHistory) { (data,status) in
             if let dataReceived = data {
                completionHandler(dataReceived,nil)
                return
             }
             completionHandler(nil,StatusList(status: 0, title: "",message: status?.message ?? "Something went wrong",tag: 1))
          }
   }
    
}
