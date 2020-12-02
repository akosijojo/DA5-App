//
//  AppConfigurations.swift
//  DA5-APP
//
//  Created by Jojo on 8/27/20.
//  Copyright © 2020 OA. All rights reserved.
//

import Foundation

class AppConfig {
    
}

class ApiConfig {
    
    var env : String = "dev" //live or dev
    
    
    var url = "https";
    
    func getUrl() -> String {
        if env == "live" {
           url = "https"
        }else {
           url = "https://da5app.orangeapps.ph/api"
        }
        return url
    }

}

class Parameters {

    static let shared = Parameters()

    var logOutPostData   : [String: Any] = ["api": "Accounts", "module": "login2", "function": "signOut"]
    
    var loginPostData   : [String: Any] = ["api": "Accounts", "module": "login2", "function": "logThisUser"]
    
}
