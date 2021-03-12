//
//  CustomBasicFormInput.swift
//  DA5-APP
//
//  Created by Jojo on 8/27/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit
import ADCountryPicker

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
    
    lazy var imageViewR : UIImageView = {
        let i = UIImageView()
        i.isUserInteractionEnabled = true
        return i
    }()
    
    var isSecure : Bool = false
    
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
    
    func showRightImageView() {
        TextField.clearButtonMode = .never
        TextField.addSubview(imageViewR)
        imageViewR.snp.makeConstraints { (make) in
            make.trailing.equalTo(TextField).offset(-10)
            make.centerY.equalTo(TextField)
            make.width.height.equalTo(20)
        }
        TextField.padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 30)
    }
    
    func removeLblHeight() {
        Label.snp.updateConstraints { (make) in
            make.height.equalTo(0)
        }
    }
    
    func updateLabelHeight(height: CGFloat) {
//        print("HEIGHT : \(height)")
        if height > 30 {
            Label.snp.updateConstraints { (make) in
                make.height.equalTo(height)
            }
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

class CustomBasicFormInputPassword : UIView {
    lazy var TextField : CustomTextField = {
        let v = CustomTextField()
        v.font = UIFont(name: Fonts.regular, size: 12)
        v.backgroundColor = ColorConfig().innerbgColor
        v.layer.cornerRadius = 5
        return v
    }()
    
    lazy var imageViewR : UIImageView = {
        let i = UIImageView()
        i.isUserInteractionEnabled = true
        return i
    }()
    
    var isSecure : Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
         addSubview(TextField)
         TextField.snp.makeConstraints { (make) in
             make.top.equalTo(self)
             make.leading.equalTo(self)
             make.trailing.equalTo(self)
             make.height.equalTo(40)
         }
    }
    
    func showRightImageView() {
        TextField.clearButtonMode = .never
        TextField.addSubview(imageViewR)
        imageViewR.snp.makeConstraints { (make) in
            make.trailing.equalTo(TextField).offset(-10)
            make.centerY.equalTo(TextField)
            make.width.height.equalTo(20)
        }
        TextField.padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 30)
    }
}

class CustomBasicFormInputNumber : UIView {
    lazy var Label : UILabel = {
        let v = UILabel()
        return v
    }()
   
    lazy var FieldView : CustomMobileNumberField = {
        let v = CustomMobileNumberField()
        v.phoneViewLabel.Label.font = UIFont(name: Fonts.regular, size: 12)
        v.TextField.font = UIFont(name: Fonts.regular, size: 12)
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
         addSubview(FieldView)
         FieldView.snp.makeConstraints { (make) in
             make.top.equalTo(Label.snp.bottom)
             make.leading.equalTo(self)
             make.trailing.equalTo(self)
             make.height.equalTo(40)
         }
    }
    
    func removeLblHeight() {
        Label.snp.updateConstraints { (make) in
            make.height.equalTo(0)
        }
    }
    
}


class CustomBasicAmountInput : UIView , UITextFieldDelegate{
    lazy var Label : UILabel = {
       let v = UILabel()
        v.text = ""
        v.textAlignment = .center
       return v
    }()
  
    lazy var amount : CustomTextField = {
        let v = CustomTextField()
        v.font = UIFont(name: Fonts.regular, size: 12)
        v.layer.cornerRadius = 5
        return v
    }()

    lazy var decimal : CustomTextField = {
       let v = CustomTextField()
       v.font = UIFont(name: Fonts.regular, size: 12)
       v.layer.cornerRadius = 5
       return v
    }()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        self.backgroundColor = ColorConfig().innerbgColor
        self.Label.addBorders(edges: .right, color: ColorConfig().lightGray!)
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func setUpView() {
        addSubview(Label)
        Label.snp.makeConstraints { (make) in
             make.top.equalTo(self).offset(10)
             make.leading.equalTo(self)
             make.width.equalTo(70)
             make.bottom.equalTo(self).offset(-10)
         }
        
         addSubview(amount)
         amount.snp.makeConstraints { (make) in
             make.top.equalTo(self)
             make.leading.equalTo(Label.snp.trailing)
             make.trailing.equalTo(self)
             make.bottom.equalTo(self)
         }
    }
    
    func removeBorder() {
        self.Label.addBorders(edges: .right, color: ColorConfig().innerbgColor!)
    }
}

class CustomMobileNumberField : UIView {
    lazy var phoneViewLabel : phoneFlagView = {
       let v = phoneFlagView()
        v.Label.font = UIFont(name: Fonts.medium, size: 12)
        v.country.font = UIFont(name: Fonts.medium, size: 12)
       return v
    }()
    
    lazy var TextField : CustomTextField = {
        let v = CustomTextField()
        v.font = UIFont(name: Fonts.regular, size: 12)
        v.layer.cornerRadius = 5
        return v
    }()
    
    lazy var imageViewR : UIImageView = {
        let i = UIImageView()
        i.isUserInteractionEnabled = true
        return i
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        self.backgroundColor = ColorConfig().innerbgColor
        self.phoneViewLabel.Label.addBorders(edges: .right, color: ColorConfig().lightGray!)
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func setUpView() {
        addSubview(phoneViewLabel)
        phoneViewLabel.snp.makeConstraints { (make) in
             make.top.equalTo(self)
             make.leading.equalTo(self)
             make.width.equalTo(140)  //WIDTH OF ITEMS 30 + 30 + 50  plus offset 10 + 5 + 5 + 10
             make.bottom.equalTo(self)
         }
         addSubview(TextField)
         TextField.snp.makeConstraints { (make) in
             make.top.equalTo(self)
             make.leading.equalTo(phoneViewLabel.snp.trailing)
             make.trailing.equalTo(self)
             make.bottom.equalTo(self)
         }
    }
    
    func showRightImageView() {
         TextField.clearButtonMode = .never
         TextField.addSubview(imageViewR)
         imageViewR.snp.makeConstraints { (make) in
             make.trailing.equalTo(TextField).offset(-10)
             make.centerY.equalTo(TextField)
             make.width.height.equalTo(20)
         }
         TextField.padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 30)
     }
    
    func removeBorder() {
        self.phoneViewLabel.Label.addBorders(edges: .right, color: ColorConfig().innerbgColor!)
    }
    
    func hideFlagAndCountry() {
        self.phoneViewLabel.hideFlagAndCountry()
        phoneViewLabel.snp.remakeConstraints { (make) in
             make.top.equalTo(self)
             make.leading.equalTo(self)
             make.width.equalTo(70) // width 50  plus offset 10 + 10
             make.bottom.equalTo(self)
         }
    }
}

class phoneFlagView: UIView {
    lazy var flag : UIImageView = {
        let v = UIImageView()
        v.backgroundColor = .white
        return v
     }()
     
     lazy var country : UILabel = {
        let v = UILabel()
         v.text = "PH"
         v.textAlignment = .center
        return v
     }()
     
     lazy var Label : UILabel = {
        let v = UILabel()
         v.text = "+63"
         v.textAlignment = .left
        return v
     }()
    
    override init(frame: CGRect) {
       super.init(frame: frame)
       setUpView()
        flag.image = ADCountryPicker().getFlag(countryCode: "PH")
    }

    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }

    func setUpView() {
       addSubview(flag)
       flag.snp.makeConstraints { (make) in
           make.top.equalTo(self).offset(10)
           make.leading.equalTo(self).offset(10)
           make.width.equalTo(30)
           make.bottom.equalTo(self).offset(-10)
       }
       addSubview(country)
       country.snp.makeConstraints { (make) in
           make.top.equalTo(self).offset(10)
           make.leading.equalTo(flag.snp.trailing).offset(5)
           make.width.equalTo(30)
           make.bottom.equalTo(self).offset(-10)
       }
       addSubview(Label)
       Label.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.leading.equalTo(country.snp.trailing).offset(5)
            make.width.equalTo(50)
            make.bottom.equalTo(self).offset(-10)
        }
    }
    
    func hideFlagAndCountry() {
        flag.snp.remakeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.leading.equalTo(self).offset(0)
            make.width.equalTo(0)
            make.bottom.equalTo(self).offset(-10)
        }
        country.snp.remakeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.leading.equalTo(flag.snp.trailing).offset(0)
            make.width.equalTo(0)
            make.bottom.equalTo(self).offset(-10)
        }
        Label.snp.remakeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.leading.equalTo(country.snp.trailing).offset(10)
            make.width.equalTo(50)
            make.bottom.equalTo(self).offset(-10)
        }
        Label.textAlignment = .center
    }
    
}

extension UIView {
    func addBorders(edges: UIRectEdge,
                color: UIColor,
                inset: CGFloat = 0.0,
                thickness: CGFloat = 1.0) -> [UIView] {

        var borders = [UIView]()

        @discardableResult
        func addBorder(formats: String...) -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            addSubview(border)
            addConstraints(formats.flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0,
                                               options: [],
                                               metrics: ["inset": inset, "thickness": thickness],
                                               views: ["border": border]) })
            borders.append(border)
            return border
        }


        if edges.contains(.top) || edges.contains(.all) {
            addBorder(formats: "V:|-0-[border(==thickness)]", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.bottom) || edges.contains(.all) {
            addBorder(formats: "V:[border(==thickness)]-0-|", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.left) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:|-0-[border(==thickness)]")
        }

        if edges.contains(.right) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:[border(==thickness)]-0-|")
        }

        return borders
    }
    
}

