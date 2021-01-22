//
//  FxData.swift
//  DA5-APP
//
//  Created by Jojo on 1/16/21.
//  Copyright © 2021 OA. All rights reserved.
//

import Foundation

struct CurrencyList: Decodable {
    var rates: [String: Double]?
    var base, date: String?
}
