//
//  UsersData.swift
//  DA5-APP
//
//  Created by Jojo on 8/27/20.
//  Copyright © 2020 OA. All rights reserved.
//
// MARK: - Users
import UIKit

//MARK: -REGISTRATION FORM
struct RegistrationForm {
    var fname : String?
    var mname : String?
    var lname : String?
    var bdate : String?
    var gender : String?
    var nationality : String?
    var address : String?
    var city : String?
    var province : String?
    var zipcode : String?
    var phoneNumber : String?
    var email : String?
    var password : String?
    var validId : String?
    var selfieId : String?
    var code : String?
    var fbId : String?
    var appleId : String?
//     'first_name'        => $request->first_name,
//     'middle_name'       => $request->middle_name,
//     'last_name'         => $request->last_name,
//     'birth_date'        => $request->birth_date,
//     'password'          => Hash::make($request->password),
//     'gender'            => $request->gender,
//     'address'           => $request->address,
//     'city'              => $request->city,
//     'province'          => $request->province,
//     'zip_code'          => $request->zip_code,
//     'nationality'       => $request->nationality,
//     'facebook_id'       => $request->facebook_id,
//     'apple_id'          => $request->apple_id,
//     'phone'             => $request->phone,
//     'email'             => $request->email,
//     'id_picture'        => $request->id_picture,
//     'id_picture2'       => $request->id_picture2,
//     'platform'          => $request->platform

    mutating func setUpIdentification(form: RegistrationForm?) {
        self.phoneNumber = form?.phoneNumber
        self.email = form?.email
        self.password = form?.password
        print("SET IDENTIFICATION")
    }
    
    func showValues() {
        print("First Name: ",fname ?? "")
        print("MIDDLE NAME: ",mname ?? "")
        print("LAST NAME: ",lname ?? "")
        print("BDATE: ",bdate ?? "")
        print("GENDER: ",gender ?? "")
        print("NATION: ",nationality ?? "")
        print("ADDRESS: ",address ?? "")
        print("CITY: ",city ?? "")
        print("PROVINCE: ",province ?? "")
        print("ZIPCODE: ",zipcode ?? "")
        print("PHONE: ",phoneNumber ?? "")
        print("EMAIL: ",email ?? "")
        print("PASSWORD ",password ?? "")
        print("VALID ID URL ",validId ?? "")
        print("SELFIE ID URL ",selfieId ?? "")
        print("CODE ",code ?? "")
        print("FBID ",fbId ?? "")
        print("APPLE ",appleId ?? "")
    }
}

struct UsersData: Decodable {
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
struct Nationality: Decodable {
    let nationals: [String]
}
 

// MARK: - Welcome
struct LoginData: Decodable {
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

struct RefreshTokenLocal: Codable {
    var refreshToken : String?
    
     func saveRefreshTokenLocal() {
       let encoder = JSONEncoder()
       if let encoded = try? encoder.encode(self) {
            print("Saving REFRESH TOKEN to local")
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: AppConfig().refreshTokenLocalKey)
       }
    }

    func getRefreshTokenLocal() -> RefreshTokenLocal? {
       let defaults = UserDefaults.standard
       if let saveToken = defaults.object(forKey: AppConfig().refreshTokenLocalKey) as? Data {
           let decoder = JSONDecoder()
           if let customerData = try? decoder.decode(RefreshTokenLocal.self, from: saveToken) {
              print("Get Token from local")
              return customerData
           }
       }
       return nil
    }
    
    func checkIfExistingData() -> Bool {
        if UserDefaults.standard.object(forKey: AppConfig().refreshTokenLocalKey) != nil {
            return true
        }
        return false
    }
}

// MARK: - Customer
struct Customer: Decodable {
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
    
    func convertToLocalData() -> CustomerLocal {
        return CustomerLocal(id: id, firstName: firstName, middleName: middleName, lastName: lastName, birthDate: birthDate, mpin: mpin, gender: gender, image: image, address: address, city: city, province: province, zipCode: zipCode, nationality: nationality, facebookID: facebookID, appleID: appleID, phone: phone, email: email, idPicture: idPicture, idPicture2: idPicture2, phoneVerifiedAt: phoneVerifiedAt, emailVerifiedAt: emailVerifiedAt, referenceNo: referenceNo, kycStatus: kycStatus, kycNotice: kycNotice, kycUpdatedAt: kycUpdatedAt, platform: platform, createdAt: createdAt, updatedAt: updatedAt, idPictureThumbnail1: idPictureThumbnail1, idPictureThumbnail2: idPictureThumbnail2)
    }
}

struct CustomerLocal: Codable {
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
    
    func saveCustomerToLocal() {
       let encoder = JSONEncoder()
       if let encoded = try? encoder.encode(self) {
            print("Saving Customer to local")
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: AppConfig().customerLocalKey)
       }
    }

    func getCustomerFromLocal() -> CustomerLocal? {
       let defaults = UserDefaults.standard
       if let savedCustomer = defaults.object(forKey: AppConfig().customerLocalKey) as? Data {
           let decoder = JSONDecoder()
           if let customerData = try? decoder.decode(CustomerLocal.self, from: savedCustomer) {
              print("Get Customer from local")
//              print(customerData)
              return customerData
           }
       }
       return nil
    }
    
    func checkIfExistingData() -> Bool {
        if UserDefaults.standard.object(forKey: AppConfig().customerLocalKey) != nil {
            return true
        }
        return false
    }
    
    func convertData() -> Customer {
        return Customer(id: id, firstName: firstName, middleName: middleName, lastName: lastName, birthDate: birthDate, mpin: mpin, gender: gender, image: image, address: address, city: city, province: province, zipCode: zipCode, nationality: nationality, facebookID: facebookID, appleID: appleID, phone: phone, email: email, idPicture: idPicture, idPicture2: idPicture2, phoneVerifiedAt: phoneVerifiedAt, emailVerifiedAt: emailVerifiedAt, referenceNo: referenceNo, kycStatus: kycStatus, kycNotice: kycNotice, kycUpdatedAt: kycUpdatedAt, platform: platform, createdAt: createdAt, updatedAt: updatedAt, idPictureThumbnail1: idPictureThumbnail1, idPictureThumbnail2: idPictureThumbnail2)
    }
}



class UserLoginData {
    static let shared = UserLoginData()
    var id: Int?
    var firstName: String?
    var middleName: String?
    var lastName, birthDate, mpin, gender: String?
    var image, address, city, province: String?
    var phoneNumber : String?
//    var zipCode, nationality: String?
//    var facebookID, appleID: String?
//    var phone, email, idPicture, idPicture2: String?
//    var phoneVerifiedAt: String?
//    var emailVerifiedAt: String?
//    var referenceNo: String?
//    var kycStatus: Int?
//    var kycNotice, kycUpdatedAt: String?
//    var platform: Int?
//    var createdAt, updatedAt, idPictureThumbnail1: String?
//    var idPictureThumbnail2: String?

    
    func setUpData(data: Customer) -> UserLoginData {
        var user = UserLoginData()
        user.id = data.id
        user.firstName = data.firstName
        user.middleName = data.middleName
        user.lastName = data.lastName
//        user.birthDate,
//        user.mpin,
//        user.gender: String?
        user.image = data.image
        user.phoneNumber = data.phone
//        , address, city, province: String?
//        var zipCode, nationality: String?
//        var facebookID, appleID: String?
//        var phone, email, idPicture, idPicture2: String?
//        var phoneVerifiedAt: String?
//        var emailVerifiedAt: String?
//        var referenceNo: String?
//        var kycStatus: Int?
//        var kycNotice, kycUpdatedAt: String?
//        var platform: Int?
//        var createdAt, updatedAt, idPictureThumbnail1: String?
//        var idPictureThumbnail2: String?
    
        return user
    }
}

// MARK: - FB DATA NOT REGISTERED
struct LoginFb: Decodable {
    var status: Int?
    var message: String?
    var nationals: [String]?

    var accessToken, tokenType: String?
    var expiresIn: Int?
    var refreshToken: String?
    var customer: Customer?

    enum CodingKeys: String, CodingKey {
      //MARK: Not Registered 
       case status = "status"
       case message = "message"
       case nationals = "nationals"
        //MARK: Already Registered
       case accessToken = "access_token"
       case tokenType = "token_type"
       case expiresIn = "expires_in"
       case refreshToken = "refresh_token"
       case customer
    }
}


// MARK: - APPLE LOGIN DATA
struct LoginApple: Decodable {
    var status: Int?
    var message: String?
    
    var accessToken, tokenType: String?
    var expiresIn: Int?
    var refreshToken: String?
    var customer: Customer?
//    var nationals: [String]?
//
//    var accessToken, tokenType: String?
//    var expiresIn: Int?
//    var refreshToken: String?
//    var customer: Customer?

//    enum CodingKeys: String, CodingKey {
//      //MARK: Not Registered
//       case status = "status"
//       case message = "message"
//       case nationals = "nationals"
//        //MARK: Already Registered
//       case accessToken = "access_token"
//       case tokenType = "token_type"
//       case expiresIn = "expires_in"
//       case refreshToken = "refresh_token"
//       case customer
//    }
}
