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
    var onSuccessRegistrationData: ((LoginData?) -> Void)?
    var onErrorFbLoginData: ((LoginFb?) -> Void)?
    var onSuccessGettingList : ((Customer?) -> Void)?
    var returnNationalityList : ((Nationality?) -> Void)?
    var onSuccessGenerateToken : ((APIToken?) -> Void)?
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
                    if let dataRecieved = data, dataRecieved.customer != nil {
                        print("DATA GET LOGIN : \(dataRecieved)")
                        self.onSuccessGettingList?(dataRecieved.customer)
                        return
                    }else {
                         print("NO DATA")
                        self.onErrorHandling?(StatusList(status: 0, title: "", message: status?.message ?? "", tag: 0))
                         return
                    }
                }else {
                   self.onErrorHandling?(status)
                   return
                }
            }
    
            dataModel.login(param: param, completionHandler: completionHandler)
        }
    }
    
    func loginByFb(id: String?) {
         guard let dataModel = model else { return }
                
         let completionHandler = { (data : LoginFb?,status: StatusList?) in
            
            if let dataReceived = data {
                print("DATA RECIEVED : \(dataReceived.status)")
                if data?.status == 2 {
                    self.onErrorFbLoginData?(dataReceived)
                }else {
                    self.onSuccessGettingList?(dataReceived.customer)
                }
                print("DATA RECIEVED")
                return
            }
            
            self.onErrorHandling?(status)
         }
        
        let param : [String:String] = [
            "facebook_id" : id ?? "",
        ]
        dataModel.loginByFb(param: param, completionHandler: completionHandler)
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
        dataModel.getNationality(param: [:], completionHandler: completionHandler)
    }
    
    func createAccount() {
         guard let dataModel = model else { return }
                
         let completionHandler = { (data : LoginData?,status: StatusList?) in
            
            if let dataReceived = data {
                print("REGISTRATION DATA : ", dataReceived)
                if data?.customer != nil {
                    self.onSuccessRegistrationData?(dataReceived)
                }else {
                    self.onErrorHandling?(status)
                }
                return
            }
            
            self.onErrorHandling?(status)
         }
        
        var param : [String:Any] = [
         "first_name"        : registrationForm?.fname ?? "",
         "middle_name"       : registrationForm?.mname ?? "",
         "last_name"         : registrationForm?.lname ?? "",
         "birth_date"        : registrationForm?.bdate ?? "",
         "password"          : registrationForm?.password ?? "",
         "gender"            : registrationForm?.gender ?? "",
         "address"           : registrationForm?.address ?? "",
         "city"              : registrationForm?.city ?? "",
         "province"          : registrationForm?.province ?? "",
         "zip_code"          : registrationForm?.zipcode ?? "",
         "nationality"       : registrationForm?.nationality ?? "",
         "phone"             : registrationForm?.phoneNumber ?? "",
         "email"             : registrationForm?.email ?? "",
         "id_picture"        : registrationForm?.validId ?? "",
         "id_picture2"       : registrationForm?.selfieId ?? "",
         "code"              : registrationForm?.code ?? "",
         "platform"          : 1,
        ]
        
        if let fbId = registrationForm?.fbId , fbId != ""{
            param["facebook_id"] = fbId
        }
    
        dataModel.createAccount(param: param, completionHandler: completionHandler)
    }
    
    func uploadFile(image: UIImage?,type: Int) {
         guard let dataModel = model else { return }
                
        let completionHandler = { (data : ImageUploadData?,status: StatusList?) in
            
            if let dataReceived = data {
                print("DATA UPLOADED ", dataReceived)
                if type == 0 {
                    self.registrationForm?.validId = dataReceived.imagePath
                    self.onSuccessRequest?(StatusList(status: 1, title: status?.title ?? "", message: status?.message ?? "", tag: 10))
                }else if type == 1 {
                    self.registrationForm?.selfieId = dataReceived.imagePath
                    self.onSuccessRequest?(StatusList(status: 1, title: status?.title ?? "", message: status?.message ?? "", tag: 11))
                }
                
                return
            }
            
            self.onErrorHandling?(status)
         }
        
        var param : [String:String] = [:]
        
        let media = [Media(withImage: image!, forKey: "file")!]
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        dataModel.uploadImage(image: media, param: nil, session: session,completionHandler: completionHandler)
    }
    
    func getOtp(number: String? = nil, email: String? = nil, isResend: Int,type: Int? = nil, customerId: Int? = nil) {
         guard let dataModel = model else { return }
                
        let completionHandler = { (status : StatusList) in
            if status.status == 1 {
                self.onSuccessRequest?(status)
            } else if let _ = type , status.tag != nil {
                self.onSuccessRequest?(status)
            } else {
                self.onErrorHandling?(status)
            }
         }
        
        var param : [String:String] = [
            "is_resend" : String(describing: isResend)
        ]
        
        if let num = number {
            param["phone"] = num
        }
        
        if let mail = email {
            param["email"] = mail
        }
        if let otpType = type {
            param["type"] =  String(describing: otpType)
        }
        
        if let cId = customerId {
            param["customer_id"] =  String(describing: cId)
        }
    
        dataModel.getOtp(param: param, completionHandler: completionHandler)
    }
    
    func generateAPIToken() {
       guard let dataModel = model else { return }
              
        let completionHandler = { (data: APIToken?,status : StatusList?) in
            if let result = data {
                self.onSuccessGenerateToken?(result)
            }else {
                self.onErrorHandling?(status)
            }
       }
      
       let param : [String:String] = [
        "username"     : ApiConfig().apiUsername,
        "password"     : ApiConfig().apiPassword
       ]
   
       dataModel.generateAPIToken(param: param, completionHandler: completionHandler)
    }
    
    func saveMpin(MPIN: String,customerId: String,token: String) {
        guard let dataModel = model else { return }
               
        let completionHandler = { (data : LoginData?,status: StatusList?) in
           if let dataRecieved = data, dataRecieved.customer != nil {
                self.onSuccessGettingList?(dataRecieved.customer)
           }else {
               self.onErrorHandling?(status)
           }
        }
       
       let param : [String:String] = [
           "mpin"     : MPIN,
           "customer_id" : customerId
       ]
   
        dataModel.saveMpin(param: param,token: token, completionHandler: completionHandler)
    }
    
    func checkMpinOtp(code: Int,phone: String?, email: String?,token: String?,type: Int? = nil) {
        print("CHECKING ")
       guard let dataModel = model else { return }
             
       let completionHandler = { (status : StatusList) in
        
        print("STATUS : \(status)")
        //MARK: - 2 if phone to email / 3 if email to pin code
          if status.status == 1 {
            if let _ = phone {
                self.onSuccessRequest?(StatusList(status: status.status, title: status.title, message: status.message, tag: 2))
            }else if let _ = email {
                self.onSuccessRequest?(StatusList(status: status.status, title: status.title, message: status.message, tag: 3))
            }else {
                print("NOT AVAILABLE CHECK TYPE")
                self.onSuccessRequest?(status)
            }
          }else {
             self.onErrorHandling?(status)
          }
       }
        
       var param : [String:Any] = [
          "code"     : code
       ]
        
        if let number = phone {
            param["phone"] = number
        }
        
        if let mail = email {
            param["email"] = mail
        }
        
        dataModel.checkMpin(param: param, token: token,completionHandler: completionHandler)
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
