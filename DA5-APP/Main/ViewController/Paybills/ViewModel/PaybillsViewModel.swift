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
    
    
}
