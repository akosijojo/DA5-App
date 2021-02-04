//
//  FXViewController.swift
//  DA5-APP
//
//  Created by Jojo on 1/16/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

class FXViewController: BaseHomeViewControler {
    var selectedCurrency : String = "USD" {
        didSet {
            print("Selected ON Drop")
            self.convertInput.dropView.text = selectedCurrency
            self.viewModel?.getCurrency(base: selectedCurrency)
        }
    }
    var userBalance : String?
    var currencyList : CurrencyList? {
        didSet {
            self.conversionLbl.text = "Conversion Rate: \(self.currencyList?.rates?["PHP"] ?? 0.00)"
            self.convertAmountEntered(text: userBalance ?? "0")
        }
    }
    
    lazy var balance : UILabel = {
       let v = UILabel()
        v.font = UIFont(name: Fonts.medium, size: 20)
        v.textAlignment = .center
       return v
    }()
    
    lazy var balanceLbl : UILabel = {
      let v = UILabel()
       v.text = "Wallet Balance"
       v.font = UIFont(name: Fonts.medium, size: 14)
       v.textAlignment = .center
      return v
    }()
    
    lazy var amountInput : UITextField = {
      let v = UITextField()
      v.font = UIFont(name: Fonts.medium, size: 24)
      v.addBorders(edges: .bottom, color: ColorConfig().darkGray!)
      v.textAlignment = .center
          v.addTarget(self, action: #selector(amountEntered(_:)), for: .editingChanged)
      v.keyboardType = .numberPad
      return v
    }()
    
    lazy var exchangeIcon : UIImageView = {
         let v = UIImageView()
        v.image = UIImage(named: "exchange-arrow")?.withRenderingMode(.alwaysTemplate)
        v.tintColor = ColorConfig().lightGray
         return v
    }()
    
    lazy var convertInput : ConversionField = {
        let v = ConversionField()
        v.conversionRate.font = UIFont(name: Fonts.medium, size: 24)
        return v
    }()
    
    lazy var conversionLbl : UILabel = {
      let v = UILabel()
       v.text = "Conversion Rate:"
       v.font = UIFont(name: Fonts.medium, size: 14)
       v.textAlignment = .center
      return v
    }()

    lazy var submitBtn : UIButton = {
      let v = UIButton()
       v.layer.cornerRadius = 5
       v.backgroundColor = ColorConfig().black
       v.setTitle("Exchange", for: .normal)
       v.titleLabel?.font = UIFont(name: Fonts.medium, size: 12)
       v.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
      return v
    }()

    var viewModel : FxViewModel?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesKeyboardOnTapArround()
        setUpView()
        setUpData()
        self.title = "Foreign Exchange"
//        self.navigationController?.navigationBar.titleTextAttributes =
//        [NSAttributedString.Key.foregroundColor: UIColor.black,
//         NSAttributedString.Key.font: UIFont(name: Fonts.bold, size: 20)!]
    }
    
    init(balance: String?) {
        super.init(nibName: nil, bundle: nil)
        self.userBalance = balance
        self.balance.text = userBalance?.amountEntered(wDecimal: false)
        self.amountInput.text = "PHP \(userBalance?.amountEntered(wDecimal: false,wSeparator: false) ?? "")"
        self.convertInput.dropView.text = selectedCurrency
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpNavigationBar()
    }

    override func setUpData() {
        self.viewModel?.onSuccessCurrencyList = { [weak self] data in
            DispatchQueue.main.async {
                self?.stopAnimating()
                self?.currencyList = data
            }
        }
        
        self.viewModel?.onSuccessRequest = { [weak self] data in
            DispatchQueue.main.async {
                self?.stopAnimating()
                if data?.tag == 1 {
                    self?.showAlert(buttonOK: "Ok",title: data?.title ?? "", message:"Please proceed to any DA5 branches \n Ref no. \(data?.message ?? "")", actionOk: { (action) in
                        self?.coordinator?.showParentView()
                    }, completionHandler: nil)
                }
            }
        }
       
        self.viewModel?.onErrorHandling = { [weak self] status in
            DispatchQueue.main.async {
                self?.stopAnimating()
                self?.showAlert(buttonOK: "Ok", message: status?.message ?? "Something went wrong", actionOk: nil, completionHandler: nil)
            }
        }
        
        self.setAnimate(msg: "Please wait...")
        self.viewModel?.getCurrency(base: selectedCurrency)
    }

    override func setUpView() {
        view.addSubview(balance)
        balance.snp.makeConstraints { (make) in
            make.top.equalTo(view.layoutMarginsGuide.snp.top).offset(25)
           make.leading.equalTo(view).offset(20)
           make.trailing.equalTo(view).offset(-20)
           make.height.equalTo(20)
        }
        
        view.addSubview(balanceLbl)
        balanceLbl.snp.makeConstraints { (make) in
            make.top.equalTo(balance.snp.bottom).offset(10)
           make.leading.equalTo(view).offset(20)
           make.trailing.equalTo(view).offset(-20)
           make.height.equalTo(20)
        }
        
        view.addSubview(amountInput)
        amountInput.snp.makeConstraints { (make) in
            make.top.equalTo(balanceLbl.snp.bottom).offset(50)
           make.leading.equalTo(view).offset(40)
           make.trailing.equalTo(view).offset(-40)
           make.height.equalTo(40)
        }
        
        view.addSubview(exchangeIcon)
        exchangeIcon.snp.makeConstraints { (make) in
           make.top.equalTo(amountInput.snp.bottom).offset(20)
           make.centerX.equalTo(view)
           make.width.equalTo(40)
           make.height.equalTo(40)
        }
        
        view.addSubview(convertInput)
        convertInput.snp.makeConstraints { (make) in
           make.top.equalTo(exchangeIcon.snp.bottom).offset(20)
           make.leading.equalTo(view).offset(40)
           make.trailing.equalTo(view).offset(-40)
           make.height.equalTo(40)
        }
        
        view.addSubview(conversionLbl)
        conversionLbl.snp.makeConstraints { (make) in
          make.top.equalTo(convertInput.snp.bottom).offset(5)
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

        let showDrop = UITapGestureRecognizer(target: self, action: #selector(showCurrencyList))
        convertInput.dropView.addGestureRecognizer(showDrop)
    }
    
    @objc func showCurrencyList() {
        let vc = DropDownViewController<String>(width: 80, height: view.frame.height * 0.8)
        var data : [String] = []
        if let d = self.currencyList?.rates  {
            for x in d{
                data.append(x.key)
            }
        }
        vc.data = data
        vc.modalPresentationStyle = .overCurrentContext
        vc.parentView = self
        self.present(vc, animated: false) {
            vc.showModal()
        }
    }

    @objc func submitAction() {
        if let amount = self.amountInput.text, let conAmount = self.convertInput.conversionRate.text {
            self.viewModel?.fxExchange(currency: selectedCurrency, amount: amount.returnDoubletoStrings(wSeparator: false), convertedAmount: conAmount, token: self.coordinator?.token)
            
        }
    }

    
    @objc func amountEntered(_ textField: UITextField) {
        if let amountString = amountInput.text?.currencyInputFormatting() {
            textField.text = amountString.replacingOccurrences(of: ",", with: "")
            convertAmountEntered(text: amountString)
        }
    }
    
    func convertAmountEntered(text: String) {
        let trimmedString = text.replacingOccurrences(of: "PHP", with: "")
        trimmedString.replacingOccurrences(of: ",", with: "")
        userBalance = trimmedString
        let amount = trimmedString.returnDouble()
        let convertedRate = (amount) / (self.currencyList?.rates?["PHP"] ?? 0)
        self.convertInput.adjustLabelView(text: convertedRate.returnDoubleToString().replacingOccurrences(of: ",", with: ""))
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



//MARK:-CONVERSION VIEW
class ConversionField: UIView {

    lazy var container : UIView = {
        let v = UIView()
        return v
    }()
    
    lazy var dropView : UILabel = {
        let v = UILabel()
        v.text = "USD"
        v.font = UIFont(name: Fonts.regular, size: 12)
        v.isUserInteractionEnabled = true
        return v
    }()
    
    lazy var dropIcon : UIImageView = {
       let v = UIImageView()
        v.image = UIImage(named: "drop-down-arrow")?.withRenderingMode(.alwaysTemplate)
        v.tintColor = ColorConfig().lightGray
       return v
    }()
    
    lazy var conversionRate : UILabel = {
       let v = UILabel()
        v.text = "0.00"
        v.font = UIFont(name: Fonts.medium, size: 24)
       return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addBorders(edges: .bottom, color: ColorConfig().darkGray!)
    }
    
    func setUpView() {
        let width = (self.conversionRate.text?.widthForView(font: self.conversionRate.font, width: ColorConfig().screenWidth - 160) ?? 0 ) + 80 // 180 = 60 width 20 offset 80 offset outside
        print("WIDTH : \(width) == \(ColorConfig().screenWidth - 180) == \(self.conversionRate.text) == \(self.conversionRate.font)")
        addSubview(container)
        container.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.centerX.equalTo(self)
            make.width.equalTo(width) // drop width + text width
            make.height.equalTo(self)
        }
        
        container.addSubview(dropView)
        dropView.snp.makeConstraints { (make) in
            make.centerY.equalTo(container)
            make.height.equalTo(container)
            make.leading.equalTo(container)
            make.width.equalTo(60)
        }
        
        container.addSubview(dropIcon)
        dropIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(container)
            make.height.equalTo(10)
            make.leading.equalTo(dropView.snp.trailing).offset(-10)
            make.width.equalTo(10)
        }
        
        container.addSubview(conversionRate)
        conversionRate.snp.makeConstraints { (make) in
           make.centerY.equalTo(container)
           make.height.equalTo(container)
           make.leading.equalTo(dropView.snp.trailing).offset(20)
           make.trailing.equalTo(container)
        }

        
    }
    
    func changeDropLbl(text: String) {
        self.dropView.text = text
    }
    
    func adjustLabelView(text: String) {
        // check max width // screen width - 40
        // compute text
        self.conversionRate.text = text
        let width = text.widthForView(font: self.conversionRate.font, width: self.frame.width - 80) + 80
        if width <= self.frame.width {
            container.snp.updateConstraints { (make) in
                make.width.equalTo(width)
            }
        }
    }
}
