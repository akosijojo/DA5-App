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

// MARK: - Welcome
struct BankTransactionDetails: Decodable {
    let status: Int
    let transStatus: TransStatus
    let message, result: String

    enum CodingKeys: String, CodingKey {
        case status
        case transStatus = "trans_status"
        case message, result
    }
}

// MARK: - TransStatus
struct TransStatus: Codable {
    let code, senderRefID, state, uuid: String
    let transStatusDescription, type, amount, ubpTranID: String
    let reversalUbpTranID: String?
    let coreRefID, traceNo, tranRequestDate: String

    enum CodingKeys: String, CodingKey {
        case code
        case senderRefID = "senderRefId"
        case state, uuid
        case transStatusDescription = "description"
        case type, amount
        case ubpTranID = "ubpTranId"
        case reversalUbpTranID = "reversalUbpTranId"
        case coreRefID = "coreRefId"
        case traceNo, tranRequestDate
    }
}
