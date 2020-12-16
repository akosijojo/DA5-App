//
//  AppConfigurations.swift
//  DA5-APP
//
//  Created by Jojo on 8/27/20.
//  Copyright © 2020 OA. All rights reserved.
//

import Foundation

//MARK:- APP CONFIGURATIONS
class AppConfig {
    var customerLocalKey : String = "CustomerLocalData"
    var tokenLocalKey : String = "CustomerLocalData"
}
//MARK:- API CONFIGURATIONS
class ApiConfig {
    
    var env : String = "dev" //live or dev
    var url = "https";
    
    var apiUsername : String = "da5"
    var apiPassword : String = "da5password"
    

    func getUrl() -> String {
        if env == "live" {
           url = "https"
        }else {
           url = "https://da5app.orangeapps.ph/api"
        }
        return url
    }

}
//MARK:- API SET ENCODER
class Parameters {

    static let shared = Parameters()

    var logOutPostData   : [String: Any] = ["api": "Accounts", "module": "login2", "function": "signOut"]
    
    var loginPostData   : [String: Any] = ["api": "Accounts", "module": "login2", "function": "logThisUser"]
    
}
