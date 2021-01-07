//
//  ELoadViewModel.swift
//  DA5-APP
//
//  Created by Jojo on 1/5/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit
class ELoadViewModel : NSObject {
    var model : ELoadModel?
    var onSuccessDataRequest: ((ELoadData?) -> Void)?
    var onSuccessRequest : ((StatusList?) -> Void)?
    var onErrorHandling : ((StatusList?) -> Void)?

    func getELoadProducts(phoneNumber: String) {
        guard let dataModel = model else { return }
                
         let completionHandler = { (data : ELoadData?,status: StatusList?) in
            
            if let dataReceived = data {
                self.onSuccessDataRequest?(dataReceived)
                return
            }
            
            self.onErrorHandling?(status)
         }
            
        let param : [String:String] = [
            "phone" : phoneNumber
        ]
        dataModel.getEloadProducts(param: param, completionHandler: completionHandler)
    }
    
}

