//
//  ViewController.swift
//  DA5-APP
//
//  Created by Jojo on 8/18/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit
import ADCountryPicker

class ViewController: UIViewController {
    
    lazy var phoneNumber: CustomBasicFormInputNumber = {
       let v = CustomBasicFormInputNumber()
       v.FieldView.TextField.keyboardType = .numberPad
       v.FieldView.TextField.tag = 1
       v.FieldView.TextField.delegate = self
       return v
    }()
       
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(phoneNumber)
        phoneNumber.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.equalTo(view.frame.width - 40)
            make.height.equalTo(70)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(openPickerAction))
        phoneNumber.FieldView.phoneViewLabel.addGestureRecognizer(tap)
    }

    @objc func openPickerAction() {
            
        let picker = ADCountryPicker(style: .grouped)
        // delegate
        picker.delegate = self
        picker.searchBarBackgroundColor = UIColor.white

        // Display calling codes
        picker.showCallingCodes = true

        // or closure
        picker.didSelectCountryClosure = { name, code in
            _ = picker.navigationController?.popToRootViewController(animated: true)
            print(code)
        }
        
        
//        Use this below code to present the picker
        
        let pickerNavigationController = UINavigationController(rootViewController: picker)
        self.present(pickerNavigationController, animated: true, completion: nil)

            
    //        navigationController?.pushViewController(picker, animated: true)
    }

}

extension ViewController: ADCountryPickerDelegate {
    
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        _ = picker.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
//        countryNameLabel.text = name
//        countryCodeLabel.text = code
//        countryCallingCodeLabel.text = dialCode
        
       let x =  picker.getFlag(countryCode: code)
        let xx =  picker.getCountryName(countryCode: code)
        let xxx =  picker.getDialCode(countryCode: code)
        
        self.phoneNumber.FieldView.phoneViewLabel.flag.image = x
        self.phoneNumber.FieldView.phoneViewLabel.country.text = code
        self.phoneNumber.FieldView.phoneViewLabel.Label.text = xxx
        
       
    }
}

