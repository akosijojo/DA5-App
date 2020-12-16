//
//  HomeData.swift
//  DA5-APP
//
//  Created by Jojo on 12/15/20.
//  Copyright © 2020 OA. All rights reserved.
//

import Foundation

// gawin ang HOME then yung mga services and edit profile / tas FB SA LOGIN check video taken sa phone

// MARK: - HOME
struct HomeData: Decodable {
    var customer: Customer?
    var balance: String?
    var pendingTransaction : [PendingTransactionsData]?
    var transactionHistory : [TransactionHistoryData]?
    var news: [NewsData]?

    enum CodingKeys: String, CodingKey {
        case customer, balance
        case pendingTransaction = "pending_transaction"
        case transactionHistory = "transaction_history"
        case news
    }
}
