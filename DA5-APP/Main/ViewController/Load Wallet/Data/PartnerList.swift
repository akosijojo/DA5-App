//
//  PartnerList.swift
//  DA5-APP
//
//  Created by Jojo on 2/3/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit


struct PartnerList: Codable {
    let data: [PartnerListItem]
}

// MARK: - Datum
struct PartnerListItem: Codable {
    let id: Int
    let name, code: String
    let isActive: Int
    let image: String
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, code
        case isActive = "is_active"
        case image
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

