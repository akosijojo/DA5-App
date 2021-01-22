//
//  ELoadModel.swift
//  DA5-APP
//
//  Created by Jojo on 1/5/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

class ELoadModel {
    
    let jsonUrlString = "\(ApiConfig().getUrl())"
    let eloadProducts = "/eload/getELoadProducts"
    let eloadSubmit = "/eload/eLoadProcess"
    
    
    func getEloadProducts(param: [String:Any],token : String?,completionHandler: @escaping (ELoadData?,StatusList?) -> ()) {
        NetworkService<ELoadData>().networkRequest(param,token: token, jsonUrlString: jsonUrlString + eloadProducts) { (data,status) in
             if let dataReceived = data {
                     completionHandler(dataReceived,nil)
                     return
             }
             completionHandler(nil,StatusList(status: 0, title: "",message: status?.message ?? "Something went wrong",tag: 1))
        }
    }
    
    func submitEloadProcess(param: [String:Any],token : String?,completionHandler: @escaping (StatusList?,StatusList?) -> ()) {
        NetworkService<StatusListData>().networkRequest(param,token: token, jsonUrlString: jsonUrlString + eloadSubmit) { (data,status) in
             if let res = data {
                     completionHandler(StatusList(status: 0, title: "", message: res.message, tag: 1),nil)
                     return
             }
             completionHandler(nil,StatusList(status: 0, title: "",message: status?.message ?? "Something went wrong",tag: 1))
        }
    }
}
    
