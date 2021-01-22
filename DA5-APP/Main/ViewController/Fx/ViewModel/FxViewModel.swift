//
//  FxViewModel.swift
//  DA5-APP
//
//  Created by Jojo on 1/16/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

class FxViewModel: NSObject {
    var model : FxModel?
    
    var onSuccessCurrencyList: ((CurrencyList?) -> Void)?
    var onSuccessRequest : ((StatusList?) -> Void)?
    var onErrorHandling : ((StatusList?) -> Void)?
    
    func getCurrency(base: String) {
        guard let dataModel = model else { return }
                
         let completionHandler = { (data : CurrencyList?,status: StatusList?) in
//
            if let dataReceived = data {
                self.onSuccessCurrencyList?(dataReceived)
                return
            }

            self.onErrorHandling?(status)
         }
            
        let param : [String:String] = [
            "base" : base
        ]
        dataModel.getCurrency(param: param, completionHandler: completionHandler)
    }
    
    func fxExchange(currency: String?,amount: String?,convertedAmount: String? , token: String? ) {
        guard let dataModel = model else { return }
                
         let completionHandler = { (data : ReturReferenceData?,status: StatusList?) in
            if let dataReceived = data {
                self.onSuccessRequest?(StatusList(status: 0, title: "Transaction successful!", message: dataReceived.referenceNo, tag: 1))
                return
            }

            self.onErrorHandling?(status)
         }
            
        let param : [String:String] = [
            "customer_id": "\(UserLoginData.shared.id ?? 0)",
            "amount": amount ?? "",
            "currency": currency ?? "",
            "converted_amount": convertedAmount ?? ""
        ]
        
        dataModel.fxExchange(param: param,token: token, completionHandler: completionHandler)
    }
        
    
}
