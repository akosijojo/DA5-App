//
//  BankTransferViewModel.swift
//  DA5-APP
//
//  Created by Jojo on 1/13/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

class BankTransferViewModel: NSObject {
    var model : BankTransferModel?
    var onSuccessBankListData: ((BankListDataCollection?) -> Void)?
    var onSuccessRequest : ((StatusList?) -> Void)?
    var onErrorHandling : ((StatusList?) -> Void)?

    func getBankList(token: String?) {
        guard let dataModel = model else { return }
                   
        let completionHandler = { (data : BankListDataCollection?,status: StatusList?) in
               
            if let dataReceived = data {
                self.onSuccessBankListData?(dataReceived)
                return
            }
               
            self.onErrorHandling?(status)
        }

        dataModel.getBankList(param: [:],token: token, completionHandler: completionHandler)
    }
//    ,tAccountNumber : String?,tAccountName: String?,amount: String?,
    func submitBankTransfer(data: TransferDetails?,token: String?) {
       guard let dataModel = model else { return }
                  
       let completionHandler = { (data : BankTransactionDetails?,status: StatusList?) in
              
           if let _ = data {
               self.onSuccessRequest?(StatusList(status: 1, title: "", message: "Transaction successful", tag: 1))
               return
           }
              
           self.onErrorHandling?(status)
       }
        
        guard  let userId = UserLoginData.shared.id else {
            return
        }
        
        let param : [String: String] = [
            "BenAccountNumber"  : data?.accountNumber ?? "",
            "BenName"  : data?.accountName ?? "",
            "customer_id"  : "\(userId)",
            "Amount"  : data?.amount ?? "",
            "Bank"  : data?.bank?.code ?? "",
            "BankName"  : data?.bank?.bank ?? "" ,
        ]
        
        dataModel.submitBankTransfer(param:param,token: token, completionHandler: completionHandler)
   }
       
}
