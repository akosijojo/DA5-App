//
//  PaybillsData.swift
//  DA5-APP
//
//  Created by Jojo on 1/28/21.
//  Copyright © 2021 OA. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct PaybillsData: Decodable {
    let billers: [BillerData]
}

// MARK: - Biller
struct BillerData: Decodable {
    let name, code, type, fee: String
    let logo: String?
    let category: CategoryData
    let meta: [MetaData]
}

enum CategoryData: String, Decodable {
    case airlines = "AIRLINES"
    case cable = "CABLE"
    case electricity = "ELECTRICITY"
    case government = "GOVERNMENT"
    case insurance = "INSURANCE"
    case mobileLoad = "MOBILE LOAD"
    case onlineShopping = "ONLINE SHOPPING"
    case others = "OTHERS"
    case realEstate = "REAL ESTATE"
    case sssContribution = "SSS CONTRIBUTION"
    case telecom = "TELECOM"
    case utilities = "UTILITIES"
    case water = "WATER"
}

// MARK: - Meta
struct MetaData: Decodable {
    let label, field: String?
    let type: TypeEnum?
    let isRequired: IsRequired?
    let options: [Option]?
    let maxLength: Int?
    let hidden: HiddenData?
    let format: String?
    let value: Int?
    let isReadonly: Bool?

    enum CodingKeys: String, CodingKey {
        case label, field, type
        case isRequired = "is_required"
        case options
        case maxLength = "max_length"
        case hidden, format, value
        case isReadonly = "is_readonly"
    }
}

// MARK: - Hidden
struct HiddenData: Codable {
    let type: TypeClass
}

// MARK: - TypeClass
struct TypeClass: Codable {
    let service2, misc: [String]?

    enum CodingKeys: String, CodingKey {
        case service2 = "Service2"
        case misc = "Misc"
    }
}

enum IsRequired: Codable {
    case bool(Bool)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Bool.self) {
            self = .bool(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(IsRequired.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for IsRequired"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bool(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - Option
struct Option: Codable {
    let key: String
    let value: Value?
    let valueLAO, valueSAN, valueSAO, overrideField: String?
    let overrideValue: Int?

    enum CodingKeys: String, CodingKey {
        case key, value, valueLAO, valueSAN, valueSAO
        case overrideField = "override_field"
        case overrideValue = "override_value"
    }
}

enum Value: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Value.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Value"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

enum TypeEnum: String, Codable {
    case calendar = "Calendar"
    case dropdown = "Dropdown"
    case mobilenumber = "mobilenumber"
    case month = "Month"
    case number = "Number"
    case text = "Text"
    case year = "Year"
}
