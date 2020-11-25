//
//  VerifyCollectionViewCell.swift
//  DA5-APP
//
//  Created by Jojo on 9/9/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit
protocol VerifyCollectionViewCellDelegate {
    func submitAction(cell: VerifyCollectionViewCell,index: Int)
}
class VerifyCollectionViewCell: BaseCollectionViewCell, UITextFieldDelegate {
   
    var delegate : VerifyCollectionViewCellDelegate?
    
    lazy var scrollView : UIScrollView = {
        let v = UIScrollView()
        return v
    }()
  
    lazy var headerView : CustomHeaderView = {
        let v = CustomHeaderView()
        v.title.text = "Please enter the 6 digit code sent to"
        v.desc.text  = "+639123456789"
        v.title.font = UIFont(name: Fonts.regular, size: 12)
        v.desc.font = UIFont(name: Fonts.bold, size: 20)
        return v
    }()
    
    lazy var verificationCode: UITextField = {
        let v = UITextField()
        v.keyboardType = .numberPad
        v.font = UIFont(name: Fonts.medium, size: 30)
        v.placeholder = "0 0 0 0 0 0"
        v.tag = 1
        return v
    }()
    
    lazy var verificationLabel : UILabel = {
        let v = UILabel()
        v.text = "Didn't recieve it yet ?"
        v.font = UIFont(name: Fonts.regular, size: 12)
        return v
    }()
    
    lazy var resendLabel : UILabel = {
        let v = UILabel()
        v.text = "Resend Code"
        v.isUserInteractionEnabled = true
        v.font = UIFont(name: Fonts.regular, size: 12)
        return v
    }()
    
    lazy var submitBtn : UIButton = {
        let v = UIButton()
        v.setTitle("Proceed", for: .normal)
        v.titleLabel?.font = UIFont(name: Fonts.bold, size: 12)
        v.tintColor = ColorConfig().white
        v.backgroundColor = ColorConfig().black
        v.layer.cornerRadius = 5
        v.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        return v
    }()
   
    override func setUpView() {
        verificationCode.delegate = self
        addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(25)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(60)
        }
        
        addSubview(verificationCode)
        verificationCode.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(100)
            make.leading.equalTo(self).offset(40)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(60)
        }
        
        addSubview(verificationLabel)
        verificationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(verificationCode.snp.bottom).offset(80)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(30)
        }
        
        addSubview(resendLabel)
        resendLabel.snp.makeConstraints { (make) in
            make.top.equalTo(verificationLabel.snp.bottom)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(40)
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
        delegate?.submitAction(cell: self, index: 2)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxText = 6
        // only allow numerical characters
        guard string.compactMap({ Int(String($0)) }).count ==
            string.count else { return false }

        let text = textField.text ?? ""

        if string.count == 0 {
            textField.text = String(text.dropLast()).chunkFormatted()
        }
        else {
            let newText = String((text + string)
                .filter({ $0 != " " }).prefix(maxText))
            textField.text = newText.chunkFormatted()
        }
        return false
    }
}
