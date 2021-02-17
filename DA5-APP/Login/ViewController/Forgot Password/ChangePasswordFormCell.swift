//
//  ChangePasswordFormCell.swift
//  DA5-APP
//
//  Created by Jojo on 2/17/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit
protocol ChangePassFormCellDelegate: class {
    func submitAction(cell: ChangePassFormCell, index: Int, fields: [UITextField], passChecker: Bool)
}
class ChangePassFormCell: BaseCollectionViewCell, UITextFieldDelegate {
    weak var vc : ForgotViewController?
    var textFields : [UITextField] = []
    var delegate : ChangePassFormCellDelegate?
    
    lazy var headerView : CustomHeaderView = {
        let v = CustomHeaderView()
        v.title.text = "Forgot password"
        v.desc.text = ""
        v.desc.numberOfLines = 0
        return v
    }()
    
    lazy var password: CustomBasicFormInput = {
         let v = CustomBasicFormInput()
         v.TextField.tag = 3
         v.TextField.delegate = self
         v.TextField.isSecureTextEntry = true
         v.TextField.placeholder = "New Password"
         v.Label.text = "New Password"
         v.Label.font = UIFont(name: Fonts.bold, size: 12)
         v.imageViewR.image = UIImage(named: "eye")?.withRenderingMode(.alwaysTemplate)
         v.imageViewR.tintColor = ColorConfig().darkGray
         v.imageViewR.tag = 1
         return v
     }()
    
     lazy var confirmPassword : CustomBasicFormInput = {
         let v = CustomBasicFormInput()
         v.TextField.tag = 4
         v.TextField.delegate = self
         v.TextField.isSecureTextEntry = true
         v.TextField.placeholder = "Confirm Password"
         v.Label.text = "Confirm Password"
         v.Label.font = UIFont(name: Fonts.bold, size: 12)
         v.imageViewR.image = UIImage(named: "eye")?.withRenderingMode(.alwaysTemplate)
         v.imageViewR.tintColor = ColorConfig().darkGray
         v.imageViewR.tag = 2
         return v
     }()
     
    
    lazy var submitBtn : UIButton = {
        let v = UIButton()
         v.layer.cornerRadius = 5
         v.backgroundColor = ColorConfig().black
         v.setTitle("Proceed", for: .normal)
         v.titleLabel?.font = UIFont(name: Fonts.medium, size: 12)
         v.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        return v
    }()
    
    override func setUpView() {
//        addSubview(scrollView)
//        scrollView.snp.makeConstraints { (make) in
//            make.top.leading.trailing.equalTo(self)
//            make.bottom.equalTo(self).offset(0)
//        }
        addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(25)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(60)
        }
        
        addSubview(password)
        password.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(5)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(70)
        }
        
        password.showRightImageView()
        
        addSubview(confirmPassword)
        confirmPassword.snp.makeConstraints { (make) in
            make.top.equalTo(password.snp.bottom).offset(5)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(70)
        }
        
        confirmPassword.showRightImageView()
        
        addSubview(submitBtn)
        submitBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(40)
            make.bottom.equalTo(self).offset(-20)
        }
        
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
        self.delegate?.submitAction(cell: self, index: 1, fields: [confirmPassword.TextField],passChecker: password.TextField.text != confirmPassword.TextField.text)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         guard let text = textField.text else { return true }
         if textField.tag == 1 {
            let count = text.count + string.count - range.length
            return count <= 10
         }
        return true
    }
}


