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
    var onSuccessDataRequest: ((StatusList?) -> Void)?
    var onSuccessRequest : ((StatusList?) -> Void)?
    var onErrorHandling : ((StatusList?) -> Void)?

    func cashIn(amount: String, customerId: Int, partnerId: String) {
        guard let dataModel = model else { return }
                
         let completionHandler = { (data : ELoadData?,status: StatusList?) in
            
            if let dataReceived = data {
//                self.onSuccessDataRequest?(dataReceived)
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
                
         let completionHandler = { (data : ELoadData?,status: StatusList?) in
            
            if let dataReceived = data {
//                self.onSuccessDataRequest?(dataReceived)
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
}
