//
//  WalletTransferViewController.swift
//  DA5-APP
//
//  Created by Jojo on 1/10/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit
import ADCountryPicker

class WalletTransferViewController: BaseHomeViewControler{
    
    var data : WalletTransferData?
    
    var dropCell : String = "Cell ID"
    
    var phoneNumberCode : PhoneNumberCountryCode? {
          didSet {
             if let item = phoneNumberCode , item.code != nil {
                  self.phoneNumber.FieldView.phoneViewLabel.flag.image = phoneNumberCode?.image
                  self.phoneNumber.FieldView.phoneViewLabel.country.text = phoneNumberCode?.code
                  self.phoneNumber.FieldView.phoneViewLabel.Label.text = phoneNumberCode?.dialCode
              }
          }
    }
      
    
    lazy var headerView : CustomHeaderView = {
        let v = CustomHeaderView()
        v.title.text = "Send Money"
        v.desc.text = "Enter recipient's phone number and amount"
        return v
    }()
    
    lazy var phoneLbl : UILabel = {
       let v = UILabel()
       v.text = "Recipient's phone number"
       v.font = UIFont(name: Fonts.regular, size: 12)
       return v
    }()
    
    lazy var phoneNumber: CustomBasicFormInputNumber = {
       let v = CustomBasicFormInputNumber()
       v.FieldView.TextField.keyboardType = .numberPad
       v.FieldView.TextField.tag = 1
       v.FieldView.TextField.delegate = self
        v.FieldView.TextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
       v.FieldView.TextField.placeholder = "Phone Number"
        v.FieldView.phoneViewLabel.isUserInteractionEnabled = true
       return v
    }()
    
    lazy var dropTableView : UITableView = {
      let v = UITableView()
      v.layer.borderColor = ColorConfig().lightGray?.cgColor
      v.layer.borderWidth = 1
      v.layer.cornerRadius = 2
      return v
    }()
    
    lazy var amountLbl : UILabel = {
       let v = UILabel()
       v.text = "Amount"
       v.font = UIFont(name: Fonts.regular, size: 12)
       return v
    }()
    
    lazy var amount: CustomBasicFormInputNumber = {
       let v = CustomBasicFormInputNumber()
       v.FieldView.TextField.keyboardType = .decimalPad
       v.FieldView.TextField.tag = 2
       v.FieldView.TextField.delegate = self
       v.FieldView.phoneViewLabel.Label.text = "PHP"
       v.FieldView.TextField.placeholder = "Amount"
       v.FieldView.TextField.addTarget(self, action: #selector(amountChanged), for: .editingDidEnd)
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
    
    var viewModel : LoadWalletViewModel?
    
    var contacts : WalletContactsLocal? {
        didSet {
            
        }
    }
    
    var contactFiltered : [String] = [] {
        didSet {
            dropTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesKeyboardOnTapArround()
        setUpView()
        setUpData()
        dropTableView.dataSource = self
        dropTableView.delegate = self
        dropTableView.register(ContactTableViewCell.self, forCellReuseIdentifier: dropCell)
        dropTableView.estimatedRowHeight = 40
        
        //DEFAULT VALUE
        phoneNumberCode = PhoneNumberCountryCode(image: ADCountryPicker().getFlag(countryCode: "PH"), code: "PH", name: "Philippines", dialCode: "+63")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpNavigationBar()
    }
    
    override func setUpData() {
        // add request return
        self.viewModel?.onSuccessWalletDetailsData = { [weak self] data in
            DispatchQueue.main.async {
                self?.data?.recipientName = "\(data?.firstName ?? "") \(data?.lastName ?? "")"
                  self?.coordinator?.showWalletTransferDetailsViewController(data:  self?.data)
            }
        }
        
        self.viewModel?.onErrorHandling = { [weak self] status in
            DispatchQueue.main.async {
                self?.showAlert(buttonOK: "Ok", message: status?.message ?? "Something went wrong.", actionOk: nil, completionHandler: nil)
            }
        }
        
        var dataLocal = WalletContactsLocal(number: ["9123456789"])
        dataLocal.saveToLocal()
        // get saved contacts
        contacts = WalletContactsLocal.shared.getLocal()
        
    }
    
    override func setUpView() {
        view.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
           make.top.equalTo(view.layoutMarginsGuide.snp.top).offset(25)
           make.leading.equalTo(view).offset(20)
           make.trailing.equalTo(view).offset(-20)
           make.height.equalTo(80)
        }
        
        view.addSubview(phoneLbl)
        phoneLbl.snp.makeConstraints { (make) in
          make.top.equalTo(headerView).offset(100)
          make.leading.equalTo(view).offset(20)
          make.trailing.equalTo(view).offset(-20)
          make.height.equalTo(20)
        }
        
        view.addSubview(phoneNumber)
        phoneNumber.snp.makeConstraints { (make) in
            make.top.equalTo(phoneLbl.snp.bottom).offset(10)
          make.leading.equalTo(view).offset(20)
          make.trailing.equalTo(view).offset(-20)
          make.height.equalTo(40)
        }
    
        let selectPhoneCode = UITapGestureRecognizer(target: self, action: #selector(openPickerAction))
        phoneNumber.FieldView.phoneViewLabel.addGestureRecognizer(selectPhoneCode)
        
        view.addSubview(dropTableView)
        dropTableView.snp.makeConstraints { (make) in
            make.top.equalTo(phoneNumber.snp.bottom)
            make.leading.equalTo(view).offset(150)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(0)
        }
        dropTableView.isHidden = true
        view.bringSubviewToFront(dropTableView)
        
        view.addSubview(amountLbl)
        amountLbl.snp.makeConstraints { (make) in
          make.top.equalTo(phoneNumber.snp.bottom).offset(10)
          make.leading.equalTo(view).offset(20)
          make.trailing.equalTo(view).offset(-20)
          make.height.equalTo(20)
        }
        //MARK: - HIDE FLAG AND COUNTRY
        amount.FieldView.hideFlagAndCountry()
        
        view.addSubview(amount)
        amount.snp.makeConstraints { (make) in
          make.top.equalTo(amountLbl.snp.bottom).offset(10)
          make.leading.equalTo(view).offset(20)
          make.trailing.equalTo(view).offset(-20)
          make.height.equalTo(40)
        }
        amount.FieldView.TextField.delegate = self
        
        view.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom).offset(-20)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(40)
        }

         changeView()
    }
    
    @objc func amountChanged(_ textField: UITextField) {
        if let amountString = amount.FieldView.TextField.text?.amountEntered() {
           textField.text = amountString
        }
    }
    
    func changeView(){
        self.phoneNumber.removeLblHeight()
        self.amount.removeLblHeight()
        self.amount.FieldView.removeBorder()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.filterContact(text: textField.text ?? "")
        //MARK:- can add search to stored numbers and filter drop content
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 2 {
            textField.text = textField.text?.replacingOccurrences(of: ",", with: "")
        }else if textField.tag == 1 {
            self.filterContact(text: textField.text ?? "")
        }else {
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            self.showDropView(bool: false)
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         guard let text = textField.text else { return true }
         if textField.tag == 1 && self.phoneNumberCode?.code == "PH" {
            let count = text.count + string.count - range.length
            return count <= 10
         } else if textField.tag == 2 {
            return self.amountFormating(textField: textField, string: string)
         }else {
            return true
         }
    }
    
    func filterContact(text: String) {
        if self.contacts?.number?.count ?? 0 > 0 {
           var data : [String] = []
           if text == "" {
               data = self.contacts?.number ?? []
           }else {
               var dataFiltered : [String] = []
               for item in contacts?.number ?? [] {
                   if item.hasPrefix(text) == true || item.hasSuffix(text) == true {
                       dataFiltered.append(item)
                   }
               }
               data = dataFiltered.count > 0 ? dataFiltered : []
           }
           self.contactFiltered = data
           self.showDropView(bool: data.count > 0 ? true : false)
        }
    }
    
    //MARK:- RESTRICTIONS
    func amountFormating(textField: UITextField,string: String) -> Bool{
        switch string {
         case "0","1","2","3","4","5","6","7","8","9":
             if (textField.text?.first == "0") {
               return false
             }
             return true
         case ".":
           var decimalCount : Int = 0
           let array = Array(arrayLiteral: textField.text)
             for character in array {
               if character?.contains(".") ??  false{
                     decimalCount += 1
                 }
             }

             if decimalCount >= 1 {
                 return false
             } else {
                 return true
             }
         default:
             let array = Array(string)
             if array.count == 0 {
                 return true
             }
             return false
         }
    }
    
    @objc func submitAction() {
        if let number = self.phoneNumber.FieldView.TextField.text, let amount = self.amount.FieldView.TextField.text , number != "" && amount.returnAmount() >= 1{

            self.data = WalletTransferData(senderNum: UserLoginData.shared.phoneNumber ?? "", senderName: "\(UserLoginData.shared.firstName ?? "") \(UserLoginData.shared.lastName ?? "")", recipientNum: number, recipientName: "", amount: amount)
            
            self.viewModel?.sendMoneyDetails(amount:"\(amount.returnAmount())", customerId: UserLoginData.shared.id ?? 0, phone: number)
            
        }else {
            let phone = self.phoneNumber.FieldView.TextField.text
            self.showAlert(buttonOK: "Ok", message: phone == "" ? "Phone number is invalid." : "Please enter your desired amount for trasfer.", actionOk: nil, completionHandler: nil)
        }
       
    }

}

extension WalletTransferViewController : UITableViewDataSource , UITableViewDelegate{
    func showDropView(bool: Bool? = false) {
        if contactFiltered.count > 0 {
            if bool == true {
               dropTableView.isHidden = false
               dropTableView.snp.remakeConstraints { (make) in
                   make.top.equalTo(phoneNumber.snp.bottom)
                   make.leading.equalTo(view).offset(150)
                   make.trailing.equalTo(view).offset(-20)
                   make.height.equalTo(contactFiltered.count > 3 ? 130 : contactFiltered.count * 43)
               }
                view.bringSubviewToFront(dropTableView)
               return
           }
        }
        dropTableView.isHidden = true
        dropTableView.snp.updateConstraints { (make) in
            make.top.equalTo(phoneNumber.snp.bottom)
            make.leading.equalTo(view).offset(150)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(0)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactFiltered.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ContactTableViewCell(style: .default, reuseIdentifier: dropCell)
        cell.textLabel?.text = contactFiltered[indexPath.row]
        cell.textLabel?.font = UIFont(name: Fonts.regular, size: 12)
        cell.textLabel?.textColor = ColorConfig().gray
        cell.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        cell.vc = self
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 20
//    }

    func selectActionCell(cell: UITableViewCell) {
        self.phoneNumber.FieldView.TextField.text = cell.textLabel?.text
        self.showDropView(bool: false)
    }

}


class ContactTableViewCell : UITableViewCell {
    
    var vc : UIViewController?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickAction))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    @objc private func clickAction() {
        if let view = vc as? WalletTransferViewController {
            view.selectActionCell(cell: self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension WalletTransferViewController {
    @objc func openPickerAction() {
            
        let picker = ADCountryPicker(style: .grouped)
        picker.delegate = self
        picker.searchBarBackgroundColor = UIColor.white
        picker.showCallingCodes = true
        picker.didSelectCountryClosure = { name, code in
            _ = picker.navigationController?.popToRootViewController(animated: true)
            print(code)
        }
        let pickerNavigationController = UINavigationController(rootViewController: picker)
        self.present(pickerNavigationController, animated: true, completion: nil)
    }

}

extension WalletTransferViewController: ADCountryPickerDelegate {
    
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        _ = picker.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        let img =  picker.getFlag(countryCode: code)
        let xx =  picker.getCountryName(countryCode: code)
        let xxx =  picker.getDialCode(countryCode: code)
        self.phoneNumberCode = PhoneNumberCountryCode(image: img, code: code, name: name, dialCode: dialCode)
       
    }
}
