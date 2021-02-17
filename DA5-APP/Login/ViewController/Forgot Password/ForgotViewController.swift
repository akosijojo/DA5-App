//
//  ForgotViewController.swift
//  DA5-APP
//
//  Created by Jojo on 2/10/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

class ForgotViewController: BaseViewControler {
    
    var tokenData : String? = ""
    
    var viewModel : LoginViewModel?
    
    var mobileNumber : String? = ""
    
    var pagerIndex : Int = 0
    
    lazy var pager : PagerView = {
       let v = PagerView()
       v.itemCount = 3
       v.itemColor = ColorConfig().lightBlue!
       v.itemIndex = 0
       return v
    }()
       
    lazy var collectionView : UICollectionView = {
       let layout = UICollectionViewFlowLayout()
       layout.minimumLineSpacing = 0
       layout.scrollDirection = .horizontal
       let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
       view.backgroundColor = ColorConfig().white
       view.isPagingEnabled = true
       view.bounces = false
       view.isScrollEnabled = false
       return view
    }()
       
    lazy var customProgressView : CustomProgressView = {
       let v = CustomProgressView()
       v.title.text = "Please wait"
       v.message.text = ""
       return v
    }()
    
    let form1 = "form1"
    let form2 = "form2"
    let form3 = "form3"
    
//    lazy var headerView : CustomHeaderView = {
//       let v = CustomHeaderView()
//       v.title.text = "Forgot password"
//       v.desc.text = "Enter your mobile number for the verification process we will send a 6 digit code to your phone."
//       v.desc.numberOfLines = 0
//       return v
//    }()
//    
//    lazy var phoneNumber: CustomBasicFormInputNumber = {
//        let v = CustomBasicFormInputNumber()
//        v.FieldView.TextField.keyboardType = .numberPad
//        v.FieldView.TextField.tag = 1
//        v.FieldView.TextField.delegate = self
//        v.FieldView.TextField.placeholder = "Phone number"
//        return v
//    }()
//
//    lazy var submitBtn : UIButton = {
//        let v = UIButton()
//         v.layer.cornerRadius = 5
//         v.backgroundColor = ColorConfig().black
//         v.setTitle("Proceed", for: .normal)
//         v.titleLabel?.font = UIFont(name: Fonts.medium, size: 12)
//         v.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
//        return v
//    }()
//      
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        self.hidesKeyboardOnTapArround()
        setUpView()
//        getData()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhoneNumberCell.self, forCellWithReuseIdentifier: form1)
        collectionView.register(VerifyCollectionViewCell.self, forCellWithReuseIdentifier: form2)
        collectionView.register(ChangePassFormCell.self, forCellWithReuseIdentifier: form3)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpNavigationBar()
    }
     
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.coordinator?.dismissViewController()
    }
    
    override func getData() {
        self.viewModel?.onSuccessGenerateToken = { [weak self] res in
           DispatchQueue.main.async {
              self?.tokenData = res?.accessToken
           }
        }
        
        self.viewModel?.onSuccessRequest = { [weak self] res in
            DispatchQueue.main.async {
                self?.stopAnimating()
                if res?.tag == 10 {
                    self?.showAlert(buttonOK: "Ok", message: res?.message ?? "Something went wrong", actionOk: { (action) in
                        self?.navigationController?.popViewController(animated: true)
                    }, completionHandler: nil)
                }else if res?.tag == 2 || res?.tag == 3 {
                    self?.gotoPage3()
                }else {
                    
                }
            }
        }

        self.viewModel?.onErrorHandling = { [weak self] error in
          DispatchQueue.main.async {
              self?.showAlert(buttonOK: "Ok", message: error?.message ?? "", actionOk: nil, completionHandler: nil)
              self?.stopAnimating()
          }
        }
        
        self.viewModel?.generateAPIToken()
    }
    
    override func setUpView() {
        view.addSubview(pager)
        pager.snp.makeConstraints { (make) in
           make.top.equalTo(view.layoutMarginsGuide.snp.top)
           make.leading.equalTo(view).offset(20)
           make.trailing.equalTo(view).offset(-20)
           make.height.equalTo(30)
        }
        
        pager.collectionView.reloadData()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
           make.top.equalTo(pager.snp.bottom).offset(10)
           make.leading.equalTo(view)
           make.trailing.equalTo(view)
           make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom).offset(0)
        }
    }
    
    
}

extension ForgotViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: form1, for: indexPath) as? PhoneNumberCell else {
                return UICollectionViewCell()
            }
            cell.vc = self
            cell.phoneNumber.FieldView.TextField.text = self.mobileNumber
            cell.delegate = self
            return cell
        }else if indexPath.item == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: form2, for: indexPath) as? VerifyCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            cell.data = self.mobileNumber
            return cell
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: form3, for: indexPath) as? ChangePassFormCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
    
    func showFormError(fields: [UITextField],image: [UIImage?]? = nil) -> Bool{
        if formChecker(fields: fields){
            let alert = self.alert("Ok", "", "Please fill out the following required fields to proceed.") { (act) in
                
            }
            self.present(alert, animated: true, completion: nil)

            return false
        }
        return true
    }
    
    func formChecker(fields: [UITextField]) -> Bool {
        for x in 0...fields.count - 1 {
            if (fields[x].text ?? "") == "" {
                return true
            }
        }
        return false
    }
    
    func beginAnimation(animate: Bool = true,title: String? = nil, msg: String? = nil) {
        if animate {
            customProgressView.runLoadingAnimation(vc: self,navBar: self.navigationController?.navigationBar, view: self.view,title: title,message: msg)
        }else {
             customProgressView.removeLoadingAnimation(vc: self, navBar: self.navigationController?.navigationBar)
        }
    }
    
    func stopAnimationBlocker() {
        self.stopAnimating()
    }
}


extension ForgotViewController: PhoneNumberCellDelegate, VerifyCollectionViewCellDelegate,ChangePassFormCellDelegate {
    func submitAction(cell: PhoneNumberCell, index: Int, fields: [UITextField]) {
        self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .right, animated: true)
        self.mobileNumber = fields[0].text
        self.pager.itemIndex = 1
        self.pager.collectionView.reloadData()
        self.pagerIndex = 1
        self.setAnimate(msg: "Please wait..")
        self.viewModel?.getOtp(number: self.mobileNumber ?? "", email: nil, isResend: 0, type: 3)
    }
    
    func submitAction(cell: VerifyCollectionViewCell, index: Int) {
        print("Submit")
        //lagay mo din sa signup 
        if cell.verificationCode.text == "" {
           self.showAlert(buttonOK: "Ok", message: "Verification code is required", actionOk: { (action) in
               // action
           }, completionHandler: nil)
        }else {
           guard let code = cell.verificationCode.text?.replacingOccurrences(of: " ", with: "") else { return }
            self.viewModel?.checkMpinOtp(code: Int(code) ?? 0, phone: self.mobileNumber,email: nil, token: self.tokenData , type: 3)
       }
    }
    
    func gotoPage3() {
          self.collectionView.scrollToItem(at: IndexPath(item: 2, section: 0), at: .right, animated: true)
          self.pager.itemIndex = 2
          self.pager.collectionView.reloadData()
          self.pagerIndex = 2
    }
    
    func resendCode(cell: VerifyCollectionViewCell) {
         print("Resend code")
        self.setAnimate(msg: "Please wait..")
        self.viewModel?.getOtp(number: self.mobileNumber ?? "", email: nil, isResend: 1, type: 3)
    }
    
    func submitAction(cell: ChangePassFormCell, index: Int, fields: [UITextField], passChecker: Bool) {
        if passChecker {
           self.showAlert(buttonOK: "Ok", message: "Password does not match.", actionOk: nil, completionHandler: nil)
        }else {
            if fields[0].text != "" && self.mobileNumber != "" {
                self.setAnimate(msg: "Please wait..")
                print("SUBMITING")
                self.viewModel?.changePassword(password: fields[0].text ?? "", phone: self.mobileNumber ?? "",token: self.tokenData)
           }
        }
    }
       
    
    
}
