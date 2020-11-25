//
//  IdentificationCollectionViewCell.swift
//  DA5-APP
//
//  Created by Jojo on 8/27/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit
protocol IdentificationCollectionViewCellDelegate {
    func submitAction(cell: IdentificationCollectionViewCell,index: Int)
    func selectValidId(cell: IdentificationCollectionViewCell,index: Int)
    func selectSelfieId(cell: IdentificationCollectionViewCell,index: Int)
}
class IdentificationCollectionViewCell: BaseCollectionViewCell, UITextFieldDelegate {
    
    var delegate : IdentificationCollectionViewCellDelegate?
    
    lazy var scrollView : UIScrollView = {
        let v = UIScrollView()
        return v
    }()
   
    lazy var headerView : CustomHeaderView = {
        let v = CustomHeaderView()
        v.title.text = "Identification"
        v.desc.text  = "Please fill up the following fields to proceed"
        return v
    }()
   
    lazy var phoneNumber: CustomBasicFormInput = {
        let v = CustomBasicFormInput()
        v.TextField.keyboardType = .numberPad
        v.TextField.tag = 1
        v.TextField.delegate = self
        return v
    }()
    
    lazy var emailAddress: CustomBasicFormInput = {
        let v = CustomBasicFormInput()
        v.TextField.keyboardType = .emailAddress
        v.TextField.tag = 2
        v.TextField.delegate = self
        return v
    }()
    
    lazy var password: CustomBasicFormInput = {
        let v = CustomBasicFormInput()
        v.TextField.tag = 3
        v.TextField.delegate = self
        return v
    }()
    
    lazy var confirmPassword : CustomTextField = {
        let v = CustomTextField()
        v.font = UIFont(name: Fonts.regular, size: 12)
        v.backgroundColor = ColorConfig().innerbgColor
        v.layer.cornerRadius = 5
        v.tag = 4
        v.delegate = self
        return v
    }()
    
    lazy var submitBtn : UIButton = {
        let v = UIButton()
        v.setTitle("Next", for: .normal)
        v.titleLabel?.font = UIFont(name: Fonts.bold, size: 12)
        v.tintColor = ColorConfig().white
        v.backgroundColor = ColorConfig().black
        v.layer.cornerRadius = 5
        return v
    }()
    
    lazy var validIdLabel : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Fonts.bold, size: 12)
        return v
    }()
    
    lazy var validIdPreview : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named:"valid_id_icon")?.withRenderingMode(.alwaysTemplate)
        v.layer.cornerRadius = 5
        v.backgroundColor = ColorConfig().innerbgColor
        return v
    }()
    
    lazy var selfieIdLabel : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Fonts.bold, size: 12)
        return v
    }()
   
    lazy var selfieIdPreview : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named:"selfie_id_icon")?.withRenderingMode(.alwaysTemplate)
        v.layer.cornerRadius = 5
        v.backgroundColor = ColorConfig().innerbgColor
        return v
    }()
    
    override func setUpView() {
        setUpForm()
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(self)
            make.bottom.equalTo(self).offset(0)
        }
        
        scrollView.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView).offset(25)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(60)
        }
        
        scrollView.addSubview(phoneNumber)
        phoneNumber.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(25)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(70)
        }
        
        scrollView.addSubview(emailAddress)
        emailAddress.snp.makeConstraints { (make) in
            make.top.equalTo(phoneNumber.snp.bottom).offset(5)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(70)
        }
        
        scrollView.addSubview(password)
        password.snp.makeConstraints { (make) in
            make.top.equalTo(emailAddress.snp.bottom).offset(5)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(70)
        }
        
        scrollView.addSubview(confirmPassword)
        confirmPassword.snp.makeConstraints { (make) in
            make.top.equalTo(password.snp.bottom).offset(5)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(40)
        }
        
        scrollView.addSubview(validIdLabel)
        validIdLabel.snp.makeConstraints { (make) in
            make.top.equalTo(confirmPassword.snp.bottom).offset(5)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(30)
        }
        
        scrollView.addSubview(validIdPreview)
        validIdPreview.snp.makeConstraints { (make) in
            make.top.equalTo(validIdLabel.snp.bottom)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(200)
        }
        
        scrollView.addSubview(selfieIdLabel)
        selfieIdLabel.snp.makeConstraints { (make) in
            make.top.equalTo(validIdPreview.snp.bottom).offset(5)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(30)
        }
       
        scrollView.addSubview(selfieIdPreview)
        selfieIdPreview.snp.makeConstraints { (make) in
            make.top.equalTo(selfieIdLabel.snp.bottom)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(200)
        }
        
        scrollView.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { (make) in
            make.top.equalTo(selfieIdPreview.snp.bottom).offset(20)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(40)
            make.bottom.equalTo(scrollView).offset(-20)
        }
        
    }
    
    func setUpForm() {
        let asteriskAttributes = NSAttributedString(string: " *", attributes: [.font:  UIFont(name: Fonts.bold, size: 14)!, .foregroundColor : ColorConfig().blue!])
       
        let phoneNumberAttributes = NSMutableAttributedString(string: "Phone Number ", attributes: [NSAttributedString.Key.font : UIFont(name: Fonts.bold, size: 12)!])
       
        let emailAddressAttributes = NSMutableAttributedString(string: "Email Address ", attributes: [NSAttributedString.Key.font : UIFont(name: Fonts.bold, size: 12)!])
        
        let passwordAttributes = NSMutableAttributedString(string: "Password ", attributes: [NSAttributedString.Key.font : UIFont(name: Fonts.bold, size: 12)!])
        
        let validIdAttributes = NSMutableAttributedString(string: "Valid ID Picture ", attributes: [NSAttributedString.Key.font : UIFont(name: Fonts.bold, size: 12)!])
        
        let selfieIdAttributes = NSMutableAttributedString(string: "Selfie with ID Picture ", attributes: [NSAttributedString.Key.font : UIFont(name: Fonts.bold, size: 12)!])
        
        phoneNumberAttributes.append(asteriskAttributes)
        emailAddressAttributes.append(asteriskAttributes)
        passwordAttributes.append(asteriskAttributes)
        validIdAttributes.append(asteriskAttributes)
        selfieIdAttributes.append(asteriskAttributes)
        
        phoneNumber.Label.attributedText = phoneNumberAttributes
        phoneNumber.TextField.placeholder = "Phone Number"
        emailAddress.Label.attributedText = emailAddressAttributes
        emailAddress.TextField.placeholder = "Email Address"
        password.Label.attributedText = passwordAttributes
        password.TextField.placeholder = "Enter Password"
        confirmPassword.placeholder = "Confirm Password"
        validIdLabel.attributedText = validIdAttributes
        selfieIdLabel.attributedText = selfieIdAttributes
        submitBtn.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        
        let tapValidID = UITapGestureRecognizer(target: self, action: #selector(onClickValidId))
        validIdPreview.isUserInteractionEnabled = true
        validIdPreview.addGestureRecognizer(tapValidID)
        
        let tapSelfiePrev = UITapGestureRecognizer(target: self, action: #selector(onClickValidId))
        selfieIdPreview.isUserInteractionEnabled = true
        selfieIdPreview.addGestureRecognizer(tapSelfiePrev)
    }
    
    @objc func submitAction() {
        self.delegate?.submitAction(cell: self, index: 2)
    }
    
    @objc func onClickValidId(){
        self.delegate?.selectValidId(cell: self, index: 2)
    }
    
    @objc func onClickSelfieId(){
        self.delegate?.selectSelfieId(cell: self, index: 2)
    }

    func addShowKeyboard(offset: CGFloat) {
       scrollView.snp.updateConstraints { (make) in
          make.bottom.equalTo(self).offset(offset)
       }
       self.layoutIfNeeded()
   }
   func textFieldDidBeginEditing(_ textField: UITextField){
        var point = CGPoint()
           switch textField.tag {
           case 1:
               point = phoneNumber.frame.origin
           case 2:
               point = emailAddress.frame.origin
           case 3:
               point = password.frame.origin
           case 4:
               point = confirmPassword.frame.origin
           default:
               break
           }
           point.y -= 100
           self.scrollView.setContentOffset(point
               , animated: true)
   }
    
}
