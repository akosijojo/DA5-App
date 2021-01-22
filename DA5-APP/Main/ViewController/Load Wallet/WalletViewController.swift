//
//  WalletViewController.swift
//  DA5-APP
//
//  Created by Jojo on 1/4/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

struct CashInData {
    var id : Int
    var name : String
    var image : String
}

struct SubmitCashInOutData: Decodable {
    var referenceNo : String
     
    enum CodingKeys: String, CodingKey {
       case referenceNo = "reference_no"
    }
}

class WalletViewController: BaseSecondaryViewController {
    var viewModel : LoadWalletViewModel?
    
    lazy var headerView : CustomHeaderView = {
        let v = CustomHeaderView()
        v.title.text = "Cash In"
        return v
    }()
    
    lazy var imageView : UIView = {
       let v = UIView()
       return v
    }()
    
    lazy var cashInImageView : UIImageView = {
        let v = UIImageView()
//        v.image = UIImage(named: "western")
        v.layer.cornerRadius = 10
        v.layer.masksToBounds = true
        v.clipsToBounds = true
//        v.layer.borderWidth = 1
//        v.layer.borderColor = ColorConfig().lightGray?.cgColor
        return v
    }()
    
    lazy var cashInLbl : UILabel = {
        let v = UILabel()
//        v.text = "Western Union"
        v.textAlignment = .center
        v.font = UIFont(name: Fonts.regular, size: 12)
        return v
    }()
    
    lazy var amountInput : UITextField = {
       let v = UITextField()
       v.font = UIFont(name: Fonts.medium, size: 20)
       v.addBorders(edges: .bottom, color: ColorConfig().darkGray!)
       v.textAlignment = .center
       v.text = "PHP 0.00"
//       v.addTarget(self, action: #selector(didEndEnteredAmounxt(_:)), for: .editingDidBegin)
       v.addTarget(self, action: #selector(amountEntered(_:)), for: .editingChanged)
//       v.addTarget(self, action: #selector(didEndEnteredAmount(_:)), for: .editingDidEnd)
       v.keyboardType = .numberPad
       return v
    }()
    
    lazy var amountLbl : UILabel = {
       let v = UILabel()
        v.text = "Enter desired amount"
        v.font = UIFont(name: Fonts.regular, size: 12)
        v.textAlignment = .center
       return v
    }()
    
    lazy var submitBtn : UIButton = {
       let v = UIButton()
        v.layer.cornerRadius = 5
        v.backgroundColor = ColorConfig().black
        v.setTitle("Proceed", for: .normal)
        v.titleLabel?.font = UIFont(name: Fonts.medium, size: 12)
        v.addTarget(self, action: #selector(onClickSubmit), for: .touchUpInside)
       return v
    }()
    
    var data : CashInData?
    
    var type : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorConfig().bgColor
        setUpView()
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        getData()
        
        self.hidesKeyboardOnTapArround()
    }
    
    init(data: CashInData?,type: Int?) {
        super.init(nibName: nil, bundle: nil)
        self.data = data
        self.type = type
        self.cashInImageView.image = UIImage(named: data?.image ?? "")
        self.cashInLbl.text = data?.name
        print("DATA GET \(data)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageView.layer.cornerRadius = 10
        self.cashInImageView.backgroundColor = .white
        let rect = CGRect(x: 0, y: 5, width: self.imageView.frame.width, height: self.imageView.frame.height - 5)
        self.imageView.layer.shadowPath = UIBezierPath(rect:rect).cgPath
        self.imageView.layer.shadowRadius = 4
        self.imageView.layer.shadowOffset = .zero
        self.imageView.layer.shadowOpacity = 0.2
    }
    func getData() {
        self.viewModel?.onSuccessDataRequest = { [weak self] status in
            DispatchQueue.main.async {
                self?.showAlert(buttonOK: "Ok", message: "Transaction Successful!", actionOk: { (action) in
                    self?.coordinator?.showParentView()
                }, completionHandler: nil)
            }
        }
        self.viewModel?.onErrorHandling = { [weak self] status in
            DispatchQueue.main.async {
                self?.showAlert(buttonOK: "Ok", message: status?.message ?? "Something went wrong.", actionOk: nil, completionHandler: nil)
            }
        }
    }
      
    
    override func setUpView() {
       view.addSubview(headerView)
       headerView.snp.makeConstraints { (make) in
          make.top.equalTo(view).offset(25)
          make.leading.equalTo(view).offset(20)
          make.trailing.equalTo(view).offset(-20)
          make.height.equalTo(80)
       }
       
       view.addSubview(imageView)
       imageView.snp.makeConstraints { (make) in
          make.centerY.equalTo(view).offset(-100)
          make.centerX.equalTo(view)
          make.width.equalTo(150)
          make.height.equalTo(120)
       }
        
       imageView.addSubview(cashInImageView)
       cashInImageView.snp.makeConstraints { (make) in
          make.centerY.equalTo(imageView.snp.centerY)
          make.centerX.equalTo(imageView.snp.centerX)
          make.width.equalTo(imageView)
          make.height.equalTo(imageView)
       }
    
        view.addSubview(cashInLbl)
        cashInLbl.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(20)
        }
        
        view.addSubview(amountInput)
        amountInput.snp.makeConstraints { (make) in
            make.top.equalTo(cashInLbl.snp.bottom).offset(10)
            make.leading.equalTo(view).offset(40)
            make.trailing.equalTo(view).offset(-40)
            make.height.equalTo(40)
        }
        
        amountInput.delegate = self
        
        view.addSubview(amountLbl)
        amountLbl.snp.makeConstraints { (make) in
            make.top.equalTo(amountInput.snp.bottom).offset(5)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(20)
        }
        
        view.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom).offset(-20)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(40)
        }
    }
    
    @objc func onClickSubmit() {
        if type == 0 {
            self.viewModel?.cashIn(amount: "\(self.amountInput.text?.removeStringsAmount() ?? 0)",customerId: UserLoginData.shared.id ?? 0, partnerId: "\(self.data?.id ?? 0)")
        }else {
            self.viewModel?.cashOut(amount: "\(self.amountInput.text?.removeStringsAmount() ?? 0)" ,customerId: UserLoginData.shared.id ?? 0, partnerId:  "\(self.data?.id ?? 0)")
        }
    }
    
    @objc func amountEntered(_ textField: UITextField) {
        if let amountString = amountInput.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
    @objc func didEndEnteredAmount(_ textField: UITextField){
        if let amountString = amountInput.text?.returnDecimalAmount() {
            textField.text = amountString
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "PHP 0.00" {
            amountInput.text = "PHP "
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 21
    }
}
