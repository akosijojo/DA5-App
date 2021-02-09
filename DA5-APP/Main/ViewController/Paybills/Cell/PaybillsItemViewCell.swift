//
//  PaybillsItemViewCell.swift
//  DA5-APP
//
//  Created by Jojo on 1/31/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

protocol PaybillsItemViewCellDelegate : class {
    func onClickDropDown(cell: PaybillsItemViewCell, data: MetaData? , index: Int?)
}

class PaybillsItemViewCell: UICollectionViewCell{
    
    var delegate : PaybillsItemViewCellDelegate?
    
    var index: Int? = 0
    
    var dataDropDown : DropItem? {
        didSet {
            self.textField.TextField.text = dataDropDown?.key
        }
    }
    
    var data : MetaData? {
        didSet {
            self.setUpTextfield(data: data)
        }
    }
    
    lazy var textField: CustomBasicFormInput = {
        let v = CustomBasicFormInput()
        v.Label.text = ""
        v.Label.font = UIFont(name: Fonts.regular, size: 12)
        v.Label.numberOfLines = 0
//        v.TextField.keyboardType = .numberPad // dynamic
//        v.TextField.tag = 1
        v.TextField.placeholder = ""
        v.TextField.font = UIFont(name: Fonts.regular, size: 12)
        return v
    }()
    
    var datePicker : UIDatePicker?
    
    let dateFormat = DateFormatter()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        textField.TextField.delegate = self
    }
    
    func setUpTextfield(data: MetaData?) {
        
        let asteriskAttributes = NSAttributedString(string: " *", attributes: [.font:  UIFont(name: Fonts.bold, size: 14)!, .foregroundColor : ColorConfig().blue!])
              
        let lblAttributes = NSMutableAttributedString(string: data?.label ?? "", attributes: [NSAttributedString.Key.font : UIFont(name: Fonts.bold, size: 12)!])
        
        if data?.isRequired == IsRequired.bool(true) {
            lblAttributes.append(asteriskAttributes)
        }
        
        textField.Label.attributedText = lblAttributes

        let textHeight = data?.label?.heightForView(font: textField.Label.font, width: self.frame.width - 40) ?? 0
        
        textField.updateLabelHeight(height: textHeight > 29 ? 60 : 30)
        
        //MARK: - add case for action = dropdown, date field , mobile number etc

        switch data?.type {
        case .dropdown:
            let tapDropDown = UITapGestureRecognizer(target: self, action: #selector(dropdownAction))
            self.textField.TextField.addGestureRecognizer(tapDropDown)
        case .number:
            textField.TextField.keyboardType = .decimalPad
        case .calendar:
            dateFormat.dateFormat = "MMM dd, yyyy"
            textField.TextField.tag = 1
            setUpDatePicker()
        case .text:
            textField.TextField.keyboardType = .default
        case .mobilenumber:
            // setup limit of phone number
            textField.TextField.keyboardType = .numberPad
        case .month:
            setUpDatePicker()
        case .year:
            setUpDatePicker()
        default:
            break;
        }
        
       
        
    }
    
    @objc func dropdownAction() {
        self.delegate?.onClickDropDown(cell: self, data: self.data, index: index)
    }
    
    func setUpPicker(type: Int) {
        if type == 1 {
            //MARK: - month
            
        }else {
            //MARK: - year
        }
    }
    
    func setUpDatePicker() {
          datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
          datePicker?.maximumDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())
          datePicker?.addTarget(self, action: #selector(dateSelected(_:)), for: .valueChanged)
          
          textField.TextField.inputView = datePicker
          

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

          textField.TextField.inputAccessoryView = toolBar
    }
    
    @objc func dismissPicker() {
         self.endEditing(true)
    }
    
    @objc func selectBDate() {
         self.endEditing(true)
    }
    
    @objc func dateSelected(_ datePicker: UIDatePicker ) {
          textField.TextField.text = dateFormat.string(from: datePicker.date)
      //        view.endEditing(true)
    }
    
}

extension PaybillsItemViewCell : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        guard let charactersCount = textField.text?.count else { return false }
         if let maxLength = self.data?.maxLength {
            if maxLength > 0{
                return charactersCount < maxLength || string == ""
            }
        }
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //MARK: - 1 == date
        if textField.tag == 1 {
            if self.textField.TextField.text == "" {
                  let formatter = DateFormatter()
                  formatter.dateFormat = "MMM dd, YYYY"
                  self.textField.TextField.text = formatter.string(from: Calendar.current.date(byAdding: .year, value: 0, to: Date()) ?? Date())
              }
        }
    }
    
}

