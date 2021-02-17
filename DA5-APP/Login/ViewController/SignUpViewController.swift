//
//  SignUpViewController.swift
//  DA5-APP
//
//  Created by Jojo on 8/26/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit
import AVFoundation
import NVActivityIndicatorView

class SignUpViewController: BaseViewControler {
    var timer : Timer?
    var seconds : Int = 0
    var bdate : UITextField? = nil
    var datePicker : UIDatePicker? = nil
    var pagerIndex : Int = 0
    var agreeTermsAndCondition : Bool = false
    
    var viewModel : LoginViewModel?

    var bdayCheck : Bool = true
    let errorMessage = "Only provide information that is true and correct. If you're below 18 years old, you may be required to present a parental consent. Users below 10 years old are not allowed to register."
    
    var imageViewSelected: Int = 1
    
    var validId : UIImage? {
        didSet {
            self.collectionView.reloadData()
            if self.viewModel?.registrationForm?.validId != nil {
//                print("NOT NILL VALID ID")
                self.viewModel?.registrationForm?.validId = nil
            }
        }
    }
    var selfieId : UIImage? {
        didSet {
          self.collectionView.reloadData()
          if self.viewModel?.registrationForm?.selfieId != nil {
//              print("NOT NILL SELFIE ID")
               self.viewModel?.registrationForm?.selfieId = nil
          }
        }
    }
    
    var mobileNumber: String? {
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    var uploadingType: Int = 0
    
    lazy var pager : PagerView = {
        let v = PagerView()
        v.itemCount = 3
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
    
    let form1 = "form1"
    let form2 = "form2"
    let form3 = "form3"
    
    var nationalitySelected : String = "" {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var nationalityList : Nationality?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BasicInfoCell.self, forCellWithReuseIdentifier: form1)
        collectionView.register(IdentificationCollectionViewCell.self, forCellWithReuseIdentifier: form2)
        collectionView.register(VerifyCollectionViewCell.self, forCellWithReuseIdentifier: form3)
        showDatePicker()
        
        // Add Observer when keyboard will show and hide
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(self.whenShowKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(self.whenHideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.hidesKeyboardOnTapArround()
    }
    
    override func getData() {
        //MARK: - GET NATIONALITIES
        self.viewModel?.returnNationalityList = { [weak self] data in
            DispatchQueue.main.async {
                self?.nationalityList = data
                 self?.stopAnimating()
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
                        self?.gotoPage3(index: 2)//show Form 3 verification
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
        //MARK:-Registration Successfull
        self.viewModel?.onSuccessRegistrationData = { [weak self] data in
            DispatchQueue.main.async {
                self?.stopAnimationBlocker()
                if let result = data {
                    self?.showAlert(buttonOK: "Ok", message: "Registration Successful.", actionOk: { (act) in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            if data?.customer != nil {
                                self?.coordinator?.pinCodeCoordinator(isChecking: true, customerData:result.customer,refreshToken: data?.refreshToken)
                            }
                        }
                    }, completionHandler: nil)
                }
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
        //MARK: - ALL REQUEST ERROR
        self.viewModel?.onErrorHandling = { [weak self] error in
            DispatchQueue.main.async {
                self?.stopAnimationBlocker()
                //MARK:- show this code
                self?.showAlert(buttonOK: "Ok", message: error?.message ?? "", actionOk: nil, completionHandler: nil)
            }
            
        }
        self.viewModel?.getNationality()
        setAnimate(msg: "Please wait")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpNavigationBar()
        self.pager.collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        coordinator?.dismissViewController()
    }
    
    func hidesKeyboard() {
        print("HEY CLOSING")
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
          if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                guard let cell = collectionView.cellForItem(at: IndexPath(item: pagerIndex, section: 0))  else {
                        return
                }
                if let cellView = cell as? BasicInfoCell {
                     if #available(iOS 11.0, *) {
                        cellView.addShowKeyboard(offset: -(keyboardSize.height - self.view.safeAreaInsets.bottom))
                    } else {
                        cellView.addShowKeyboard(offset: -keyboardSize.height)
                    }
                }
                if let cellView = cell as? IdentificationCollectionViewCell {
                     if #available(iOS 11.0, *) {
                        cellView.addShowKeyboard(offset: -(keyboardSize.height - self.view.safeAreaInsets.bottom))
                    } else {
                        cellView.addShowKeyboard(offset: -keyboardSize.height)
                    }
                }
            }
    }

    @objc func whenHideKeyboard(_ notification : NSNotification) {
        guard let cell = collectionView.cellForItem(at: IndexPath(item: pagerIndex, section: 0)) else {
             return
         }
          if let cellView = cell as? BasicInfoCell {
              cellView.addShowKeyboard(offset:0)
          }
          if let cellView = cell as? IdentificationCollectionViewCell {
              cellView.addShowKeyboard(offset:0)
          }
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
        if pagerIndex >= 1 {
            //MARK: - back action when keyboard is showed
             if let cell = collectionView.cellForItem(at: IndexPath(item: pagerIndex, section: 0))  {
                 if let cellView = cell as? IdentificationCollectionViewCell {
                     if #available(iOS 11.0, *) {
                         cellView.addShowKeyboard(offset: 0)
                     } else {
                         cellView.addShowKeyboard(offset: 0)
                     }
                 }
             }
            
            self.collectionView.scrollToItem(at: IndexPath(item: pagerIndex - 1, section: 0), at: .right, animated: true)
            self.pager.itemIndex -= 1
            self.pagerIndex -= 1
            self.pager.collectionView.reloadData()
            self.view.endEditing(true)
        }else {
            //remove data in memory
            self.validId = nil
            self.selfieId = nil
            self.bdate = nil
            self.viewModel = nil
            self.navigationController?.popViewController(animated: true)
        }
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
    
    func showDatePicker(){
       //Formate Date
        datePicker?.datePickerMode = .date

        //ToolBar
       let toolbar = UIToolbar();
       toolbar.sizeToFit()

       //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action:  #selector(cancelDatePicker))
       toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

        // add toolbar to textField
        bdate?.inputAccessoryView = toolbar
         // add datepicker to textField
        bdate?.inputView = datePicker

     }

     @objc func donedatePicker(){
      //For date formate
       let formatter = DateFormatter()
       formatter.dateFormat = "dd/MM/yyyy"
        if let date = datePicker?.date {
            bdate?.text = formatter.string(from: date)
        }
       //dismiss date picker dialog
        self.view.endEditing(true)
     }

      @objc func cancelDatePicker(){
       //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
      }
    
    func showNationalities() {
        let vc = NationalityViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.parentView = self
        vc.data = self.nationalityList
        self.present(vc, animated: false) {
             vc.showModal()
        }
    }
    
    func birthDateChecker(bDay: Date) {
        // 0 ok // 1 under 18 but > 10 // 2 under Age
        let userAge = Calendar.current.dateComponents([.year], from: bDay, to: Date())
        var haveError : Bool = false
        if let age = userAge.year {
            if age >= 18 {
              haveError = false
              bdayCheck = true
            }else if age > 10 {
               haveError = true
               bdayCheck = true
            }else {
               haveError = true
               bdayCheck = false
            }
        }
        if haveError {
            self.showAlert(buttonOK: "Ok", message: errorMessage, actionOk: { (act) in
                
            }, completionHandler: nil)
        }
    }
}

extension SignUpViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: form1, for: indexPath) as? BasicInfoCell else {
                return UICollectionViewCell()
            }
            cell.data = self.viewModel?.registrationForm
            cell.vc = self
            cell.delegate = self
            cell.nationality.TextField.text = self.nationalitySelected
            return cell
        }else if  indexPath.item == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: form2, for: indexPath) as? IdentificationCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            if let vImg = validId {
                cell.validIdPreview.image = vImg
            }
            if let sImg = selfieId {
                cell.selfieIdPreview.image = sImg
            }
            cell.data = self.viewModel?.registrationForm
            cell.removePassword()
            return cell
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: form3, for: indexPath) as? VerifyCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            cell.data = self.mobileNumber
//            print("CELLPHONE NUMBER :",self.viewModel?.registrationForm?.phoneNumber ?? "")
//            if let mobileNum = self.viewModel?.registrationForm?.phoneNumber {
//                cell.headerView.desc.text = "+63"+mobileNum
//            }
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
        if formChecker(fields: fields) || formImageChecker(image: image){
            let alert = self.alert("Ok", "", "Please fill out the following required fields to proceed.") { (act) in
                
            }
            self.present(alert, animated: true, completion: nil)

            return false
        }
        
        if !bdayCheck {
            self.showAlert(buttonOK: "Ok", message: errorMessage, actionOk: { (act) in
                
            }, completionHandler: nil)
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
    
    func formImageChecker(image: [UIImage?]?) -> Bool {
        if let imgArray = image {
            for x in 0...imgArray.count - 1 {
               if image?[x] == nil {
                 return true
               }
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
        self.beginAnimation(animate: false)
    }
}

extension SignUpViewController : BasicInfoCellDelegate, IdentificationCollectionViewCellDelegate, VerifyCollectionViewCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    //MARK: - form 1
    func submitAction(cell: BasicInfoCell, index: Int,fields: [UITextField],form: RegistrationForm?) {
        self.view.endEditing(true)
        if showFormError(fields: fields){
//            self.view.endEditing(true)
            self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .right, animated: true)
            self.pager.itemIndex = 1
            self.pager.collectionView.reloadData()
            self.pagerIndex = 1
            self.viewModel?.registrationForm = form
        }
    }
    //MARK: -form 2
    func submitAction(cell: IdentificationCollectionViewCell, index: Int, fields: [UITextField], passChecker: Bool, form: RegistrationForm?) {
        self.view.endEditing(true)
        if passChecker {
            self.showAlert(buttonOK: "Ok", message: "Password does not match.", actionOk: nil, completionHandler: nil)
        }else {
            if showFormError(fields: fields, image: [validId,selfieId]){
                 self.setAnimate(msg: "Please wait..")
                 self.viewModel?.registrationForm?.setUpIdentification(form: form)
                 self.viewModel?.getOtp(number: form?.phoneNumber ?? "", email: form?.email ?? "", isResend: 0)
            }
        }
    }
    
    func resendCode(cell: VerifyCollectionViewCell) {
        self.setAnimate(msg: "Please wait..")
        self.viewModel?.getOtp(number: self.viewModel?.registrationForm?.phoneNumber ?? "", email: self.viewModel?.registrationForm?.email ?? "", isResend: 1)
    }
    func gotoPage3(index: Int) {
        self.viewModel?.registrationForm?.showValues()
        self.mobileNumber = self.viewModel?.registrationForm?.phoneNumber
        self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .right, animated: true)
        self.pager.itemIndex = 2
        self.pager.collectionView.reloadData()
        self.pagerIndex = 2
    }
    
    //MARK: -form 3
    func submitAction(cell: VerifyCollectionViewCell, index: Int) {
     // show terms and condition
        if cell.verificationCode.text?.replacingOccurrences(of: " ", with: "") != "" {
            self.viewModel?.registrationForm?.code = cell.verificationCode.text?.replacingOccurrences(of: " ", with: "")
            if !agreeTermsAndCondition {
    //            agreeTermsAndCondition = true
                coordinator?.termsCoordinator(parentView: self)
            }else {
                self.agreeOnTermsAndCondition()
            }
        }
    }
    
    //MARK: - SELECT IMAGE
    func selectValidId(cell: IdentificationCollectionViewCell, index: Int) {
        let vc = CapturedIdViewController()
        vc.coordinator = self.coordinator
        vc.vc = self
        vc.imageView.image = self.validId
        vc.type = 1
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func selectSelfieId(cell: IdentificationCollectionViewCell, index: Int) {
        let vc = CapturedIdViewController()
        vc.coordinator = self.coordinator
        vc.vc = self
        vc.type = 2
        vc.imageView.image = self.selfieId
        navigationController?.pushViewController(vc, animated: true)
    }

    func agreeOnTermsAndCondition() {
        // Uploading images
        // save collected info if error uploading images skipped cause already uploaded then submit again collected data
        // show MPIN Creation
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.viewModel?.uploadFile()
//
//        }
        self.asyncAPIRequest()
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
                self.beginAnimation(title:"Saving Personal Information", msg: "Please wait...")
                self.viewModel?.createAccount()
            }
        }
    }
    
}
