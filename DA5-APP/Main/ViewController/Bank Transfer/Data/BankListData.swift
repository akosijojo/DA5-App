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

//MARK: - LOCAL DATA
struct BankLocalData: Codable {
    static let shared = BankLocalData()
    var data : [BankAccountLocalData]?
    mutating func saveToLocal() {
        let key = AppConfig().bankAccountLocalKey
        let defaults = UserDefaults.standard
        if let savedData = defaults.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let banks = try? decoder.decode(BankLocalData.self, from: savedData) {
                if banks.data?.count ?? 0 > 0 {
                    var banksLocal : BankLocalData = banks
                    for xx in self.data ?? [] {
                        var error : Bool = false
                        for x in banks.data ?? [] {
                            if x.accountName == xx.accountName && x.accountNumber == xx.accountNumber {
                                error = true
                                return
                            }
                        }
                        if !error{
                            if xx.accountNumber != "" {
                                banksLocal.data?.insert(xx, at: 0)
                            }
                        }
                    }
                    self = banksLocal
                }
                
            }
        }
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self) {
            defaults.set(encoded, forKey: key)
        }
    }
    
    func getLocal() -> BankLocalData? {
        print("DATA GETTING")
       let defaults = UserDefaults.standard
       if let savedData = defaults.object(forKey: AppConfig().bankAccountLocalKey) as? Data {
           let decoder = JSONDecoder()
           if let data = try? decoder.decode(BankLocalData.self, from: savedData) {
            print("BANKS LOCAL \(data)")
              return data
           }
       }
       return nil
    }
}

struct BankAccountLocalData: Codable {
    var accountNumber : String?
    var accountName : String?
    var code, bank, brstn: String?
}
