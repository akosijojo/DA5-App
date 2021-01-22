//
//  HomeViewModel.swift
//  DA5-APP
//
//  Created by Jojo on 12/15/20.
//  Copyright © 2020 OA. All rights reserved.
//

import Foundation

class HomeViewModel : NSObject {
    var model : HomeModel?
    var token : String = ""
//    var onSuccessDeclineTransaction : ((StatusList?) -> Void)?
    var onSuccessGettingList : ((HomeData?) -> Void)?
    var onSuccessGenerateToken : ((APIToken?) -> Void)?
    var onSuccessUpdateToken : ((APIToken?) -> Void)?
    var onSuccessRequest : ((StatusList?) -> Void)?
    var onErrorHandling : ((StatusList?) -> Void)?


    func getHomeData(id: Int) {
        if token != "" {
            guard let dataModel = model else { return }
                    
             let completionHandler = { (data : HomeData?,status: StatusList?) in
                
                if let dataReceived = data {
                    self.onSuccessGettingList?(dataReceived)
                    return
                }
                
                self.onErrorHandling?(status)
             }
            
            let param : [String:String] = [
                "customer_id" : String(describing: id)
            ]
            dataModel.getHomeData(param: param, completionHandler: completionHandler)
        }else {
            self.generateAPIToken()
        }
    }
    
    func generateAPIToken(update: Bool? = false) {
         guard let dataModel = model else { return }
                
          let completionHandler = { (data: APIToken?,status : StatusList?) in
              if let result = data {
                //MARK: Save Token
                self.token = result.accessToken ?? ""
                if update == true {
                    self.onSuccessUpdateToken?(result)
                }else {
                    self.onSuccessGenerateToken?(result)
                }
              }else {
                  self.onErrorHandling?(status)
              }
         }
        
         let param : [String:String] = [
          "username"     : ApiConfig().apiUsername,
          "password"     : ApiConfig().apiPassword
         ]
     
         dataModel.generateAPIToken(param: param, completionHandler: completionHandler)
    }
    
    func declineTransaction(referenceNo: String) {
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
        ]
    
        dataModel.declineTransaction(param: param, completionHandler: completionHandler)
    }
    
}
