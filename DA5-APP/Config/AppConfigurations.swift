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
    
    var url = "https";

}

class Parameters {

    static let shared = Parameters()

    var logOutPostData   : [String: Any] = ["api": "Accounts", "module": "login2", "function": "signOut"]
    
    var loginPostData   : [String: Any] = ["api": "Accounts", "module": "login2", "function": "logThisUser"]
    
}
