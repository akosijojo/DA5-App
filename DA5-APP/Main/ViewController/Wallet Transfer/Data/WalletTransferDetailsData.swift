//
//  WalletTransferDetailsData.swift
//  DA5-APP
//
//  Created by Jojo on 1/30/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

struct WalletTransferDetailsData: Decodable {
    let data: WalletDetailsData
}

struct WalletDetailsData: Decodable {
    let id: Int
    let firstName: String
    let middleName: String?
    let lastName, birthDate, mpin, gender: String
    let image: String
    let address, city, province, zipCode: String
    let nationality, facebookID: String
    let appleID: String?
    let phone, email: String
    let idPicture, idPicture2: String
    let phoneVerifiedAt: String
    let emailVerifiedAt: String?
    let referenceNo: String
    let kycStatus: Int
    let kycNotice, kycUpdatedAt: String?
    let platform: Int
    let createdAt, updatedAt: String
    let idPictureThumbnail1, idPictureThumbnail2: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case middleName = "middle_name"
        case lastName = "last_name"
        case birthDate = "birth_date"
        case mpin, gender, image, address, city, province
        case zipCode = "zip_code"
        case nationality
        case facebookID = "facebook_id"
        case appleID = "apple_id"
        case phone, email
        case idPicture = "id_picture"
        case idPicture2 = "id_picture2"
        case phoneVerifiedAt = "phone_verified_at"
        case emailVerifiedAt = "email_verified_at"
        case referenceNo = "reference_no"
        case kycStatus = "kyc_status"
        case kycNotice = "kyc_notice"
        case kycUpdatedAt = "kyc_updated_at"
        case platform
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case idPictureThumbnail1 = "id_picture_thumbnail1"
        case idPictureThumbnail2 = "id_picture_thumbnail2"
    }
}
