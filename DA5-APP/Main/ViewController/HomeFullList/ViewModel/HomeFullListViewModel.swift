//
//  HomeFullListViewModel.swift
//  DA5-APP
//
//  Created by Jojo on 1/25/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

class HomeFullListViewModel: NSObject {
    var model : HomeFullListModel?
    
    var onSuccessPendingList: (([PendingTransactionsData]?) -> Void)?
    var onSuccessTransactionsList: (([TransactionHistoryData]?) -> Void)?
    var onSuccessRequest : ((StatusList?) -> Void)?
    var onErrorHandling : ((StatusList?) -> Void)?
    
    var vPage : Int = 0
    
    
    func getPendingTransactions(page: Int? = nil, token: String?) {
        guard let dataModel = model else { return }
                
         let completionHandler = { (response : PendinguFullData?,status: StatusList?) in
//
            if let dataReceived = response {
                self.onSuccessPendingList?(dataReceived.data)
                self.vPage += 1
                print("add page for getting new")
                return
            }

            self.onErrorHandling?(status)
         }
        
        if let pager = page {
            vPage = pager
        }
        
        let pager = page != nil ? page : vPage
        
        let param : [String:String] = [
            "customer_id" : "\(UserLoginData.shared.id ?? 0)",
            "page" : "\(pager ?? 0)",
            "limit": "10"
        ]
        dataModel.getAllPendingTransaction(param: param, token: token ,completionHandler: completionHandler)
    }
    
    func declineTransaction(referenceNo: String,type: String, token: String?) {
          guard let dataModel = model else { return }
                         
          let completionHandler = { (data: StatusList?,status : StatusList?) in
               if let result = data {
                   self.onSuccessRequest?(result)
               }else {
                   self.onErrorHandling?(status)
               }
          }
             
          let param : [String:String] = [
              "reference_no"     : referenceNo,
              "type"             : type
          ]
      
        dataModel.declineTransaction(param: param, token: token,completionHandler: completionHandler)
    }
    
    func getAllTransactionHistory(page: Int? = nil, token: String?) {
        guard let dataModel = model else { return }
                
         let completionHandler = { (response : TransactHistoryFullData?,status: StatusList?) in
//
            if let dataReceived = response {
                self.onSuccessTransactionsList?(dataReceived.data)
                self.vPage += 1
                print("add page for getting new")
                return
            }

            self.onErrorHandling?(status)
         }
        
        if let pager = page {
            vPage = pager
        }
        
        let pager = page != nil ? page : vPage
        
        let param : [String:String] = [
            "customer_id" : "\(UserLoginData.shared.id ?? 0)",
            "page" : "\(pager ?? 0)",
            "limit": "10"
        ]
        dataModel.getAllTransactionHistory(param: param, token: token ,completionHandler: completionHandler)
    }
    
    func getAllNews(page: Int? = nil,token: String?) {
         guard let dataModel = model else { return }
                        
         let completionHandler = { (data: StatusList?,status : StatusList?) in
//              if let result = data {
//                  self.onSuccessRequest?(result)
//                  self.vPage += 1
//                  print("add page for getting new")
//              }else {
//                  self.onErrorHandling?(status)
//              }
         }
            
        if let pager = page {
            vPage = pager
        }
        
        let pager = page != nil ? page : vPage
        
        let param : [String:String] = [
            "page" : "\(pager ?? 0)",
            "limit": "10"
        ]
        
        dataModel.getAllNews(param: param, token: token ,completionHandler: completionHandler)
    }
        
}

