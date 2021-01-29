//
//  PaybillsModel.swift
//  DA5-APP
//
//  Created by Jojo on 1/28/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

class PaybillsModel {
    let jsonUrlString = "\(ApiConfig().liveUrl)"
    let getBillers = "/paybills/getBillers"
    
    func getBillers(param: [String:Any],token: String?,completionHandler: @escaping (PaybillsData?,StatusList?) -> ()) {
       NetworkService<PaybillsData>().networkRequest(param, token: token, jsonUrlString: jsonUrlString + getBillers) { (data,status) in
           if let dataReceived = data {
              completionHandler(dataReceived,nil)
              return
           }
           completionHandler(nil,StatusList(status: 0, title: "",message: status?.message ?? "Something went wrong",tag: 1))
        }
    }
    
    
}
