//
//  EloadProducts.swift
//  DA5-APP
//
//  Created by Jojo on 1/5/21.
//  Copyright © 2021 OA. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct ELoadData: Decodable {
    var status: Int?
    var result: String?
    var collection: ELoadCollection?
}

// MARK: - Collection
struct ELoadCollection: Decodable {
    var data: [ELoadProducts]?
    var status, message: String?
}

// MARK: - Datum
struct ELoadProducts: Decodable {
    var productName, productCode, minAmount, maxAmount: String?
    var network: String?
    var telcoTag: String?

    enum CodingKeys: String, CodingKey {
        case productName = "ProductName"
        case productCode = "ProductCode"
        case minAmount = "MinAmount"
        case maxAmount = "MaxAmount"
        case network = "Network"
        case telcoTag = "TelcoTag"
    }
}

