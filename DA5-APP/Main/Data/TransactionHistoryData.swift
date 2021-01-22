//
//  TransactionHistoryData.swift
//  DA5-APP
//
//  Created by Jojo on 11/25/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

struct TransactionHistoryData:Decodable {
    var id : Int?
    var customerID: Int?
    var referenceNo: String?
    var status, type: Int?
    var createdAt, updatedAt: String?
    var cashInOut: CashInOut?
    var eload : Eload?
//    var walletTransfer :
    var fx : Fx?
    var instapay: Instapay?

    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
        case referenceNo = "reference_no"
        case status, type
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case cashInOut = "cash_in_out"
        case eload
//        case walletTransfer = "wallet_transfer"
        case fx, instapay
    }
}


// MARK: - Eload
struct Eload: Codable {
    var id, customerID: Int?
    var referenceNo: String?
    var status: Int?
    var phone, productAmount, productNetwork, productName: String?
    var productCode, resultStatus, resultCode, resultMessage: String?
    var transStatus: String?
    var transactionDate, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
        case referenceNo = "reference_no"
        case status, phone
        case productAmount = "product_amount"
        case productNetwork = "product_network"
        case productName = "product_name"
        case productCode = "product_code"
        case resultStatus = "result_status"
        case resultCode = "result_code"
        case resultMessage = "result_message"
        case transStatus = "trans_status"
        case transactionDate = "transaction_date"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Fx
struct Fx: Codable {
    var id, customerID: Int?
    var referenceNo: String?
    var status: Int?
    var amount, currency, transactionDate: String?
    var approvedAt, declinedAt, expiredAt: String?
    var createdAt, convertedAmount, customerName, customerPhone: String?

    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
        case referenceNo = "reference_no"
        case status, amount, currency
        case transactionDate = "transaction_date"
        case approvedAt = "approved_at"
        case declinedAt = "declined_at"
        case expiredAt = "expired_at"
        case createdAt = "created_at"
        case convertedAmount = "converted_amount"
        case customerName = "customer_name"
        case customerPhone = "customer_phone"
    }
}

// MARK: - Instapay
struct Instapay: Codable {
    var id, customerID: Int?
    var referenceNo: String?
    var status: Int?
    var bankName, amount, senderRefID, uuid: String?
    var ubpTranID: String?
    var reversalUbpTranID: String?
    var coreRefID, traceNo, resultStatus, resultCode: String?
    var resultMessage: String?
    var tranRequestDate, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
        case referenceNo = "reference_no"
        case status, bankName, amount
        case senderRefID = "senderRefId"
        case uuid
        case ubpTranID = "ubpTranId"
        case reversalUbpTranID = "reversalUbpTranId"
        case coreRefID = "coreRefId"
        case traceNo
        case resultStatus = "result_status"
        case resultCode = "result_code"
        case resultMessage = "result_message"
        case tranRequestDate
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
