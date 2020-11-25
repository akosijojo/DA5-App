//
//  CustomNumPad.swift
//  DA5-APP
//
//  Created by Jojo on 11/19/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit
class CustomNumPad : UIView {
    var numPadReturnOutput : ((String) -> Void)?
    var numPadOutput : String = ""{
        didSet{
            self.numPadReturnOutput?(self.numPadOutput)
        }
    }
    var maxInput : Int = 0
    lazy var btn1 : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(ColorConfig().black, for: .normal)
        btn.setTitle("1", for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.medium, size: 20)
        btn.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        btn.tag = 1
        return btn
    }()
    
    lazy var btn2 : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(ColorConfig().black, for: .normal)
        btn.setTitle("2", for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.medium, size: 20)
        btn.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        btn.tag = 2
        return btn
    }()
    
    lazy var btn3 : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(ColorConfig().black, for: .normal)
        btn.setTitle("3", for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.medium, size: 20)
        btn.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        btn.tag = 3
        return btn
    }()
    
    lazy var btn4 : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(ColorConfig().black, for: .normal)
        btn.setTitle("4", for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.medium, size: 20)
        btn.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        btn.tag = 4
        return btn
    }()
    
    lazy var btn5 : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(ColorConfig().black, for: .normal)
        btn.setTitle("5", for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.medium, size: 20)
        btn.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        btn.tag = 5
        return btn
    }()
    
    lazy var btn6 : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(ColorConfig().black, for: .normal)
        btn.setTitle("6", for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.medium, size: 20)
        btn.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        btn.tag = 6
        return btn
    }()
    
    lazy var btn7 : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(ColorConfig().black, for: .normal)
        btn.setTitle("7", for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.medium, size: 20)
        btn.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        btn.tag = 7
        return btn
    }()
    
    lazy var btn8 : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(ColorConfig().black, for: .normal)
        btn.setTitle("8", for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.medium, size: 20)
        btn.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        btn.tag = 8
        return btn
    }()
    
    lazy var btn9 : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(ColorConfig().black, for: .normal)
        btn.setTitle("9", for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.medium, size: 20)
        btn.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        btn.tag = 9
        return btn
    }()
    
    lazy var btn0 : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(ColorConfig().black, for: .normal)
        btn.setTitle("0", for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.medium, size: 20)
        btn.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        btn.tag = 0
        return btn
    }()
    
    lazy var btnDel : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(ColorConfig().black, for: .normal)
        btn.setImage(UIImage(named: "backspace"), for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.regular, size: 16)
        btn.addTarget(self, action: #selector(onClickDelButton(_:)), for: .touchUpInside)
        btn.tag = 15
        return btn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        
        // 1st layer
        addSubview(btn1)
        btn1.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.33)
            make.height.equalTo(self).multipliedBy(0.25)
        }
        addSubview(btn2)
        btn2.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.centerX.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.33)
            make.height.equalTo(self).multipliedBy(0.25)
        }
        addSubview(btn3)
        btn3.snp.makeConstraints { (make) in
           make.top.equalTo(self)
           make.trailing.equalTo(self)
           make.width.equalTo(self).multipliedBy(0.33)
           make.height.equalTo(self).multipliedBy(0.25)
       }
            // 2nd layer
           addSubview(btn4)
           btn4.snp.makeConstraints { (make) in
            make.top.equalTo(btn1.snp.bottom)
               make.leading.equalTo(self)
               make.width.equalTo(self).multipliedBy(0.33)
               make.height.equalTo(self).multipliedBy(0.25)
           }
           addSubview(btn5)
           btn5.snp.makeConstraints { (make) in
               make.top.equalTo(btn2.snp.bottom)
               make.centerX.equalTo(self)
               make.width.equalTo(self).multipliedBy(0.33)
               make.height.equalTo(self).multipliedBy(0.25)
           }
           addSubview(btn6)
           btn6.snp.makeConstraints { (make) in
              make.top.equalTo(btn3.snp.bottom)
              make.trailing.equalTo(self)
              make.width.equalTo(self).multipliedBy(0.33)
              make.height.equalTo(self).multipliedBy(0.25)
          }
            // 3rd layer
             addSubview(btn7)
             btn7.snp.makeConstraints { (make) in
                 make.top.equalTo(btn4.snp.bottom)
                 make.leading.equalTo(self)
                 make.width.equalTo(self).multipliedBy(0.33)
                 make.height.equalTo(self).multipliedBy(0.25)
             }
             addSubview(btn8)
             btn8.snp.makeConstraints { (make) in
                 make.top.equalTo(btn5.snp.bottom)
                 make.centerX.equalTo(self)
                 make.width.equalTo(self).multipliedBy(0.33)
                 make.height.equalTo(self).multipliedBy(0.25)
             }
             addSubview(btn9)
             btn9.snp.makeConstraints { (make) in
                make.top.equalTo(btn6.snp.bottom)
                make.trailing.equalTo(self)
                make.width.equalTo(self).multipliedBy(0.33)
                make.height.equalTo(self).multipliedBy(0.25)
            }
                // 4th layer

                 addSubview(btnDel)
                 btnDel.snp.makeConstraints { (make) in
                    make.top.equalTo(btn9.snp.bottom)
                    make.trailing.equalTo(self)
                    make.width.equalTo(self).multipliedBy(0.33)
                    make.height.equalTo(self).multipliedBy(0.25)
                }
                 addSubview(btn0)
                 btn0.snp.makeConstraints { (make) in
                     make.top.equalTo(btn8.snp.bottom)
                     make.centerX.equalTo(self)
                     make.width.equalTo(self).multipliedBy(0.33)
                     make.height.equalTo(self).multipliedBy(0.25)
                 }
        
    }
    
    @objc func onClickButton(_ btn:UIButton) {
        if maxInput > numPadOutput.count {
            numPadOutput = (numPadOutput) + String(describing: btn.tag)
        }
    }
    @objc func onClickDelButton(_ btn:UIButton) {
        if numPadOutput.count > 0 {
            numPadOutput.removeLast()
        }
    }
    
}

