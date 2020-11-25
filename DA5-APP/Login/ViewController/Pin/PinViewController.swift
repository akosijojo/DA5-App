//
//  PinViewController.swift
//  DA5-APP
//
//  Created by Jojo on 11/19/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

class PinViewController: BaseViewControler {
    var MPIN : String? = ""
    lazy var topView : UIView = {
       let v = UIView()
       return v
    }()
    lazy var imgLogo : UIImageView = {
       let v = UIImageView()
        v.image = UIImage(named: "app_logo")
       return v
    }()
    
    lazy var mainLabel : UILabel = {
       let v = UILabel()
        v.text = "ENTER YOUR MPIN"
        v.font = UIFont(name: Fonts.bold, size: 25)
        v.textAlignment = .center
       return v
    }()
    
    lazy var secondaryLabel : UILabel = {
       let v = UILabel()
       v.text = "Never share your MPIN with anyone."
       v.font = UIFont(name: Fonts.medium, size: 12)
       v.textAlignment = .center
       return v
    }()
    
    lazy var pinTextField : CustomPinTextField = {
       let v = CustomPinTextField()
       return v
    }()
    
    lazy var pinTextFieldError : UILabel = {
       let v = UILabel()
        v.textColor = ColorConfig().darkRed
        v.textAlignment = .center
        v.text = "Incorrect MPIN"
        v.font = UIFont(name: Fonts.medium, size: 12)
       return v
    }()
    
    lazy var bottomView : UIView = {
       let v = UIView()
       return v
    }()
    
    lazy var forgotMpin : UILabel = {
       let v = UILabel()
        v.font = UIFont(name: Fonts.medium, size: 12)
        v.text = "Forgot MPIN?"
       return v
    }()
    
    lazy var numPadView : CustomNumPad = {
       let v = CustomNumPad()
       v.maxInput = 4
       return v
    }()
    
    override func setUpView() {
        view.addSubview(topView)
        topView.addSubview(imgLogo)
        topView.addSubview(mainLabel)
        topView.addSubview(secondaryLabel)
        topView.addSubview(pinTextField)
        topView.addSubview(pinTextFieldError)
        view.addSubview(bottomView)
        bottomView.addSubview(numPadView)
        bottomView.addSubview(forgotMpin)
        
        pinTextField.defaultText = "•"
        pinTextField.configure(with: 4)
        pinTextField.didEnterLastDigit = { [weak self] code in
            self?.MPIN = code
        }
        numPadView.numPadReturnOutput = { [weak self] output in
            self?.pinTextField.textUpdate(text: output)
        }
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(view).multipliedBy(0.50)
        }
        imgLogo.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.top).offset(20)
            make.centerX.equalTo(view)
            make.width.equalTo(80)
            make.height.equalTo(50)
        }
        mainLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imgLogo.snp.bottom).offset(20)
            make.leading.equalTo(topView).offset(20)
            make.trailing.equalTo(topView).offset(-20)
            make.height.equalTo(20)
        }
        secondaryLabel.snp.makeConstraints { (make) in
            make.top.equalTo(mainLabel.snp.bottom).offset(10)
            make.leading.equalTo(topView).offset(20)
            make.trailing.equalTo(topView).offset(-20)
            make.height.equalTo(20)
        }
        pinTextField.snp.makeConstraints { (make) in
            make.top.equalTo(secondaryLabel.snp.bottom).offset(10)
            make.width.equalTo(250)
            make.centerX.equalTo(topView)
            make.height.equalTo(60)
        }
        pinTextFieldError.snp.makeConstraints { (make) in
            make.top.equalTo(pinTextField.snp.bottom)
            make.width.equalTo(250)
            make.centerX.equalTo(topView)
            make.height.equalTo(15)
        }

        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(view).multipliedBy(0.50)
        }
        
        numPadView.snp.makeConstraints { (make) in
            make.top.equalTo(bottomView).offset(60)
            make.leading.equalTo(bottomView).offset(20)
            make.trailing.equalTo(bottomView).offset(-20)
            make.bottom.equalTo(bottomView.layoutMarginsGuide.snp.bottom)
        }
        forgotMpin.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.trailing.equalTo(bottomView).offset(-20)
            make.height.equalTo(60)
            make.bottom.equalTo(numPadView.snp.top)
        }
    }

}
