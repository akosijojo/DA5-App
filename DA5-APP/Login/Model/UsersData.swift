//
//  UsersData.swift
//  DA5-APP
//
//  Created by Jojo on 8/27/20.
//  Copyright © 2020 OA. All rights reserved.
//
// MARK: - Users
import UIKit

struct UsersData: Codable {
    var fname : String = ""
    var mname : String = ""
    var lname : String = ""
    var bdate : String = ""
    var gender : String = ""
    var nationality : String = ""
    var address : String = ""
    var mobileNumber : String = ""
    var email : String = ""
}

// MARK: - Nationality
struct Nationality: Codable {
    let nationals: [String]
}
 

// MARK: - Welcome
struct LoginData: Codable {
    var accessToken, tokenType: String?
    var expiresIn: Int?
    var refreshToken: String?
    var customer: Customer?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case customer
    }
}

// MARK: - Customer
struct Customer: Codable {
    var id: Int?
    var firstName: String?
    var middleName: String?
    var lastName, birthDate, mpin, gender: String?
    var image, address, city, province: String?
    var zipCode, nationality: String?
    var facebookID, appleID: String?
    var phone, email, idPicture, idPicture2: String?
    var phoneVerifiedAt: String?
    var emailVerifiedAt: String?
    var referenceNo: String?
    var kycStatus: Int?
    var kycNotice, kycUpdatedAt: String?
    var platform: Int?
    var createdAt, updatedAt, idPictureThumbnail1: String?
    var idPictureThumbnail2: String?

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
