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
    var tokenLocalKey : String = "CustomerTokenKey"
    var refreshTokenLocalKey : String = "CustomerRefreshToken"
}
//MARK:- API CONFIGURATIONS
class ApiConfig {
    
    var env : String = "live" //live or dev
    var url = "https";
    
    var apiUsername : String = "da5"
    var apiPassword : String = "da5password" //5zYw9h3aMifV7da
    
    var currencyApi : String = "https://api.exchangeratesapi.io/latest"
    var liveUrl : String = "https://daps.com.ph/api"
    
    func getUrl() -> String {
        if env == "live" {
           url = "https://daps.com.ph/api"
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
