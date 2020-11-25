//
//  CustomBasicFormInput.swift
//  DA5-APP
//
//  Created by Jojo on 8/27/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

class CustomBasicFormInput : UIView {
    lazy var Label : UILabel = {
        let v = UILabel()
        return v
    }()
   
    lazy var TextField : CustomTextField = {
        let v = CustomTextField()
        v.font = UIFont(name: Fonts.regular, size: 12)
        v.backgroundColor = ColorConfig().innerbgColor
        v.layer.cornerRadius = 5
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        addSubview(Label)
         Label.snp.makeConstraints { (make) in
             make.top.equalTo(self)
             make.leading.equalTo(self)
             make.trailing.equalTo(self)
             make.height.equalTo(30)
         }
         addSubview(TextField)
         TextField.snp.makeConstraints { (make) in
             make.top.equalTo(Label.snp.bottom)
             make.leading.equalTo(self)
             make.trailing.equalTo(self)
             make.height.equalTo(40)
         }
    }
}


class CustomBasicFormInput2 : UIView {
    lazy var Label : UILabel = {
        let v = UILabel()
        return v
    }()
   
    lazy var textLabel : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Fonts.regular, size: 12)
        v.backgroundColor = ColorConfig().innerbgColor
        v.layer.cornerRadius = 5
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        addSubview(Label)
         Label.snp.makeConstraints { (make) in
             make.top.equalTo(self)
             make.leading.equalTo(self)
             make.trailing.equalTo(self)
             make.height.equalTo(30)
         }
         addSubview(textLabel)
         textLabel.snp.makeConstraints { (make) in
             make.top.equalTo(Label.snp.bottom)
             make.leading.equalTo(self)
             make.trailing.equalTo(self)
             make.height.equalTo(40)
         }
    }
}
