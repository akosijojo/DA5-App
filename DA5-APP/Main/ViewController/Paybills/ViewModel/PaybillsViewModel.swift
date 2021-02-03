//
//  PaybillsViewModel.swift
//  DA5-APP
//
//  Created by Jojo on 1/28/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

class PaybillsViewModel: NSObject {
    
    var model: PaybillsModel?
    
    var onSuccessPaybillsData: ((PaybillsData?) -> Void)?
    var onErrorHandling: ((StatusList?) -> Void)?
    
    func getBillers(token: String?) {
         guard let dataModel = model else { return }

         let completionHandler = { (response : PaybillsData?,status: StatusList?) in
//
            if let dataReceived = response {
                self.onSuccessPaybillsData?(dataReceived)
                return
            }

            self.onErrorHandling?(status)
         }
    
        dataModel.getBillers(param: [:], token: token ,completionHandler: completionHandler)
        
    }
    
 
    func paybillsProcess(token: String?, param: [[String:String]], billerCode : String) {
         guard let dataModel = model else { return }

         let completionHandler = { (response : PaybillsData?,status: StatusList?) in
//
            if let dataReceived = response {
                self.onSuccessPaybillsData?(dataReceived)
                return
            }

            self.onErrorHandling?(status)
            
         }
        
        let paramData : [String : Any] = [
            "customer_id" : UserLoginData.shared.id ?? 0,
            "biller_code" : billerCode,
            "meta_fields" : param,
        ]
        
        dataModel.paybillsProcess(param: paramData, token: token ,completionHandler: completionHandler)
        
    }
    
    
}
