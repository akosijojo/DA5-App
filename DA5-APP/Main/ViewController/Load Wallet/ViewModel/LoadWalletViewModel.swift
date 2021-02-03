//
//  LoadWalletViewModel.swift
//  DA5-APP
//
//  Created by Jojo on 1/7/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

class LoadWalletViewModel: NSObject {
    var model : LoadWalletModel?
    var onSuccessPartnerList: ((PartnerList?) -> Void)?
    var onSuccessWalletDetailsData: ((WalletDetailsData?) -> Void)?
    var onSuccessDataRequest: ((SubmitCashInOutData?) -> Void)?
    var onSuccessRequest : ((StatusList?) -> Void)?
    var onErrorHandling : ((StatusList?) -> Void)?

    func getList() {
        guard let dataModel = model else { return }
                
         let completionHandler = { (data : PartnerList?,status: StatusList?) in
            
            if let dataReceived = data {
                self.onSuccessPartnerList?(dataReceived)
                return
            }
            
            self.onErrorHandling?(status)
         }
            
     
        dataModel.getList(param: [:], completionHandler: completionHandler)
    }
    
    func cashIn(amount: String, customerId: Int, partnerId: String) {
        guard let dataModel = model else { return }
                
         let completionHandler = { (data : SubmitCashInOutData?,status: StatusList?) in
            
            if let dataReceived = data {
                self.onSuccessDataRequest?(dataReceived)
                return
            }
            
            self.onErrorHandling?(status)
         }
            
        let param : [String:String] = [
            "amount": amount,
            "customer_id" : "\(customerId)",
            "partner_id": partnerId,
        ]
    
        dataModel.cashIn(param: param, completionHandler: completionHandler)
    }
    
    func cashOut(amount: String, customerId: Int, partnerId: String) {
        guard let dataModel = model else { return }
                
         let completionHandler = { (data : SubmitCashInOutData?,status: StatusList?) in
            
            if let dataReceived = data {
                self.onSuccessDataRequest?(dataReceived)
                return
            }
            
            self.onErrorHandling?(status)
         }
            
        let param : [String:String] = [
            "amount": amount,
            "customer_id" : "\(customerId)",
            "partner_id": partnerId,
        ]
        dataModel.cashOut(param: param, completionHandler: completionHandler)
    }
    
    func sendMoneyDetails(amount: String, customerId: Int, phone: String){
          guard let dataModel = model else { return }
                          
           let completionHandler = { (data : WalletTransferDetailsData?,status: StatusList?) in
              
              if let dataReceived = data {
                self.onSuccessWalletDetailsData?(dataReceived.data)
                  return
              }
              
              self.onErrorHandling?(status)
           }
              
          let param : [String:String] = [
              "amount": amount,
              "customer_id" : "\(customerId)",
              "phone": phone,
          ]
          dataModel.sendMoneyDetails(param: param, completionHandler: completionHandler)
    }
    
    func sendMoney(amount: String, customerId: Int, phone: String){
        guard let dataModel = model else { return }
                        
         let completionHandler = { (data : ReturReferenceData?,status: StatusList?) in
            
            if let dataReceived = data {
                self.onSuccessRequest?(StatusList(status: 0, title: "Transaction successful!", message: dataReceived.referenceNo, tag: 1))
                return
            }
            
            self.onErrorHandling?(status)
         }
            
        let param : [String:String] = [
            "amount": amount,
            "customer_id" : "\(customerId)",
            "phone": phone,
        ]
        dataModel.sendMoney(param: param, completionHandler: completionHandler)
    }
}
