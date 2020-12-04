//
//  LoginViewModel.swift
//  DA5-APP
//
//  Created by Jojo on 11/27/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

class LoginViewModel : NSObject {
    var model : LoginModel?
    var onSuccessGettingList : ((Customer?) -> Void)?
    var returnNationalityList : ((Nationality?) -> Void)?
    var onSuccessRequest : ((StatusList?) -> Void)?
    var onErrorHandling : ((StatusList?) -> Void)?
    var uploadProgress : ((Float) -> Void)?
    var registrationForm : RegistrationForm?
    
    func login(param: [String:Any],fb: Bool = false) {
        
        guard let dataModel = model else { return }
        
        var error : StatusList?
        
        if param["username"] as? String == "" || param["password"] as? String == "" {
          self.onErrorHandling?(StatusList(status: 0, title: "", message: "Please enter your login credentials", tag: 0))
            return
        }else {
            let completionHandler = { (data : LoginData?,status: StatusList?) in
                
                if status == nil {
                    print("DATA : \(data)")
                    if let dataReceived = data, dataReceived.customer != nil {
                        print("DATA GET LOGIN : \(dataReceived)")
                        self.onSuccessGettingList?(dataReceived.customer)
                        return
                    }else {
                         print("NO DAT")
                         self.onErrorHandling?(StatusList(status: 0, title: "", message: "Incorrect email/phone or password", tag: 0))
                         return
                    }
                }else {
                   self.onErrorHandling?(status)
                   return
                }
            }
            
//        if fb {
//            dataModel.loginFb(param: param, completionHandler: completionHandler)
//        }else {
            dataModel.login(param: param, completionHandler: completionHandler)
//        }
        }
        
        
      
    }
    
    func getNationality() {
         guard let dataModel = model else { return }
                
         let completionHandler = { (data : Nationality?,status: StatusList?) in
            
            if let dataReceived = data {
                self.returnNationalityList?(dataReceived)
                return
            }
            
            self.onErrorHandling?(status)
         }
        
//        if fb {
//            dataModel.loginFb(param: param, completionHandler: completionHandler)
//        }else {
        dataModel.getNationality(param: [:], completionHandler: completionHandler)
    }
    
    func uploadFile() {
         guard let dataModel = model else { return }
                
        let completionHandler = { (data : ImageUploadData?,status: StatusList?) in
            
            if let dataReceived = data {
                print("DATA UPLOADED ", dataReceived)
//                self.returnNationalityList?(dataReceived)
                return
            }
            
            self.onErrorHandling?(status)
         }
        
        var param : [String:String] = [:]
        
        var media = [Media(withImage: UIImage(named: "user")!, forKey: "file")!]
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        dataModel.uploadImage(image: media, param: nil, session: session,completionHandler: completionHandler)
    }
    
    func getOtp(number: String, email: String, isResend: Int) {
         guard let dataModel = model else { return }
                
        let completionHandler = { (status : StatusList) in
            if status.status == 1{
                self.onSuccessRequest?(status)
            }else {
                self.onErrorHandling?(status)
            }
         }
        
        let param : [String:String] = [
            "phone"     : number,
            "email"     : email,
            "is_resend" : String(describing: isResend)
        ]
    
        dataModel.getOtp(param: param, completionHandler: completionHandler)
    }
}

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
    var validId : Media?
    var selfieId : Media?
    
    mutating func setUpIdentification(form: RegistrationForm?) {
        self.phoneNumber = form?.phoneNumber
        self.email = form?.email
        self.password = form?.password
        self.validId = form?.validId
        self.selfieId = form?.selfieId
        print("SET IDENTIFICATION")
    }
    
    func showValues() {
        print("First Name: ",fname)
        print("MIDDLE NAME: ",mname)
        print("LAST NAME: ",lname)
        print("BDATE: ",bdate)
        print("GENDER: ",gender)
        print("NATION: ",nationality)
        print("ADDRESS: ",address)
        print("CITY: ",city)
        print("PROVINCE: ",province)
        print("ZIPCODE: ",zipcode)
        print("PHONE: ",phoneNumber)
        print("EMAIL: ",email)
        print("PASSWORD ",password)
//        print("DATA VALUES : \n",fname+" \n"+mname+" \n"+lname+" \n"+bdate+" \n"+gender)
//        print("\n"+nationality+" \n"+address+" \n"+city+" \n"+province+" \n"+zipcode)
//        print("\n"+phoneNumber+" \n"+email+" \n"+password+" \n"+validId+" \n"+selfieId+" \n")
    }
}


extension LoginViewModel : URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64)
    {
        let uploadProgress:Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        print("Progress : \(uploadProgress)")
        self.uploadProgress?(uploadProgress)
    }
}
