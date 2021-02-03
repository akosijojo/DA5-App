//
//  PendingTransactionsData.swift
//  DA5-APP
//
//  Created by Jojo on 11/25/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

//struct PendingTransactionsData:Decodable {
//    let id : Int
//    let title : String
//    let image : String
//    let amount : String
//    let date : String
//    
//    init(id: Int, title: String, image: String, amount: String, date: String) {
//        self.id = id
//        self.title = title
//        self.image = image
//        self.amount = amount
//        self.date = date
//    }
//}

// MARK: - PendingTransaction
struct PendingTransactionsData: Decodable {
    var id : Int?
    var customerID: Int?
    var referenceNo: String?
    var status, type: Int?
    var createdAt, updatedAt: String?
    var cashInOut: CashInOut?
    var eload : Eload?
    var walletTransfer : WalletTransfer?
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
        case walletTransfer = "wallet_transfer"
        case fx, instapay
    }
    
    func convertToHistory() -> TransactionHistoryData {
        return TransactionHistoryData(id: self.id, customerID: self.customerID, referenceNo: self.referenceNo, status: 2, type: self.type, createdAt: self.createdAt, updatedAt: self.updatedAt, cashInOut: self.cashInOut, eload: self.eload, walletTransfer: self.walletTransfer, fx: self.fx,instapay: self.instapay)
    }
}

// MARK: - CashInOut
struct CashInOut: Decodable {
    var id, customerID: Int?
    var referenceNo: String?
    var partnerID: Int?
    var amount: String?
    var type, status: Int?
    var transactionDate: String?
    var approvedAt, declinedAt, expiredAt: String?
    var customerReferenceNo, customerName, customerPhone, partnerName: String?
    var partnerImage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
        case referenceNo = "reference_no"
        case partnerID = "partner_id"
        case amount, type, status
        case transactionDate = "transaction_date"
        case approvedAt = "approved_at"
        case declinedAt = "declined_at"
        case expiredAt = "expired_at"
        case customerReferenceNo = "customer_reference_no"
        case customerName = "customer_name"
        case customerPhone = "customer_phone"
        case partnerName = "partner_name"
        case partnerImage = "partner_image"
    }
    
}

