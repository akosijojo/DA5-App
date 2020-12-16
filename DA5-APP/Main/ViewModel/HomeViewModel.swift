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
    var onSuccessGettingList : ((HomeData?) -> Void)?
    var onSuccessGenerateToken : ((APIToken?) -> Void)?
    var onSuccessRequest : ((StatusList?) -> Void)?
    var onErrorHandling : ((StatusList?) -> Void)?


    func getHomeData(id: Int) {
        
        print("GET HOME DATA")
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
//        if fb {
//            dataModel.loginFb(param: param, completionHandler: completionHandler)
//        }else {
        dataModel.getHomeData(param: param, completionHandler: completionHandler)
    }
    
    func generateAPIToken() {
         guard let dataModel = model else { return }
                
          let completionHandler = { (data: APIToken?,status : StatusList?) in
              if let result = data {
                  self.onSuccessGenerateToken?(result)
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
}
