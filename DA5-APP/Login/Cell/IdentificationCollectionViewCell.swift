//
//  IdentificationCollectionViewCell.swift
//  DA5-APP
//
//  Created by Jojo on 8/27/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit
protocol IdentificationCollectionViewCellDelegate {
    func submitAction(cell: IdentificationCollectionViewCell,index: Int, fields: [UITextField],passChecker: Bool, form: RegistrationForm?)
    func selectValidId(cell: IdentificationCollectionViewCell,index: Int)
    func selectSelfieId(cell: IdentificationCollectionViewCell,index: Int)
}
class IdentificationCollectionViewCell: BaseCollectionViewCell, UITextFieldDelegate {
    
    var timer : Timer?
    
    var seconds : Int = 0
    
    var delegate : IdentificationCollectionViewCellDelegate?

    var show : Bool = false
    
    var textFields : [UITextField] = []
    
    var data : RegistrationForm? {
       didSet {
        print("DID GET DATA : \(data?.email) : \(data?.fbId)")
            if data?.email != nil {
                self.emailAddress.TextField.text = data?.email
            }
       }
    }
    
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
   
    lazy var phoneNumber: CustomBasicFormInputNumber = {
        let v = CustomBasicFormInputNumber()
        v.FieldView.TextField.keyboardType = .numberPad
        v.FieldView.TextField.tag = 1
        v.FieldView.TextField.delegate = self
        return v
    }()
    
    lazy var emailAddress: CustomBasicFormInput = {
        let v = CustomBasicFormInput()
        v.TextField.keyboardType = .emailAddress
        v.TextField.tag = 2
        v.TextField.delegate = self
        v.TextField.autocapitalizationType = .none
        return v
    }()
    
    lazy var password: CustomBasicFormInput = {
        let v = CustomBasicFormInput()
        v.TextField.tag = 3
        v.TextField.delegate = self
        v.TextField.isSecureTextEntry = true
        v.imageViewR.image = UIImage(named: "eye")?.withRenderingMode(.alwaysTemplate)
        v.imageViewR.tintColor = ColorConfig().darkGray
        v.imageViewR.tag = 1
        return v
    }()
    
    lazy var confirmPassword : CustomBasicFormInputPassword = {
        let v = CustomBasicFormInputPassword()
        v.TextField.tag = 4
        v.TextField.delegate = self
        v.TextField.isSecureTextEntry = true
        v.imageViewR.image = UIImage(named: "eye")?.withRenderingMode(.alwaysTemplate)
        v.imageViewR.tintColor = ColorConfig().darkGray
        v.imageViewR.tag = 2
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
        v.layer.cornerRadius = 5
        v.tag = 2
        v.backgroundColor = ColorConfig().innerbgColor
        return v
    }()
    
    lazy var validIdPreviewIcon : UIImageView = {
       let v = UIImageView()
       v.image = UIImage(named:"card")?.withRenderingMode(.alwaysTemplate)
//       v.layer.cornerRadius = 5
        v.tintColor = .clear
        v.backgroundColor = .clear
        v.contentMode = .scaleAspectFit
//        v.isHidden = false
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
        return v
    }()
    
    lazy var selfieIdPreviewIconUser : UIImageView = {
       let v = UIImageView()
       v.image = UIImage(named:"man")?.withRenderingMode(.alwaysTemplate)
       v.tintColor = .clear
       v.backgroundColor = .clear
       v.contentMode = .scaleAspectFit
       return v
    }()
    
    lazy var selfieIdPreviewIconId : UIImageView = {
       let v = UIImageView()
       v.image = UIImage(named:"id-card")?.withRenderingMode(.alwaysTemplate)
       v.tintColor = .clear
       v.backgroundColor = .clear
       v.contentMode = .scaleAspectFit
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
        
        password.showRightImageView()
        
        scrollView.addSubview(confirmPassword)
        confirmPassword.snp.makeConstraints { (make) in
            make.top.equalTo(password.snp.bottom).offset(5)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(40)
        }
        
        confirmPassword.showRightImageView()
        
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
        
        scrollView.addSubview(validIdPreviewIcon)
        validIdPreviewIcon.snp.makeConstraints { (make) in
            make.top.equalTo(validIdLabel.snp.bottom)
            make.centerX.equalTo(self)
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
        
        scrollView.bringSubviewToFront(validIdPreviewIcon)
        
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
        
        scrollView.addSubview(selfieIdPreviewIconUser)
        selfieIdPreviewIconUser.snp.makeConstraints { (make) in
            make.top.equalTo(selfieIdLabel.snp.bottom)
            make.centerX.equalTo(selfieIdPreview).offset(-60)
            make.width.equalTo(120)
            make.height.equalTo(200)
        }
        
        scrollView.addSubview(selfieIdPreviewIconId)
        selfieIdPreviewIconId.snp.makeConstraints { (make) in
            make.top.equalTo(selfieIdLabel.snp.bottom)
            make.leading.equalTo(selfieIdPreviewIconUser.snp.trailing)
            make.width.equalTo(80)
            make.height.equalTo(200)
        }
              
        scrollView.bringSubviewToFront(selfieIdPreviewIconUser)
        scrollView.bringSubviewToFront(selfieIdPreviewIconId)
        
        scrollView.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { (make) in
            make.top.equalTo(selfieIdPreview.snp.bottom).offset(20)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(40)
            make.bottom.equalTo(scrollView).offset(-20)
        }
        
        runAnimation()
    }
    
    func removePassword() {
        if data?.fbId != nil {
            //MARK: hide show password and confirm password
             password.snp.remakeConstraints { (make) in
                 make.top.equalTo(emailAddress.snp.bottom).offset(5)
                 make.leading.equalTo(self).offset(20)
                 make.trailing.equalTo(self).offset(-20)
                 make.height.equalTo(0)
             }
           
             confirmPassword.snp.remakeConstraints { (make) in
                 make.top.equalTo(password.snp.bottom).offset(5)
                 make.leading.equalTo(self).offset(20)
                 make.trailing.equalTo(self).offset(-20)
                 make.height.equalTo(0)
             }
            password.isHidden = true
            confirmPassword.isHidden = true
        }else {
            //MARK: hide show password and confirm password
            password.snp.remakeConstraints { (make) in
               make.top.equalTo(emailAddress.snp.bottom).offset(5)
               make.leading.equalTo(self).offset(20)
               make.trailing.equalTo(self).offset(-20)
               make.height.equalTo(70)
            }

            confirmPassword.snp.remakeConstraints { (make) in
               make.top.equalTo(password.snp.bottom).offset(5)
               make.leading.equalTo(self).offset(20)
               make.trailing.equalTo(self).offset(-20)
               make.height.equalTo(40)
            }
            password.isHidden = false
            confirmPassword.isHidden = false
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
        phoneNumber.FieldView.TextField.placeholder = "Phone Number"
        emailAddress.Label.attributedText = emailAddressAttributes
        emailAddress.TextField.placeholder = "Email Address"
        password.Label.attributedText = passwordAttributes
        password.TextField.placeholder = "Enter Password"
        confirmPassword.TextField.placeholder = "Confirm Password"
        validIdLabel.attributedText = validIdAttributes
        selfieIdLabel.attributedText = selfieIdAttributes
        submitBtn.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        
        let tapValidID = UITapGestureRecognizer(target: self, action: #selector(onClickValidId))
        validIdPreview.isUserInteractionEnabled = true
        validIdPreview.addGestureRecognizer(tapValidID)
        
        let tapSelfiePrev = UITapGestureRecognizer(target: self, action: #selector(onClickSelfieId))
        selfieIdPreview.isUserInteractionEnabled = true
        selfieIdPreview.addGestureRecognizer(tapSelfiePrev)
        
        textFields = [
                         phoneNumber.FieldView.TextField,
                         emailAddress.TextField,
                         password.TextField,
                         confirmPassword.TextField
                     ]
        
         // MARK: - Password
        let tapEye = UITapGestureRecognizer(target: self, action: #selector(showHidePassword))
        password.imageViewR.addGestureRecognizer(tapEye)
        let tapEye2 = UITapGestureRecognizer(target: self, action: #selector(showHidePassword))
        confirmPassword.imageViewR.addGestureRecognizer(tapEye2)
    }
    
    @objc func showHidePassword(_ gesture: UIGestureRecognizer) {
        if gesture.view?.tag == 1 {
            password.imageViewR.image = password.isSecure ? UIImage(named: "eye")?.withRenderingMode(.alwaysTemplate) : UIImage(named: "eye-slash")?.withRenderingMode(.alwaysTemplate)
            password.TextField.isSecureTextEntry = password.isSecure
            password.isSecure = !password.isSecure
        }else {
            confirmPassword.imageViewR.image = confirmPassword.isSecure ? UIImage(named: "eye")?.withRenderingMode(.alwaysTemplate) : UIImage(named: "eye-slash")?.withRenderingMode(.alwaysTemplate)
            confirmPassword.TextField.isSecureTextEntry = confirmPassword.isSecure
            confirmPassword.isSecure = !confirmPassword.isSecure
        }
    }
    
    @objc func submitAction() {
        //MARK: Added checking if login from Facebook
        let passChecker = data?.fbId != nil ? password.TextField.text != confirmPassword.TextField.text : false
        let fields = data?.fbId != nil ? [phoneNumber.FieldView.TextField,
                                          emailAddress.TextField] : textFields
        self.delegate?.submitAction(cell: self, index: 2, fields: fields,passChecker: passChecker, form: setUpFormData())
    }
    
    func setUpFormData() -> RegistrationForm {
        
//        make checking here of images before force unwrapping
        return RegistrationForm(phoneNumber: phoneNumber.FieldView.TextField.text, email: emailAddress.TextField.text, password: data?.fbId != nil ? nil : password.TextField.text)
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         guard let text = textField.text else { return true }
         if textField.tag == 1 {
            let count = text.count + string.count - range.length
            return count <= 10
         }
        return true
    }
    
    func animatePrevIcon(){
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {
            self.validIdPreviewIcon.tintColor = .white
            self.selfieIdPreviewIconUser.tintColor = .white
            self.selfieIdPreviewIconId.tintColor = .white
        }, completion:{ (res) in
            UIView.animate(withDuration: 1, delay: 2, options: .curveEaseOut, animations: {
               self.validIdPreviewIcon.tintColor = .clear
               self.selfieIdPreviewIconUser.tintColor = .clear
               self.selfieIdPreviewIconId.tintColor = .clear
            }, completion: nil)
        })
    }
    
    
    func runAnimation() {
        timer = Timer.scheduledTimer(timeInterval: 10, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
        animatePrevIcon()
    }
}
