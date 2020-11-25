//
//  AccountData.swift
//  DA5-APP
//
//  Created by Jojo on 11/25/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

struct AccountData:Decodable {
    let id : Int
    let name : String
    let image : String
    let balance: String
    
    init(id: Int, name: String, image: String, balance: String) {
        self.id = id
        self.name = name
        self.image = image
        self.balance = balance
    }
}
