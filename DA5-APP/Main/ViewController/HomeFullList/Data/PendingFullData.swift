//
//  PendingFullData.swift
//  DA5-APP
//
//  Created by Jojo on 1/25/21.
//  Copyright © 2021 OA. All rights reserved.
//

import Foundation

struct PendinguFullData: Decodable {
    let data : [PendingTransactionsData]?
}

struct TransactHistoryFullData: Decodable {
    let data : [TransactionHistoryData]?
}
