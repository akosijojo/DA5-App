//
//  ProfileVerificationViewController .swift
//  DA5-APP
//
//  Created by Jojo on 2/3/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit


class ProfileVerificationViewController: BaseViewControler {
    var timer : Timer?
    var seconds : Int = 0

//    var data : Customer?
    
    var viewModel : LoginViewModel?
    
    var vc : UIViewController?
    
    var mobileNumber: String? = nil
    
    var emailAddress: String? = nil
    
    var uploadingType : Int = 0

    var validId : UIImage? = nil
    
    var selfieId : UIImage? = nil
    
    lazy var pager : PagerView = {
        let v = PagerView()
        v.itemCount = 2
        v.itemColor = ColorConfig().lightBlue!
        v.itemIndex = 0
        return v
    } ()
    
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

    let form3 = "form3"


    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AuthenticationCollectionViewCell.self, forCellWithReuseIdentifier: form3)
        
        // Add Observer when keyboard will show and hide
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(self.whenShowKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(self.whenHideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.hidesKeyboardOnTapArround()
    }
    
    func asyncAPIRequest(){
        //Add Delay on uploading
        let delay : TimeInterval = 1

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
             if self.viewModel?.registrationForm?.validId == nil {
                 self.uploadingType = 1
                 self.viewModel?.uploadFile(image: self.validId, type: 0)
             }else if self.viewModel?.registrationForm?.selfieId == nil {
                 self.uploadingType = 2
                 self.viewModel?.uploadFile(image: self.selfieId, type: 1)
             }else {
                 self.uploadingType = 2 // set 2 if skipped uploading of selfie ID
                 self.beginAnimation(title:"Updating Personal Information", msg: "Please wait...")
                self.viewModel?.updateKyc(token: self.coordinator?.token)
             }
        }
        
    }
    
    func dismissView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.navigationController?.popViewController(animated: true)
        }
    }
        
    override func getData() {
        
        self.viewModel?.onSuccessRegistrationData = { [weak self] res in
            //MARK: - SAVING TO LOCAL THEN REFRESH PROFILEVIEWCONTROLLER DATA
            
            DispatchQueue.main.async {
                //MARK: -update local
                self?.stopAnimationBlocker()
                let updateLocal = res?.customer?.convertToLocalData()
                updateLocal?.saveCustomerToLocal()
                if let view = self?.vc as? ProfileViewController {
                   view.data = res?.customer
                }
                self?.dismissView()
                
                
            }
           
        }
        
        //MARK: - UPLOAD PROGRESS
         self.viewModel?.uploadProgress = { [weak self] progress in
             DispatchQueue.main.async {
               print("PROGRESS ",progress)
                 self?.beginAnimation(title:"Uploading \(self?.uploadingType == 1 ? "Valid Id picture" : "Selfie with Id picture")", msg: String(format: "%.0f",progress * 100)+"%")
                 //MARK: -UX SHOW SAVING if 100%
                 if progress == 1 {
                     if self?.uploadingType != 0 {
                         self?.beginAnimation(title:self?.uploadingType == 1 ? "Saving Valid Id picture" :  "Saving Selfie and Id picture", msg: "Please wait...")
                     }
                 }
                
             }
         }
        
        //MARK: - BASIC REQUEST
        self.viewModel?.onSuccessRequest = { [weak self] res in
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.500, execute: {
               if let tag = res?.tag {
                   switch tag {
                   case 1:
                       //MARK: -Check if OTP SUCCEED
                       self?.stopAnimationBlocker()
                    //GOTO OTP CODE INPUT VIEW
        //                           self?.gotoPage3(index: 2)//show Form 3 verification
                   case 10:
                   //MARK: - UPLOADED VALID ID
                       self?.asyncAPIRequest()
                   case 11:
                    //MARK: - UPLOADED SELFIE ID
                       self?.asyncAPIRequest()
                   default:
                       self?.stopAnimationBlocker() // stop Animation if tag is not on case
                       break
                   }
               }else {
                   self?.stopAnimationBlocker() // stop animation if not saving info
               }
           })
        }
        
        //MARK: - ALL REQUEST ERROR
        self.viewModel?.onErrorHandling = { [weak self] error in
            DispatchQueue.main.async {
                self?.stopAnimationBlocker()
                //MARK:- show this code
                self?.showAlert(buttonOK: "Ok", message: error?.message ?? "", actionOk: nil, completionHandler: nil)
            }
            
        }
        
//        self.viewModel?.generateAPIToken()
        self.viewModel?.getOtp(number: self.viewModel?.registrationForm?.phoneNumber, email: nil, isResend: 0, type: 1, customerId: UserLoginData.shared.id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpNavigationBar()
        self.pager.collectionView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        coordinator?.dismissViewController()
    }
    
    func hidesKeyboard() {
        view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc func whenShowKeyboard(_ notification : NSNotification) {

    }

    @objc func whenHideKeyboard(_ notification : NSNotification) {

    }
    
    override func setUpNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "arrow_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = ColorConfig().darkBlue
        backButton.addTarget(self, action: #selector(navBackAction), for: .touchUpInside)
        let leftButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    override func navBackAction() {
        self.viewModel = nil
        self.navigationController?.popViewController(animated: true)
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

extension ProfileVerificationViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: form3, for: indexPath) as? AuthenticationCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        cell.data = AuthData(phone: self.mobileNumber, email: self.emailAddress)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
    
    //MARK: - ANIMATION ON LOADING
    func beginAnimation(animate: Bool = true,title: String? = nil, msg: String? = nil) {
        if animate {
            customProgressView.runLoadingAnimation(vc: self,navBar: self.navigationController?.navigationBar, view: self.view,title: title,message: msg)
        }else {
             customProgressView.removeLoadingAnimation(vc: self, navBar: self.navigationController?.navigationBar)
        }
    }
    //MARK:-STOP ALL LOADING ANIMATION
    func stopAnimationBlocker() {
        self.stopAnimating()
        self.beginAnimation(animate: false)
    }
}

extension ProfileVerificationViewController : AuthenticationCollectionViewCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    func resendCode(cell: AuthenticationCollectionViewCell) {
        self.setAnimate(msg: "Please wait..")
        self.viewModel?.getOtp(number: self.mobileNumber, isResend: 1, type: 1 ,customerId: UserLoginData.shared.id)

    }
    
    func submitAction(cell: AuthenticationCollectionViewCell, index: Int) {
         if cell.verificationCode.text == "" {
             self.showAlert(buttonOK: "Ok", message: "Verification code is required", actionOk: { (action) in
                 // action
             }, completionHandler: nil)
         }else {
            guard let code = cell.verificationCode.text?.replacingOccurrences(of: " ", with: "") else { return }
            self.viewModel?.registrationForm?.code = code
            self.asyncAPIRequest()
         }

    }
}
