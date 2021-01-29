//
//  PaybillsSelectedItemViewController.swift
//  DA5-APP
//
//  Created by Jojo on 1/28/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

class PaybillsSelectedItemViewController: BaseHomeViewControler {
    
    var viewModel : PaybillsViewModel?
    
    lazy var headerView : CustomHeaderView = {
        let v = CustomHeaderView()
        v.title.text = ""
        v.desc.text = ""
        return v
    }()

//    lazy var policyNumber: CustomBasicFormInput = {
//        let v = CustomBasicFormInput()
//        v.Label.text = "Policy Number"
//        v.Label.font = UIFont(name: Fonts.regular, size: 12)
//        v.TextField.keyboardType = .numberPad
//        v.TextField.tag = 1
//        v.TextField.placeholder = ""
//        v.TextField.delegate = self
//        v.TextField.font = UIFont(name: Fonts.regular, size: 12)
//        return v
//    }()
//
//    lazy var amount: CustomBasicFormInput = {
//        let v = CustomBasicFormInput()
//        v.Label.text = "Amount"
//        v.Label.font = UIFont(name: Fonts.regular, size: 12)
//        v.TextField.keyboardType = .decimalPad
//        v.TextField.tag = 2
//        v.TextField.placeholder = ""
//        v.TextField.delegate = self
//        v.TextField.font = UIFont(name: Fonts.regular, size: 12)
//        return v
//    }()
//
//     lazy var date: CustomBasicFormInput = {
//         let v = CustomBasicFormInput()
//         v.Label.text = "Due Date"
//         v.Label.font = UIFont(name: Fonts.regular, size: 12)
//         v.TextField.keyboardType = .decimalPad
//         v.TextField.tag = 3
//         v.TextField.placeholder = ""
//         v.TextField.delegate = self
//         v.TextField.font = UIFont(name: Fonts.regular, size: 12)
//         return v
//     }()

    let cellId = "itemCellId"
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.bounces = false
        v.showsHorizontalScrollIndicator = false
        v.backgroundColor = ColorConfig().white
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
    
    var data : BillerData? {
        didSet {
//            self.collectionView.reloadData()
            print("GET DATA : \(data)")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesKeyboardOnTapArround()
        setUpView()
        setUpData()
    }
    
    init(data: BillerData) {
        super.init(nibName: nil, bundle: nil)
        // set up initial data to view
        print("DATA GET : \(data)")
        self.data = data
        self.headerView.title.text = data.name
        self.headerView.desc.text = data.type
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpNavigationBar()
    }
    
    override func setUpData() {
//        self.viewModel?.onSuccessDataRequest = { [weak self] data in
//            DispatchQueue.main.async {
//                self?.stopAnimating()
//            }
//        }
//
//        self.viewModel?.onSuccessRequest = { [weak self] data in
//            DispatchQueue.main.async {
//                self?.stopAnimating()
//                self?.showAlert(buttonOK: "Ok", message: data?.title ?? "Something went wrong.", actionOk: { (action) in
//                    self?.coordinator?.showParentView()
//                }, completionHandler: nil)
//            }
//        }
//
//        self.viewModel?.onErrorHandling = { [weak self] status in
//            DispatchQueue.main.async {
//                self?.stopAnimating()
//                self?.showAlert(buttonOK: "Ok", message: status?.message ?? "Something went wrong", actionOk: nil, completionHandler: nil)
//            }
//        }
    }
    
    override func setUpView() {
        view.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
           make.top.equalTo(view).offset(25)
           make.leading.equalTo(view).offset(20)
           make.trailing.equalTo(view).offset(-20)
           make.height.equalTo(80)
        }
        
//        view.addSubview(policyNumberLbl)
//        policyNumberLbl.snp.makeConstraints { (make) in
//          make.top.equalTo(headerView).offset(100)
//          make.leading.equalTo(view).offset(20)
//          make.trailing.equalTo(view).offset(-20)
//          make.height.equalTo(20)
//        }
        
//        view.addSubview(policyNumber)
//        policyNumber.snp.makeConstraints { (make) in
//            make.top.equalTo(headerView.snp.bottom).offset(10)
//            make.leading.equalTo(view).offset(20)
//            make.trailing.equalTo(view).offset(-20)
//            make.height.equalTo(70)
//        }
////
////        view.addSubview(amountLbl)
////        amountLbl.snp.makeConstraints { (make) in
////            make.top.equalTo(policyNumber.snp.bottom).offset(5)
////            make.leading.equalTo(view).offset(20)
////            make.trailing.equalTo(view).offset(-20)
////            make.height.equalTo(20)
////        }
////
//        view.addSubview(amount)
//        amount.snp.makeConstraints { (make) in
//            make.top.equalTo(policyNumber.snp.bottom).offset(5)
//            make.leading.equalTo(view).offset(20)
//            make.trailing.equalTo(view).offset(-20)
//            make.height.equalTo(70)
//        }
//
////        view.addSubview(dateLbl)
////       dateLbl.snp.makeConstraints { (make) in
////           make.top.equalTo(amount.snp.bottom).offset(5)
////           make.leading.equalTo(view).offset(20)
////           make.trailing.equalTo(view).offset(-20)
////           make.height.equalTo(20)
////       }
//
//       view.addSubview(date)
//       date.snp.makeConstraints { (make) in
//           make.top.equalTo(amount.snp.bottom).offset(5)
//           make.leading.equalTo(view).offset(20)
//           make.trailing.equalTo(view).offset(-20)
//           make.height.equalTo(70)
//       }

        
        view.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom).offset(-20)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(40)
        }

    }
    
//    @objc func amountChanged(_ textField: UITextField) {
//        if let amountString = amount.FieldView.TextField.text?.amountEntered() {
//           textField.text = amountString
//        }
//    }
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField.tag == 2 {
//            textField.text = textField.text?.replacingOccurrences(of: ",", with: "")
//        }
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        print("CHANGING INPUT")
//         guard let text = textField.text else { return true }
//         if textField.tag == 1 {
//            let count = text.count + string.count - range.length
//            return count <= 10
//         } else if textField.tag == 2 {
//            return self.amountFormating(textField: textField, string: string)
//         }else {
//            return true
//         }
//    }
//
//    //MARK:- RESTRICTIONS
//    func amountFormating(textField: UITextField,string: String) -> Bool{
//        switch string {
//         case "0","1","2","3","4","5","6","7","8","9":
//             if (textField.text?.first == "0") {
//               return false
//             }
//             return true
//         case ".":
//           var decimalCount : Int = 0
//           let array = Array(arrayLiteral: textField.text)
//             for character in array {
//               print("CHANGING INPUT HEREEEE ARRAY = \(array.count) == \(character)" )
//               if character?.contains(".") ??  false{
//                   print("CHANGING INPUT HEREEEE ARRAY INPUT . = \(decimalCount)" )
//                     decimalCount += 1
//                 }
//             }
//             print("CHANGING INPUT HEREEEE = \(decimalCount)" )
//
//             if decimalCount >= 1 {
//                 return false
//             } else {
//                 return true
//             }
//         default:
//             let array = Array(string)
//             if array.count == 0 {
//                 return true
//             }
//             return false
//         }
//    }
    
    @objc func submitAction() {
//        if let number = self.phoneNumber.FieldView.TextField.text, let amount = self.amount.FieldView.TextField.text , number != "" && amount.returnAmount() >= 1{
//             self.setAnimate(msg: "Please wait")
//            self.viewModel?.sendMoney(amount: "\(amount.returnAmount() ?? 0)",customerId: UserLoginData.shared.id ?? 0, phone: number)
//        }else {
//            let phone = self.phoneNumber.FieldView.TextField.text
//            self.showAlert(buttonOK: "Ok", message: phone == "" ? "Phone number is invalid." : "Please enter your desired amount for trasfer.", actionOk: nil, completionHandler: nil)
//        }
       
    }
    
}
