//
//  TransactionHistoryData.swift
//  DA5-APP
//
//  Created by Jojo on 11/25/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

struct TransactionHistoryData:Decodable {
    let id : Int
    let title : String
    let info : String
    let image : String
    let amount : String
    let date : String
    
    init(id: Int, title: String, info: String, image: String, amount: String, date: String) {
        self.id = id
        self.title = title
        self.info = info
        self.image = image
        self.amount = amount
        self.date = date
    }
}


