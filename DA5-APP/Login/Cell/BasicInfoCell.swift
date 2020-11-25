//
//  BasicInfoCell.swift
//  DA5-APP
//
//  Created by Jojo on 8/27/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit
protocol BasicInfoCellDelegate {
    func submitAction(cell: BasicInfoCell,index: Int)
}
class BasicInfoCell: BaseCollectionViewCell, UITextFieldDelegate {
    weak var vc : SignUpViewController?
    var delegate : BasicInfoCellDelegate?
    var nationalities : [String] = []
    lazy var scrollView : UIScrollView = {
        let v = UIScrollView()
        return v
    }()
    
    lazy var headerView : CustomHeaderView = {
        let v = CustomHeaderView()
        v.title.text = "Welcome!"
        v.desc.text  = "Please fill up the following fields to proceed"
        return v
    }()
    
    lazy var fname: CustomBasicFormInput = {
        let v = CustomBasicFormInput()
        v.TextField.delegate = self
        v.TextField.tag = 1
        return v
    }()
    
    lazy var mname: CustomBasicFormInput = {
        let v = CustomBasicFormInput()
        v.TextField.delegate = self
        v.TextField.tag = 2
        return v
    }()
    
    lazy var lname: CustomBasicFormInput = {
        let v = CustomBasicFormInput()
        v.TextField.delegate = self
        v.TextField.tag = 3
        return v
    }()
    
    lazy var bdate: CustomBasicFormInput = {
        let v = CustomBasicFormInput()
        v.TextField.delegate = self
        v.TextField.tag = 4
        return v
    }()
    
    lazy var gender: CustomBasicFormInput = {
        let v = CustomBasicFormInput()
        v.TextField.isUserInteractionEnabled = false
        v.TextField.tag = 5
        return v
    }()
    
    lazy var nationality: CustomBasicFormInput = {
        let v = CustomBasicFormInput()
        v.TextField.delegate = self
        v.TextField.tag = 6
        return v
    }()
    
    lazy var address: CustomBasicFormInput = {
        let v = CustomBasicFormInput()
        v.TextField.delegate = self
        v.TextField.tag = 7
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
    
    var datePicker : UIDatePicker?
    
    var data : UsersData? {
        didSet {
            
        }
    }
    
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
        scrollView.addSubview(fname)
        fname.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(25)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(70)
        }
        scrollView.addSubview(mname)
        mname.snp.makeConstraints { (make) in
            make.top.equalTo(fname.snp.bottom).offset(5)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(70)
        }
        scrollView.addSubview(lname)
        lname.snp.makeConstraints { (make) in
            make.top.equalTo(mname.snp.bottom).offset(5)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(70)
        }
        scrollView.addSubview(bdate)
        bdate.snp.makeConstraints { (make) in
            make.top.equalTo(lname.snp.bottom).offset(5)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(70)
        }
        scrollView.addSubview(gender)
        gender.snp.makeConstraints { (make) in
            make.top.equalTo(bdate.snp.bottom).offset(5)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(70)
        }
        scrollView.addSubview(nationality)
        nationality.snp.makeConstraints { (make) in
            make.top.equalTo(gender.snp.bottom).offset(5)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(70)
        }
        scrollView.addSubview(address)
        address.snp.makeConstraints { (make) in
            make.top.equalTo(nationality.snp.bottom).offset(5)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(70)
        }
        scrollView.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { (make) in
            make.top.equalTo(address.snp.bottom).offset(20)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(40)
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
        
        setUpDatePicker()
        
        
        self.submitBtn.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
//        self.gender.TextField.addTarget(self, action: #selector(showGenderPicker), for: .editingDidBegin)
        let gTap = UITapGestureRecognizer(target: self, action: #selector(showGenderPicker))
        self.gender.isUserInteractionEnabled = true
        self.gender.addGestureRecognizer(gTap)
        
    }
    
    func setUpDatePicker() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.maximumDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())
        datePicker?.addTarget(self, action: #selector(dateSelected(_:)), for: .valueChanged)
          
        bdate.TextField.inputView = datePicker
        

        let toolBar = UIToolbar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.frame.width, height: CGFloat(44))))
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action:  #selector(dismissPicker))
        toolBar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        bdate.TextField.inputAccessoryView = toolBar
     }
     @objc func dismissPicker() {
        self.endEditing(true)
     }

       
     @objc func dateSelected(_ datePicker: UIDatePicker ) {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MMM dd, yyyy"
        bdate.TextField.text = dateFormat.string(from: datePicker.date)
    //        view.endEditing(true)
     }

    @objc func submitAction() {
        self.delegate?.submitAction(cell: self, index: 1)
    }

    @objc func showGenderPicker() {
        let alert = UIAlertController(title: "Select Gender", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Male", style: .default, handler: { action in
            self.gender.TextField.text = "Male"
            self.dismissPicker()
        }))
        alert.addAction(UIAlertAction(title: "Female", style: .default, handler: { action in
            self.gender.TextField.text = "Female"
            self.dismissPicker()
        }))
        vc?.present(alert, animated: true, completion: nil)
    }
    func addShowKeyboard(offset: CGFloat) {
        scrollView.snp.updateConstraints { (make) in
           make.bottom.equalTo(self).offset(offset)
        }
        self.layoutIfNeeded()
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
     var point = CGPoint()
        switch textField.tag {
        case 1:
            point = fname.frame.origin
        case 2:
            point = mname.frame.origin
        case 3:
            point = lname.frame.origin
        case 4:
            point = bdate.frame.origin
        case 5:
            point = gender.frame.origin
        case 6:
            point = nationality.frame.origin
        case 7:
            point = address.frame.origin
        default:
            break
        }
        point.y -= 100
        self.scrollView.setContentOffset(point
            , animated: true)
    }
    
}
