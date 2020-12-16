//
//  Token.swift
//  DA5-APP
//
//  Created by Jojo on 12/11/20.
//  Copyright © 2020 OA. All rights reserved.
//

import Foundation

// MARK: - APIToken
struct APIToken: Decodable {
    var accessToken : String?
    var tokenType   : String?
    var expiresIn   : Int?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
    
}


struct APITokenLocal: Codable {
 
    var accessToken : String?
    var tokenType   : String?
    var expiresIn   : Int?

    
    func saveAPITokenToLocal() {
       let encoder = JSONEncoder()
       if let encoded = try? encoder.encode(self) {
            print("Saving TOKEN to local")
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: AppConfig().tokenLocalKey)
       }
    }

    func getAPITokenFromLocal() -> CustomerLocal? {
       let defaults = UserDefaults.standard
       if let savedCustomer = defaults.object(forKey: AppConfig().tokenLocalKey) as? Data {
           let decoder = JSONDecoder()
           if let customerData = try? decoder.decode(CustomerLocal.self, from: savedCustomer) {
              print("Get TOKEN from local")
              print(customerData)
              return customerData
           }
       }
       return nil
    }
}
