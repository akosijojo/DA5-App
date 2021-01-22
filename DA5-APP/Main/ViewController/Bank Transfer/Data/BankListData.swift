//
//  BankListData.swift
//  DA5-APP
//
//  Created by Jojo on 1/13/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

struct BankListDataCollection: Decodable {
    var status: Int?
    var result: String?
    var collection: [BankListData]?
}

// MARK: - Collection
struct BankListData: Decodable {
    var code, bank, brstn: String?
}


struct TransferDetails: Decodable {
    var bank: BankListData?
    var accountName: String?
    var accountNumber: String?
    var transactionFee: String?
    var amount: String?
}
