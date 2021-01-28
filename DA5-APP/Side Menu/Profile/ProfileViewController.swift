//
//  ProfileViewController.swift
//  DA5-APP
//
//  Created by Jojo on 11/25/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

class ProfileViewController: BaseHomeViewControler {
    var data : Customer? {
        didSet {
            if data?.kycStatus == 0  {
                self.statusLbl.text =  "KYC Pending Approval"
            }else {
                self.statusLbl.isHidden = true
            }
        
            self.fname.TextField.text = data?.firstName
            self.mname.TextField.text = data?.middleName
            self.lname.TextField.text = data?.lastName
            self.bdate.TextField.text = data?.birthDate?.formatDate(dateFormat: "YYYY-MM-DD",format: "MMMM dd, YYYY")
            self.gender.TextField.text = data?.gender
            self.nationality.TextField.text = data?.nationality
            self.address.TextField.text = data?.address
            self.phoneNumber.FieldView.TextField.text = data?.phone
            self.emailAddress.TextField.text = data?.email
            self.validIdPreview.downloaded(from: data?.idPicture ?? "", contentMode: .scaleAspectFill)
            self.selfieIdPreview.downloaded(from: data?.idPicture2 ?? "", contentMode: .scaleAspectFill)
        }
    }

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
        v.TextField.tag = 8
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
        v.tag = 2
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
        v.tag = 1
        v.backgroundColor = ColorConfig().innerbgColor
        v.layer.masksToBounds = true
        v.clipsToBounds = true
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpForm()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setUpNavigationBar()
    }
    
    override func setUpView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
           make.top.leading.trailing.equalTo(view)
           make.bottom.equalTo(view).offset(0)
        }
        
        scrollView.addSubview(statusLbl)
        statusLbl.snp.makeConstraints { (make) in
           make.top.equalTo(scrollView).offset(25)
           make.leading.equalTo(view).offset(20)
           make.trailing.equalTo(view).offset(-20)
           make.height.equalTo(data?.kycStatus == 0 ? 40 : 0)
        }
        
        scrollView.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
           make.top.equalTo(statusLbl.snp.bottom).offset(20)
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
        
}
