//
//  ProfileViewController.swift
//  DA5-APP
//
//  Created by Jojo on 11/25/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

class ProfileViewController: BaseHomeViewControler{
    var data : Customer? {
        didSet {
            if data?.kycStatus == 0  {
                self.statusLbl.text =  "KYC Pending Approval"
                self.statusDescLbl.isHidden = true
            }else if data?.kycStatus == 2 {
                self.statusLbl.text =  "KYC Application is Rejected"
                self.statusLbl.backgroundColor = ColorConfig().lightGray
                self.statusDescLbl.isHidden = false
                self.statusDescLbl.text = data?.kycNotice ?? ""
            }  else {
                self.statusDescLbl.isHidden = true
                self.statusLbl.isHidden = true
            }
        
            self.fname.TextField.text = data?.firstName
            self.mname.TextField.text = data?.middleName
            self.lname.TextField.text = data?.lastName
            self.bdate.TextField.text = data?.birthDate?.formatDate(dateFormat: "YYYY-MM-DD",format: "MMM dd, YYYY")
            self.gender.TextField.text = data?.gender
            self.nationality.TextField.text = data?.nationality
            self.address.TextField.text = data?.address
            self.phoneNumber.FieldView.TextField.text = data?.phone
            self.emailAddress.TextField.text = data?.email
            
            self.validIdPreview.downloaded(from: data?.idPictureThumbnail1 ?? "", contentMode: .scaleAspectFill)
            
            self.selfieIdPreview.downloaded(from: data?.idPictureThumbnail2 ?? "", contentMode: .scaleAspectFill)
        }
    }
    
    var nationalityList : Nationality?
    
    var nationalitySelected : String = "" {
          didSet {
               self.nationality.TextField.text = self.nationalitySelected
          }
    }
    
    var validId : UIImage? {
      didSet {
            self.validIdPreview.image = validId
          if self.viewModel?.registrationForm?.validId != nil {
              self.viewModel?.registrationForm?.validId = nil
          }
      }
    }
    
    var selfieId : UIImage? {
      didSet {
            self.selfieIdPreview.image = selfieId
            if self.viewModel?.registrationForm?.selfieId != nil {
                 self.viewModel?.registrationForm?.selfieId = nil
            }
      }
    }
    
    let errorMessage = "Only provide information that is true and correct. If you're below 18 years old, you may be required to present a parental consent. Users below 10 years old are not allowed to register."
    
    var bdayCheck : Bool = false
    
    var rightBarButton : UIBarButtonItem?
    
    var editViewShow : Bool = false
    
    var datePicker : UIDatePicker?
    
    let dateFormat = DateFormatter()
    
    var viewModel : LoginViewModel?
    
    lazy var customProgressView : CustomProgressView = {
       let v = CustomProgressView()
        v.title.text = "Please wait"
        v.message.text = ""
       return v
    }()
    
    lazy var scrollView : UIScrollView = {
        let v = UIScrollView()
        return v
    }()

    lazy var statusLbl : UILabel = {
        let v = UILabel()
        v.backgroundColor = ColorConfig().lightBlue
//        v.text = "KYC Pending Approval"
        v.textAlignment = .center
        v.textColor = ColorConfig().white
        v.font = UIFont(name: Fonts.bold, size: 14)
        v.layer.cornerRadius = 10
        return v
    }()
    
    lazy var statusDescLbl : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Fonts.regular, size: 12)
        v.numberOfLines = 0
        return v
    }()
    
    lazy var headerView : CustomHeaderView = {
        let v = CustomHeaderView()
        v.title.text = "Basic Information"
        return v
    }()
    
    lazy var fname: CustomBasicFormInput = {
        let v = CustomBasicFormInput()
        v.TextField.delegate = self
        v.TextField.tag = 1
        v.TextField.isEnabled = false
        return v
    }()
    
    lazy var mname: CustomBasicFormInput = {
        let v = CustomBasicFormInput()
        v.TextField.delegate = self
        v.TextField.tag = 2
        v.TextField.isEnabled = false
        return v
    }()
    
    lazy var lname: CustomBasicFormInput = {
        let v = CustomBasicFormInput()
        v.TextField.delegate = self
        v.TextField.tag = 3
        v.TextField.isEnabled = false
        return v
    }()
    
    lazy var bdate: CustomBasicFormInput = {
        let v = CustomBasicFormInput()
        v.TextField.delegate = self
        v.TextField.tag = 4
        v.TextField.isEnabled = false
        return v
    }()
    
    lazy var gender: CustomBasicFormInput = {
        let v = CustomBasicFormInput()
        v.TextField.isUserInteractionEnabled = false
        v.TextField.tag = 5
        v.TextField.isEnabled = false
        return v
    }()
    
    lazy var nationality: CustomBasicFormInput = {
        let v = CustomBasicFormInput()
        v.TextField.delegate = self
        v.TextField.tag = 6
        v.TextField.isUserInteractionEnabled = true
        v.TextField.isEnabled = false
        return v
    }()
    
    lazy var address: CustomBasicFormInput = {
        let v = CustomBasicFormInput()
        v.TextField.delegate = self
        v.TextField.tag = 7
        v.TextField.isEnabled = false
        return v
    }()

    lazy var headerView2 : CustomHeaderView = {
        let v = CustomHeaderView()
        v.title.text = "Identification"
        return v
    }()
    
    lazy var phoneNumber: CustomBasicFormInputNumber = {
        let v = CustomBasicFormInputNumber()
        v.FieldView.TextField.keyboardType = .numberPad
        v.FieldView.TextField.tag = 8
        v.FieldView.TextField.delegate = self
        v.FieldView.TextField.isEnabled = false
        return v
    }()
    
    lazy var emailAddress: CustomBasicFormInput = {
        let v = CustomBasicFormInput()
        v.TextField.keyboardType = .emailAddress
        v.TextField.tag = 9
        v.TextField.delegate = self
        v.TextField.autocapitalizationType = .none
        v.TextField.isEnabled = false
        return v
    }()
    
    lazy var validIdLabel : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Fonts.bold, size: 12)
        return v
    }()
    
    lazy var validIdPreview : UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 5
        v.tag = 1
        v.backgroundColor = ColorConfig().innerbgColor
        v.layer.masksToBounds = true
        v.clipsToBounds = true
        return v
    }()
    
    lazy var selfieIdLabel : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Fonts.bold, size: 12)
        return v
    }()
   
    lazy var selfieIdPreview : UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 5
        v.tag = 2
        v.backgroundColor = ColorConfig().innerbgColor
        v.layer.masksToBounds = true
        v.clipsToBounds = true
        return v
    }()
    
    lazy var submitBtn : UIButton = {
        let v = UIButton()
        v.setTitle("Save", for: .normal)
        v.titleLabel?.font = UIFont(name: Fonts.bold, size: 12)
        v.tintColor = ColorConfig().white
        v.backgroundColor = ColorConfig().black
        v.layer.cornerRadius = 5
        v.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        return v
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpForm()
        setUpView()
        setUpData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setUpNavigationBar()
        
        if data?.kycStatus != 1 { // && data?.kycUpdatedAt == nil
            setUpEditingActions()
            setUpRightNavigationBar()
            dismissCheckingDate()
        }else {
            disableEditing()
        }
    }
    
    func setUpRightNavigationBar() {
        let rightButton = UIButton(type: .system)
        rightButton.setTitle("Edit", for: .normal)
        rightButton.tintColor = ColorConfig().black
        rightButton.addTarget(self, action: #selector(showEditView), for: .touchUpInside)
        rightBarButton = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func showEditView() {
        editViewShow = !editViewShow
//        let item = self.navigationItem.rightBarButt
        let rightButton = UIButton(type: .system)
        rightButton.setTitle(editViewShow ? "Cancel" : "Edit", for: .normal)
        rightButton.tintColor = ColorConfig().black
        rightButton.addTarget(self, action: #selector(showEditView), for: .touchUpInside)
        rightBarButton = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.setUpTextFieldEditing(editing: editViewShow)
    }
    
    func disableEditing() {
        if editViewShow {
//            self.navigationItem.rightBarButtonItem = nil
             editViewShow = false
             self.setUpTextFieldEditing(editing: editViewShow)
        }
    }
    
    override func setUpData() {
        if data?.kycStatus != 1 { //&& data?.kycUpdatedAt == nil
            self.viewModel?.returnNationalityList = { [weak self] data in
                DispatchQueue.main.async {
                    self?.nationalityList = data
                     self?.stopAnimating()
                }
            }
            self.setAnimate(msg: "Please wait...")
            self.viewModel?.getNationality()
        }
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
    
    override func setUpView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
           make.top.leading.trailing.equalTo(view)
           make.bottom.equalTo(view).offset(0)
        }
        
        scrollView.addSubview(statusLbl)
        statusLbl.snp.makeConstraints { (make) in
           make.top.equalTo(scrollView).offset(data?.kycStatus != 1 ? 25 : 0)
           make.leading.equalTo(view).offset(20)
           make.trailing.equalTo(view).offset(-20)
           make.height.equalTo(data?.kycStatus != 1 ? 40 : 0)
        }
        
        let height = data?.kycNotice?.heightForView(font: statusDescLbl.font, width: self.view.frame.width - 40) ?? 0
        scrollView.addSubview(statusDescLbl)
        statusDescLbl.snp.makeConstraints { (make) in make.top.equalTo(statusLbl.snp.bottom).offset(data?.kycStatus == 2 ? 20 : 0)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(data?.kycStatus == 2 ? height : 0)
        }
        
        scrollView.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
           make.top.equalTo(statusDescLbl.snp.bottom).offset(20)
           make.leading.equalTo(view).offset(20)
           make.trailing.equalTo(view).offset(-20)
           make.height.equalTo(40)
        }
        
        scrollView.addSubview(fname)
        fname.snp.makeConstraints { (make) in
           make.top.equalTo(headerView.snp.bottom).offset(5)
           make.leading.equalTo(view).offset(20)
           make.trailing.equalTo(view).offset(-20)
           make.height.equalTo(70)
        }
        
        scrollView.addSubview(mname)
        mname.snp.makeConstraints { (make) in
           make.top.equalTo(fname.snp.bottom).offset(5)
           make.leading.equalTo(view).offset(20)
           make.trailing.equalTo(view).offset(-20)
           make.height.equalTo(70)
        }
        
        scrollView.addSubview(lname)
        lname.snp.makeConstraints { (make) in
           make.top.equalTo(mname.snp.bottom).offset(5)
           make.leading.equalTo(view).offset(20)
           make.trailing.equalTo(view).offset(-20)
           make.height.equalTo(70)
        }
        
        scrollView.addSubview(bdate)
        bdate.snp.makeConstraints { (make) in
           make.top.equalTo(lname.snp.bottom).offset(5)
           make.leading.equalTo(view).offset(20)
           make.trailing.equalTo(view).offset(-20)
           make.height.equalTo(70)
        }
        
        scrollView.addSubview(gender)
        gender.snp.makeConstraints { (make) in
           make.top.equalTo(bdate.snp.bottom).offset(5)
           make.leading.equalTo(view).offset(20)
           make.trailing.equalTo(view).offset(-20)
           make.height.equalTo(70)
        }
        
        scrollView.addSubview(nationality)
        nationality.snp.makeConstraints { (make) in
           make.top.equalTo(gender.snp.bottom).offset(5)
           make.leading.equalTo(view).offset(20)
           make.trailing.equalTo(view).offset(-20)
           make.height.equalTo(70)
        }
        
        scrollView.addSubview(address)
        address.snp.makeConstraints { (make) in
           make.top.equalTo(nationality.snp.bottom).offset(5)
           make.leading.equalTo(view).offset(20)
           make.trailing.equalTo(view).offset(-20)
           make.height.equalTo(70)
        }
        
        scrollView.addSubview(headerView2)
        headerView2.snp.makeConstraints { (make) in
            make.top.equalTo(address.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(40)
        }
        
        scrollView.addSubview(phoneNumber)
        phoneNumber.snp.makeConstraints { (make) in
            make.top.equalTo(headerView2.snp.bottom).offset(5)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(70)
        }

        scrollView.addSubview(emailAddress)
        emailAddress.snp.makeConstraints { (make) in
            make.top.equalTo(phoneNumber.snp.bottom).offset(5)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(70)
        }
                
        scrollView.addSubview(validIdLabel)
        validIdLabel.snp.makeConstraints { (make) in
            make.top.equalTo(emailAddress.snp.bottom).offset(5)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(30)
        }

        scrollView.addSubview(validIdPreview)
        validIdPreview.snp.makeConstraints { (make) in
            make.top.equalTo(validIdLabel.snp.bottom)
            make.leading.equalTo(view).offset(20)
            if ColorConfig().screenWidth > 500 {
                make.width.equalTo(400)
            }else {
                make.trailing.equalTo(view).offset(-20)
            }
            make.height.equalTo(200)
        }
        
        scrollView.addSubview(selfieIdLabel)
        selfieIdLabel.snp.makeConstraints { (make) in
            make.top.equalTo(validIdPreview.snp.bottom).offset(5)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(30)
        }

        scrollView.addSubview(selfieIdPreview)
        selfieIdPreview.snp.makeConstraints { (make) in
            make.top.equalTo(selfieIdLabel.snp.bottom)
            make.leading.equalTo(view).offset(20)
            if ColorConfig().screenWidth > 500 {
                make.width.equalTo(400)
            }else {
                make.trailing.equalTo(view).offset(-20)
            }
            make.height.equalTo(200)
//            make.bottom.equalTo(scrollView).offset(-20)
        }
         
        scrollView.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { (make) in
            make.top.equalTo(selfieIdPreview.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(0)
            make.bottom.equalTo(scrollView).offset(-20)
        }
    }
   
    func setUpForm() {
        let asteriskAttributes = NSAttributedString(string: " *", attributes: [.font:  UIFont(name: Fonts.bold, size: 14)!, .foregroundColor : ColorConfig().blue!])
        
        let fnameAttributes = NSMutableAttributedString(string: "First Name ", attributes: [NSAttributedString.Key.font : UIFont(name: Fonts.bold, size: 12)!])
        
        let mnameAttributes = NSMutableAttributedString(string: "Middle Name ", attributes: [NSAttributedString.Key.font : UIFont(name: Fonts.bold, size: 12)!])
        
        let lnameAttributes = NSMutableAttributedString(string: "Last Name ", attributes: [NSAttributedString.Key.font : UIFont(name: Fonts.bold, size: 12)!])
        
        let bdateAttributes = NSMutableAttributedString(string: "Birth Date ", attributes: [NSAttributedString.Key.font : UIFont(name: Fonts.bold, size: 12)!])
        
        let genderAttributes = NSMutableAttributedString(string: "Gender ", attributes: [NSAttributedString.Key.font : UIFont(name: Fonts.bold, size: 12)!])
        
        let nationalityAttributes = NSMutableAttributedString(string: "Nationality ", attributes: [NSAttributedString.Key.font : UIFont(name: Fonts.bold, size: 12)!])
        
        let addressAttributes = NSMutableAttributedString(string: "Address ", attributes: [NSAttributedString.Key.font : UIFont(name: Fonts.bold, size: 12)!])
        
        let phoneNumberAttributes = NSMutableAttributedString(string: "Phone Number ", attributes: [NSAttributedString.Key.font : UIFont(name: Fonts.bold, size: 12)!])

        let emailAddressAttributes = NSMutableAttributedString(string: "Email Address ", attributes: [NSAttributedString.Key.font : UIFont(name: Fonts.bold, size: 12)!])
        
        let validIdAttributes = NSMutableAttributedString(string: "Valid ID Picture ", attributes: [NSAttributedString.Key.font : UIFont(name: Fonts.bold, size: 12)!])

        let selfieIdAttributes = NSMutableAttributedString(string: "Selfie with ID Picture ", attributes: [NSAttributedString.Key.font : UIFont(name: Fonts.bold, size: 12)!])
        
        fnameAttributes.append(asteriskAttributes)
        lnameAttributes.append(asteriskAttributes)
        bdateAttributes.append(asteriskAttributes)
        genderAttributes.append(asteriskAttributes)
        nationalityAttributes.append(asteriskAttributes)
        addressAttributes.append(asteriskAttributes)
        
        fname.Label.attributedText = fnameAttributes
        fname.TextField.placeholder = "First Name"
        mname.Label.attributedText = mnameAttributes
        mname.TextField.placeholder = "Middle Name"
        lname.Label.attributedText = lnameAttributes
        lname.TextField.placeholder = "Last Name"
        bdate.Label.attributedText = bdateAttributes
        bdate.TextField.placeholder = "Birth Date"
        gender.Label.attributedText = genderAttributes
        gender.TextField.placeholder = "Gender"
        nationality.Label.attributedText = nationalityAttributes
        nationality.TextField.placeholder = "Nationality"
        address.Label.attributedText = addressAttributes
        address.TextField.placeholder = "Address"
        
        phoneNumberAttributes.append(asteriskAttributes)
        emailAddressAttributes.append(asteriskAttributes)
        validIdAttributes.append(asteriskAttributes)
        selfieIdAttributes.append(asteriskAttributes)

        phoneNumber.Label.attributedText = phoneNumberAttributes
        phoneNumber.FieldView.TextField.placeholder = "Phone Number"
        emailAddress.Label.attributedText = emailAddressAttributes
        emailAddress.TextField.placeholder = "Email Address"
        validIdLabel.attributedText = validIdAttributes
        selfieIdLabel.attributedText = selfieIdAttributes

    }
    
    @objc func submitAction() {
        //MARK: - check Customer data if have any changes and submit if fields change error if no changes
        
        self.viewModel?.registrationForm = RegistrationForm(fname: self.fname.TextField.text ?? "", mname: self.mname.TextField.text ?? "", lname: self.lname.TextField.text ?? "", bdate: self.bdate.TextField.text?.formatDate(dateFormat: "MMM dd, yyyy", format: "YYYY-MM-DD") ?? "" , gender: self.gender.TextField.text ?? "", nationality: self.nationality.TextField.text ?? "", address: self.address.TextField.text ?? "", city: self.data?.city, province: self.data?.province, zipcode: self.data?.zipCode, phoneNumber: self.phoneNumber.FieldView.TextField.text ?? "", email: self.emailAddress.TextField.text ?? "", password: nil, validId: self.validId != nil ? nil : self.data?.idPicture, selfieId: selfieId != nil ? nil : self.data?.idPicture2, code: nil, fbId: self.data?.facebookID ?? nil)
        
        let fields = [fname.TextField, lname.TextField,bdate.TextField, gender.TextField, nationality.TextField, address.TextField,phoneNumber.FieldView.TextField,emailAddress.TextField]
        
        if !checkFieldsChanges(fields: fields) {
            if !bdayCheck {
                self.showAlert(buttonOK: "Ok", message: errorMessage, actionOk: nil, completionHandler: nil)
            }else {
                self.coordinator?.showProfileVerificationViewController(data: self.data, vM: self.viewModel, view: self)
            }
            
        }else {
            // no action no changes
            self.showAlert(buttonOK: "Ok", message: "Please fill up all required fields.", actionOk: nil, completionHandler: nil)
        }
    }
    
    func checkFieldsChanges(fields: [UITextField]) -> Bool {
        //MARK: CHECKING FOR CHANGES IN INFO
         for x in 0...fields.count - 1 {
             if (fields[x].text ?? "") == "" {
                 return true
             }
         }
         return false
    }
    
        
}

extension ProfileViewController {
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           guard let text = textField.text else { return true }
           if textField.tag == 8 {
              let count = text.count + string.count - range.length
              return count <= 10
           }
          return true
      }
}


//MARK: - EDITING ACTION AND SETUP
extension ProfileViewController {
    @objc func selectValidId() {
        let vc = CapturedIdViewController()
        vc.coordinator = self.coordinator
        vc.vc = self
        vc.imageView.image = self.validId
        vc.type = 1
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func selectSelfieId() {
        let vc = CapturedIdViewController()
        vc.coordinator = self.coordinator
        vc.vc = self
        vc.type = 2
        vc.imageView.image = self.selfieId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showNationality() {
       self.view.endEditing(true)
       let vc = NationalityViewController()
       vc.modalPresentationStyle = .overCurrentContext
       vc.parentView = self
       vc.data = self.nationalityList
       self.present(vc, animated: false) {
            vc.showModal()
       }
   }
    
    @objc func showGenderPicker() {
        if editViewShow {
            let alert = UIAlertController(title: "Select Gender", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Male", style: .default, handler: { action in
                self.gender.TextField.text = "Male"
                self.dismissPicker()
            }))
            alert.addAction(UIAlertAction(title: "Female", style: .default, handler: { action in
                self.gender.TextField.text = "Female"
                self.dismissPicker()
            }))
            
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = gender
                popoverController.sourceRect = CGRect(x: gender.bounds.midX, y: 0, width: 120, height: 100)
    //            popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
            }
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    func setUpDatePicker() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        
        if let bDay = dateFormat.date(from: bdate.TextField.text ?? ""){
             datePicker?.date = bDay
        }
       
        datePicker?.maximumDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())
        datePicker?.addTarget(self, action: #selector(dateSelected(_:)), for: .valueChanged)
        
        bdate.TextField.inputView = datePicker
        

        let toolBar = UIToolbar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.view.frame.width, height: CGFloat(44))))
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(selectBDate))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action:  #selector(dismissDatePicker))
        toolBar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        bdate.TextField.inputAccessoryView = toolBar
     }
    
     @objc func dismissPicker() {
        self.view.endEditing(true)
     }
    
     @objc func dismissDatePicker() {
        self.view.endEditing(true)
        self.dismissCheckingDate()
     }
    
     @objc func selectBDate() {
        self.view.endEditing(true)
        self.dismissCheckingDate()
     }

     @objc func dateSelected(_ datePicker: UIDatePicker ) {
            bdate.TextField.text = dateFormat.string(from: datePicker.date)
     }
    
    func dismissCheckingDate() {
        guard let bDay = dateFormat.date(from: bdate.TextField.text ?? "") else {
           return
         }
        self.birthDateChecker(bDay: bDay)
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

    func setUpTextFieldEditing(editing: Bool) {
        self.fname.TextField.isEnabled = editing
        self.mname.TextField.isEnabled = editing
        self.lname.TextField.isEnabled = editing
        self.bdate.TextField.isEnabled = editing
        self.gender.TextField.isEnabled = editing
        self.nationality.TextField.isEnabled = editing
        self.address.TextField.isEnabled = editing
        self.phoneNumber.FieldView.TextField.isEnabled = editing
        self.emailAddress.TextField.isEnabled = editing
        self.validIdPreview.isUserInteractionEnabled = editing
        self.selfieIdPreview.isUserInteractionEnabled = editing
        self.gender.isUserInteractionEnabled = editing
        
        self.setUpContraintsUpdate(editing: editing)
        
    }
    
    func setUpContraintsUpdate(editing: Bool) {
        let statusHeight = editing ? 0 : (data?.kycStatus != 1 ? 40 : 0)
        let statusOffset = editing ? 0 : (data?.kycStatus != 1 ? 25 : 0)
        let height =  editing ? 0  : (data?.kycNotice?.heightForView(font: statusDescLbl.font, width: self.view.frame.width - 40) ?? 0)
        
        let offset = editing ? 0 : (data?.kycStatus == 2 ? 20 : 0)
        
        statusLbl.snp.remakeConstraints { (make) in
           make.top.equalTo(scrollView).offset(statusOffset)
           make.leading.equalTo(view).offset(20)
           make.trailing.equalTo(view).offset(-20)
           make.height.equalTo(statusHeight)
        }
        
        statusDescLbl.snp.remakeConstraints { (make) in make.top.equalTo(statusLbl.snp.bottom).offset(offset)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(data?.kycStatus == 2 ? height : 0)
        }
        
        submitBtn.snp.remakeConstraints { (make) in
            make.top.equalTo(selfieIdPreview.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(editing ? 40 : 0)
            make.bottom.equalTo(scrollView).offset(-20)
        }
        
    }
    
    func setUpEditingActions() {
        let validTap = UITapGestureRecognizer(target: self, action: #selector(selectValidId))
        self.validIdPreview.addGestureRecognizer(validTap)
        
        let selfieTap = UITapGestureRecognizer(target: self, action: #selector(selectSelfieId))
        self.selfieIdPreview.addGestureRecognizer(selfieTap)
        
        let gTap = UITapGestureRecognizer(target: self, action: #selector(showGenderPicker))
        self.gender.addGestureRecognizer(gTap)
        
        let tapNationality = UITapGestureRecognizer(target: self, action: #selector(showNationality))
        self.nationality.TextField.addGestureRecognizer(tapNationality)
        
        setUpDatePicker()
        dateFormat.dateFormat = "MMM dd, yyyy"
    }

    
}
