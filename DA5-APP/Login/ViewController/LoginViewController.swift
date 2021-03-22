//
//  LoginViewController.swift
//  DA5-APP
//
//  Created by Jojo on 8/18/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import AuthenticationServices

class LoginViewController: BaseViewControler {

    var customerData : Customer? {
        didSet{
            
        }
    }
    
    var viewModel : LoginViewModel?
    
    lazy var scrollView : UIScrollView = {
       let v = UIScrollView()
       return v
    }()
    
    lazy var logoImg : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "app_logo")
        return img
    }()
    
    lazy var lblEmail : UILabel = {
        let lbl = UILabel()
        lbl.text = "Email or Phone Number"
        lbl.font = UIFont(name: Fonts.medium, size: 14)
        return lbl
    }()
    
    lazy var unameTextfield : CustomTextField = {
        let txt = CustomTextField()
        txt.placeholder = "Email or Phone Number"
        txt.font = UIFont(name: Fonts.regular, size: 12)
        txt.backgroundColor = ColorConfig().innerbgColor
        txt.layer.cornerRadius = 5
        return txt
    }()
    
    lazy var lblPassword : UILabel = {
        let lbl = UILabel()
        lbl.text = "Password"
        lbl.font = UIFont(name: Fonts.medium, size: 14)
        return lbl
    }()
   
    lazy var passTextfield : CustomTextField = {
        let txt = CustomTextField()
        txt.placeholder = "Password"
        txt.font = UIFont(name: Fonts.regular, size: 12)
        txt.backgroundColor = ColorConfig().innerbgColor
        txt.layer.cornerRadius = 5
        txt.isSecureTextEntry = true
        return txt
    }()
    
    lazy var loginBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("Login", for: .normal)
        btn.backgroundColor = ColorConfig().darkBlue
        btn.layer.cornerRadius = 5
        btn.titleLabel?.font = UIFont(name: Fonts.regular, size: 12)
        btn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var signupBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("Sign Up", for: .normal)
        btn.backgroundColor = ColorConfig().lightBlue
        btn.layer.cornerRadius = 5
        btn.titleLabel?.font = UIFont(name: Fonts.regular, size: 12)
        btn.addTarget(self, action: #selector(signupAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var appleButton : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "applelogo")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = ColorConfig().white
        btn.setTitle("Sign in with Apple", for: .normal)
        btn.setTitleColor(ColorConfig().white, for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = ColorConfig().darkBlue?.cgColor
        btn.layer.cornerRadius = 5
        btn.backgroundColor = ColorConfig().black
        btn.titleLabel?.font = UIFont(name: Fonts.regular, size: 12)
        btn.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        return btn
    }()
    
    lazy var fbButton : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "fb_logo")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = ColorConfig().white
        btn.setTitle("Facebook", for: .normal)
        btn.setTitleColor(ColorConfig().white, for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = ColorConfig().darkBlue?.cgColor
        btn.layer.cornerRadius = 5
        btn.backgroundColor = ColorConfig().blue
        btn.titleLabel?.font = UIFont(name: Fonts.regular, size: 12)
        btn.addTarget(self, action: #selector(loginOnFbAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var lblForgot : UILabel = {
        let lbl = UILabel()
        lbl.text = "Forgot Password?"
        lbl.textColor = ColorConfig().lightGray
        lbl.font = UIFont(name: Fonts.regular, size: 14)
        lbl.textAlignment = .center
        return lbl
    }()
       
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        hidesKeyboardOnTapArround()
        navigationController?.navigationBar.isHidden = true
        setUpView()

        if let token = AccessToken.current,
             !token.isExpired {
//            fbButton.setTitle("Log out", for: .normal)
            AccessToken.current = nil
            
         }
        
        //keyboard handling
        unameTextfield.delegate = self
        passTextfield.delegate = self
        getData()
        
    }
    
    override func getData() {
        self.viewModel?.onErrorFbLoginData = { [weak self] data in
            DispatchQueue.main.async {
                self?.coordinator?.signUpCoordinator(UserData: self?.viewModel?.registrationForm)
                self?.stopAnimating()
            }
        }
             
        self.viewModel?.onErrorAppleLoginData = { [weak self] data in
            DispatchQueue.main.async {
                self?.coordinator?.signUpCoordinator(UserData: self?.viewModel?.registrationForm)
                self?.stopAnimating()
            }
        }
        
        self.viewModel?.onSuccessGettingList = { [weak self] data, rtoken in
            DispatchQueue.main.async {
                
                self?.customerData = data
                // saving of users in local to check if logged in or not then goto pincode
                self?.coordinator?.pinCodeCoordinator(customerData: data,refreshToken: rtoken)
                self?.stopAnimating()
            }
        }
       
        self.viewModel?.onErrorHandling = { [weak self] error in
            DispatchQueue.main.async {
                self?.showAlert(buttonOK: "Ok", message: error?.message ?? "", actionOk: nil, completionHandler: nil)
                self?.stopAnimating()
            }
        }
    }

    override func setUpView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(view)
        }
        
        scrollView.addSubview(logoImg)
        logoImg.snp.makeConstraints { (make) in
            make.width.equalTo(150)
            make.height.equalTo(80)
            make.centerX.equalTo(view)
            make.centerY.equalTo(scrollView).offset(-220)
        }
        scrollView.addSubview(lblEmail)
        lblEmail.snp.makeConstraints { (make) in
            make.top.equalTo(logoImg.snp.bottom).offset(40)
            make.height.equalTo(40)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
        }
        scrollView.addSubview(unameTextfield)
        unameTextfield.snp.makeConstraints { (make) in
            make.top.equalTo(lblEmail.snp.bottom)
            make.height.equalTo(40)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
        }
        scrollView.addSubview(lblPassword)
        lblPassword.snp.makeConstraints { (make) in
            make.top.equalTo(unameTextfield.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
        }
        scrollView.addSubview(passTextfield)
        passTextfield.snp.makeConstraints { (make) in
            make.top.equalTo(lblPassword.snp.bottom)
            make.height.equalTo(40)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
        }
        scrollView.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(passTextfield.snp.bottom).offset(20)
            make.height.equalTo(40)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
        }
        
        if #available(iOS 13.0, *) {
//            setUpSignInAppleButton()
            scrollView.addSubview(appleButton)
            appleButton.snp.makeConstraints { (make) in
                make.top.equalTo(loginBtn.snp.bottom).offset(10)
                make.height.equalTo(40)
                make.leading.equalTo(view).offset(20)
                make.trailing.equalTo(view).offset(-20)
            }
            
            scrollView.addSubview(fbButton)
            fbButton.snp.makeConstraints { (make) in
               make.top.equalTo(appleButton.snp.bottom).offset(10)
               make.height.equalTo(40)
               make.leading.equalTo(view).offset(20)
               make.trailing.equalTo(view).offset(-20)
            }
            
        }else {
            scrollView.addSubview(fbButton)
            fbButton.snp.makeConstraints { (make) in
               make.top.equalTo(loginBtn.snp.bottom).offset(10)
               make.height.equalTo(40)
               make.leading.equalTo(view).offset(20)
               make.trailing.equalTo(view).offset(-20)
            }
        }
        
        scrollView.addSubview(signupBtn)
        signupBtn.snp.makeConstraints { (make) in
            make.top.equalTo(fbButton.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
        }
        
        scrollView.addSubview(lblForgot)
        lblForgot.snp.makeConstraints { (make) in
            make.top.equalTo(signupBtn.snp.bottom).offset(40)
            make.height.equalTo(20)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.bottom.equalTo(scrollView).offset(-20)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showForgotView))
        lblForgot.isUserInteractionEnabled = true
        lblForgot.addGestureRecognizer(tap)
    }
 
    deinit {
        print("deinit : \(self)")
    }
    
    
    @objc func loginAction() {
        DispatchQueue.main.async {
            self.view.endEditing(true)
            if let username = self.unameTextfield.text , let password = self.passTextfield.text{
                self.setAnimate(msg: "Please wait")
                self.viewModel?.login(param: ["unique": username, "password" : password ])
            }
        }
//        coordinator?.homeCoordinator(setAsRoot: true)
    }
    @objc func signupAction() {
        coordinator?.signUpCoordinator()
    }
    @objc func loginOnFbAction() {
        // 1
         let loginManager = LoginManager()
         
         if let _ = AccessToken.current {
             loginManager.logOut()
         } else {
             loginManager.logIn(permissions: ["public_profile", "email"], from: self) { [weak self] (result, error) in
                 guard error == nil else {
                     // Error occurred
                     print(error!.localizedDescription)
                     return
                 }
                 guard let result = result, !result.isCancelled else {
                     print("User cancelled login")
                     return
                 }
                let fbloginresult : LoginManagerLoginResult = result
               
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self?.getFbData()
                }
             }
         }
   }
   
   func getFbData() {
        if AccessToken.current != nil {
           GraphRequest(graphPath: "me", parameters: ["fields" : "id, name, first_name,last_name,picture.type(large),email"]).start { (connection, result, err) in
               if (err == nil) {
                   let faceDic = result as! [String:AnyObject]
                   if let email = faceDic["email"] as? String ,let firstName = faceDic["first_name"] as? String, let lastName = faceDic["last_name"] as? String , let fid = faceDic["id"] as? String {
                    self.setAnimate(msg: "Please wait")
                    self.viewModel?.loginByFb(id: fid)
                    let regForm = RegistrationForm(fname: firstName,  lname:
                        lastName, email: email, fbId: fid)
                    self.viewModel?.registrationForm = regForm
                   }
               }
           }
        }
   }
    
   @objc func showForgotView() {
        self.coordinator?.showForgotViewController()
   }
    
}


extension LoginViewController : ASAuthorizationControllerDelegate {
    @objc func handleAppleIdRequest() {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email ]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
        let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
        let email = appleIDCredential.email
            
        self.setAnimate(msg: "Please wait")
        self.viewModel?.loginByApple(id: userIdentifier)
        let regForm = RegistrationForm(fname: fullName?.givenName,  lname:
            fullName?.familyName, email: email, appleId: userIdentifier)
        self.viewModel?.registrationForm = regForm
    }
  }
        
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("CALLING THIS ERROR : \(error)")
    // Handle error.
    }
        
}
