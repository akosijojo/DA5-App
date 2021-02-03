//
//  BasicInfoCell.swift
//  DA5-APP
//
//  Created by Jojo on 8/27/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit
protocol BasicInfoCellDelegate {
    func submitAction(cell: BasicInfoCell,index: Int, fields: [UITextField],form: RegistrationForm?)
}
class BasicInfoCell: BaseCollectionViewCell, UITextFieldDelegate {
    weak var vc : SignUpViewController?
    var delegate : BasicInfoCellDelegate?
    var nationalities : [String] = []
    var textFields : [UITextField] = []
    var isBdateSelected: Bool = false
    let dateFormat = DateFormatter()
    
    var data : RegistrationForm? {
        didSet {
            print("DID GET DATA")
            if data?.fname != nil && data?.lname != nil {
                self.fname.TextField.text = data?.fname
                self.lname.TextField.text = data?.lname
            }
        }
    }
    
    lazy var scrollView : UIScrollView = {
        let v = UIScrollView()
        return v
    }()
    
    lazy var headerView : CustomHeaderView = {
        let v = CustomHeaderView()
        v.title.text = "Welcome!"
        v.desc.text  = "Please fill up the following fields to proceed. \nOnly provide information that is true and correct as this will be validated for KYC."
        v.desc.numberOfLines = 0
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
        v.TextField.isUserInteractionEnabled = true
        return v
    }()
    
    lazy var address: CustomBasicFormInput = {
        let v = CustomBasicFormInput()
        v.TextField.delegate = self
        v.TextField.tag = 7
        return v
    }()
    
    lazy var city: CustomBasicFormInput = {
        let v = CustomBasicFormInput()
        v.TextField.delegate = self
        v.TextField.tag = 8
        return v
    }()
    
    lazy var province: CustomBasicFormInput = {
        let v = CustomBasicFormInput()
        v.TextField.delegate = self
        v.TextField.tag = 9
        return v
    }()
    
    lazy var zipCode: CustomBasicFormInput = {
        let v = CustomBasicFormInput()
        v.TextField.delegate = self
        v.TextField.tag = 0
        v.TextField.keyboardType = .numberPad
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
            make.height.equalTo(100)
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
        scrollView.addSubview(city)
        city.snp.makeConstraints { (make) in
            make.top.equalTo(address.snp.bottom).offset(5)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(70)
        }
        scrollView.addSubview(province)
        province.snp.makeConstraints { (make) in
            make.top.equalTo(city.snp.bottom).offset(5)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(70)
        }
        scrollView.addSubview(zipCode)
        zipCode.snp.makeConstraints { (make) in
            make.top.equalTo(province.snp.bottom).offset(5)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(70)
        }
        scrollView.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { (make) in
            make.top.equalTo(zipCode.snp.bottom).offset(20)
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
        
        let cityAttributes = NSMutableAttributedString(string: "City/Municipality ", attributes: [NSAttributedString.Key.font : UIFont(name: Fonts.bold, size: 12)!])
        
        let provinceAttributes = NSMutableAttributedString(string: "Province ", attributes: [NSAttributedString.Key.font : UIFont(name: Fonts.bold, size: 12)!])
        
        let zipCodeAttributes = NSMutableAttributedString(string: "Zip Code ", attributes: [NSAttributedString.Key.font : UIFont(name: Fonts.bold, size: 12)!])
        
        fnameAttributes.append(asteriskAttributes)
        lnameAttributes.append(asteriskAttributes)
        bdateAttributes.append(asteriskAttributes)
        genderAttributes.append(asteriskAttributes)
        nationalityAttributes.append(asteriskAttributes)
        addressAttributes.append(asteriskAttributes)
        cityAttributes.append(asteriskAttributes)
        provinceAttributes.append(asteriskAttributes)
        zipCodeAttributes.append(asteriskAttributes)
        
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
        city.Label.attributedText = cityAttributes
        city.TextField.placeholder = "City/Municipality"
        province.Label.attributedText = provinceAttributes
        province.TextField.placeholder = "Province"
        zipCode.Label.attributedText = zipCodeAttributes
        zipCode.TextField.placeholder = "Zip Code"
        
        setUpDatePicker()
        
        dateFormat.dateFormat = "MMM dd, yyyy"
        
        
        self.submitBtn.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
//        self.gender.TextField.addTarget(self, action: #selector(showGenderPicker), for: .editingDidBegin)
        let gTap = UITapGestureRecognizer(target: self, action: #selector(showGenderPicker))
        self.gender.isUserInteractionEnabled = true
        self.gender.addGestureRecognizer(gTap)
        
        let tapNationality = UITapGestureRecognizer(target: self, action: #selector(showNationality))
        self.nationality.TextField.addGestureRecognizer(tapNationality)
        
    // for checking empty value
        textFields = [
                  fname.TextField,
                  lname.TextField,
                  bdate.TextField,
                  gender.TextField,
                  nationality.TextField,
                  address.TextField,
                  city.TextField,
                  province.TextField,
                  zipCode.TextField
              ]
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

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(selectBDate))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action:  #selector(dismissPicker))
        toolBar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        bdate.TextField.inputAccessoryView = toolBar
     }
     @objc func dismissPicker() {
        self.endEditing(true)
     }
     @objc func selectBDate() {
        self.endEditing(true)
     }

       
     @objc func dateSelected(_ datePicker: UIDatePicker ) {
        bdate.TextField.text = dateFormat.string(from: datePicker.date)
    //        view.endEditing(true)
     }
    
    @objc func showNationality() {
        vc?.showNationalities()
    }

    @objc func submitAction() {
        self.delegate?.submitAction(cell: self, index: 1, fields: textFields, form: setUpFormData())
    }
    
    func setUpFormData() -> RegistrationForm {
        return RegistrationForm(fname: fname.TextField.text, mname: mname.TextField.text, lname: lname.TextField.text, bdate: bdate.TextField.text?.formatDate(dateFormat: "MMM dd, yyyy", format: "YYYY-MM-DD"), gender: gender.TextField.text, nationality: nationality.TextField.text, address: address.TextField.text, city: city.TextField.text, province: province.TextField.text, zipcode: zipCode.TextField.text, phoneNumber: nil, email: data?.email, password: data?.password, validId: data?.validId, selfieId: data?.selfieId,fbId: data?.fbId)
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
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = gender
            popoverController.sourceRect = CGRect(x: gender.bounds.midX, y: 0, width: 120, height: 100)
//            popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
        }
        vc?.present(alert, animated: true, completion: nil)
    }
    
    func addShowKeyboard(offset: CGFloat) {
        scrollView.snp.updateConstraints { (make) in
           make.bottom.equalTo(self).offset(offset)
        }
        self.layoutIfNeeded()
        
        if offset == 0 {
             if isBdateSelected {
                guard let bDay = dateFormat.date(from: bdate.TextField.text ?? "") else {
                    return
                }
                let bDayStat = vc?.birthDateChecker(bDay: bDay)
                isBdateSelected = false
             }
        }
       
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
            isBdateSelected = true
            point = bdate.frame.origin
            if bdate.TextField.text == "" {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM dd, YYYY"
                bdate.TextField.text = formatter.string(from: Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date())
            }
        case 5:
            point = gender.frame.origin
        case 6:
            point = nationality.frame.origin
        case 7:
            point = address.frame.origin
        case 8:
            point = city.frame.origin
        case 9:
            point = province.frame.origin
        case 0:
            point = zipCode.frame.origin
        default:
            break
        }
        point.y -= 100
        self.scrollView.setContentOffset(point
            , animated: true)
    }
    
}
