//
//  PhoneNumberCell.swift
//  DA5-APP
//
//  Created by Jojo on 2/15/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

protocol PhoneNumberCellDelegate {
    func submitAction(cell: PhoneNumberCell,index: Int, fields: [UITextField])
}

class PhoneNumberCell: BaseCollectionViewCell, UITextFieldDelegate {
    weak var vc : ForgotViewController?
    var delegate : PhoneNumberCellDelegate?
    var textFields : [UITextField] = []
    
//    lazy var scrollView : UIScrollView = {
//        let v = UIScrollView()
//        return v
//    }()
//
    lazy var headerView : CustomHeaderView = {
        let v = CustomHeaderView()
        v.title.text = "Forgot password"
        v.desc.text = "Enter your mobile number for the verification process we will send a 6 digit code to your phone."
        v.desc.numberOfLines = 0
        return v
    }()
    
    lazy var phoneNumber: CustomBasicFormInputNumber = {
        let v = CustomBasicFormInputNumber()
        v.FieldView.TextField.keyboardType = .numberPad
        v.FieldView.TextField.tag = 1
        v.FieldView.TextField.delegate = self
        v.FieldView.TextField.placeholder = "Phone number"
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
            make.height.equalTo(100)
        }
        addSubview(phoneNumber)
        phoneNumber.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(25)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(70)
        }
        addSubview(submitBtn)
        submitBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(40)
            make.bottom.equalTo(self).offset(-20)
        }
    }
    
    @objc func submitAction() {
        self.delegate?.submitAction(cell: self, index: 1, fields: [phoneNumber.FieldView.TextField])
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

