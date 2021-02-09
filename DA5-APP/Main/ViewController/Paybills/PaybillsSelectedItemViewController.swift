//
//  PaybillsSelectedItemViewController.swift
//  DA5-APP
//
//  Created by Jojo on 1/28/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

struct MetaFields {
    var key: String?
    var value : String
}

class PaybillsSelectedItemViewController: BaseHomeViewControler {
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.bounces = false
        v.showsHorizontalScrollIndicator = false
        v.backgroundColor = ColorConfig().white
        return v
    }()

//    lazy var submitBtn : UIButton = {
//      let v = UIButton()
//       v.layer.cornerRadius = 5
//       v.backgroundColor = ColorConfig().black
//       v.setTitle("Proceed", for: .normal)
//       v.titleLabel?.font = UIFont(name: Fonts.medium, size: 12)
//       v.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
//      return v
//    }()
    
    var cellDropSelected : Int? {
        didSet {
//            print("SELECTED ITEM : \(cellDropSelected)")
        }
    }
    
    var dropItemSelected : DropItem? {
        didSet {
            DispatchQueue.main.async {
                if let cell = self.collectionView.cellForItem(at: IndexPath(item: self.cellDropSelected! , section: 0)) as? PaybillsItemViewCell {
                    cell.dataDropDown = self.dropItemSelected
                    
                }
                self.collectionView.reloadItems(at: [IndexPath(item: self.cellDropSelected!, section: 0)])
//                self.collectionView.reloadData()
            }
        }
    }
    
    var data : BillerData? {
        didSet {
//            self.collectionView.reloadData()
//            print("GET DATA : \(data)")
        }
    }
    var viewModel : PaybillsViewModel?
    
    var itemCellId = "ItemCellId"
    
    var headerCellId = "HeaderCellId"
    var footerCellId = "FooterCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesKeyboardOnTapArround()
        setUpView()
        setUpData()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(PaybillsItemViewCell.self, forCellWithReuseIdentifier: itemCellId)
        self.collectionView.register(HeaderCell.self, forSupplementaryViewOfKind:  UICollectionView.elementKindSectionHeader, withReuseIdentifier:headerCellId)
        self.collectionView.register(SubmitFooterViewCell.self, forSupplementaryViewOfKind:  UICollectionView.elementKindSectionFooter, withReuseIdentifier:footerCellId)
        
        let notification = NotificationCenter.default
          notification.addObserver(self, selector: #selector(self.whenShowKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
          notification.addObserver(self, selector: #selector(self.whenHideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    init(data: BillerData) {
        super.init(nibName: nil, bundle: nil)
        // set up initial data to view
//        print("DATA GET : \(data)")
        self.data = data
        collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func whenShowKeyboard(_ notification : NSNotification) {
          if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
           
            self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height - view.safeAreaInsets.bottom, right: 0)
            
//            self.collectionView.scrollRectToVisible(<#T##rect: CGRect##CGRect#>, animated: <#T##Bool#>)
        }
    }

    @objc func whenHideKeyboard(_ notification : NSNotification) {
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpNavigationBar()
    }
    
    override func setUpData() {
        self.viewModel?.onSuccessPaybillsData = { [weak self] data in
            DispatchQueue.main.async {
                self?.stopAnimating()
                self?.showAlert(buttonOK: "Ok", message: data?.message ?? "", actionOk: { (action) in
                    self?.coordinator?.showParentView()
                }, completionHandler: nil)
                
            }
        }
        
        self.viewModel?.onErrorHandling = { [weak self] status in
            DispatchQueue.main.async {
                self?.stopAnimating()
                if status?.tag == 1 {
                    self?.showAlert(buttonOK: "Ok", message: status?.message ?? "Something went wrong", actionOk: { (action) in
                        self?.coordinator?.showParentView()
                    }, completionHandler: nil)
                }else {
                    self?.showAlert(buttonOK: "Ok", message: status?.message ?? "Something went wrong", actionOk: nil, completionHandler: nil)
                }
                
            }
        }
    }
    
    override func setUpView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(view.layoutMarginsGuide.snp.top)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
        
    }
    
    @objc func submitAction() {
        //MARK: - Getting all fields to fillup from collection view
        var error : Bool = false
        
        var parameters : [[String:String]] = []
        
        for x in 0...((data?.meta.count ?? 0) - 1) {
            if let cell = collectionView.cellForItem(at: IndexPath(item: x, section: 0)) as? PaybillsItemViewCell{
                if data?.meta[x].isRequired == IsRequired.bool(true) {
                    if cell.textField.TextField.text == "" {
                        error = true
                    }
                }
                
                if let field = data?.meta[x].field {
                    //MARK: - checking if field type is dropdown
                    var perItem : [String: String] = [:]
                    if let drop = cell.dataDropDown {
                        perItem["key"]  = field
                        perItem["value"] =  drop.value
                    }else if cell.textField.TextField.tag == 1 {
                        perItem["key"]  = field
                        perItem["value"] = cell.textField.TextField.text?.formatDate(dateFormat: "MMM dd, yyyy", format: "YYYY-MM-DD") ?? ""
                        
                    }else {
                        perItem["key"]  = field
                        perItem["value"] =  cell.textField.TextField.text ?? ""
                    }
                    
                    parameters.append(perItem)
        
                }
            }
        }
        
        if error {
            self.showAlert(buttonOK: "Ok", message: "Please fill up all required fields.", actionOk: nil, completionHandler: nil)
        }else {
//            print("PARAM : \(parameters)")
            self.setAnimate(msg: "Please wait...")
            self.viewModel?.paybillsProcess(token: self.coordinator?.token, param: parameters, billerCode: self.data?.code ?? "")
        }
    }
    
    deinit {
          NotificationCenter.default.removeObserver(self)
    }
    
}

extension PaybillsSelectedItemViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellId, for: indexPath) as? HeaderCell else {
                        return UICollectionReusableView()
            }
            header.headerView.title.text = data?.name
            header.headerView.desc.text = data?.type
            return header
        case UICollectionView.elementKindSectionFooter:
            guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerCellId, for: indexPath) as? SubmitFooterViewCell else {
                return UICollectionReusableView()
            }

            footer.delegate = self
            return footer
        default:
            return UICollectionReusableView()
        }
        
    }
       
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width:collectionView.frame.width, height:100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width:collectionView.frame.width, height: (data?.meta.count ?? 0) > 0 ? 80 : 0)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data?.meta.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //MARK: - Last section is the submit button
        // checking per cell if input field or dropdown
        // checking if required fields
        // checking if fields accept number only or not
        // gather all input upon submiting and make dictionary of paramaters
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellId, for: indexPath) as? PaybillsItemViewCell else {
            return UICollectionViewCell()
        }
//        cell.data = self.data?[indexPath.item]
//        cell.delegate = self
//        if cellDropSelected == indexPath.item, let drop = self.dropItemSelected {
//            cell.dataDropDown = drop
//        }
        
        cell.dataDropDown = indexPath.item == cellDropSelected ? self.dropItemSelected : nil
        cell.index = indexPath.item
        cell.data = self.data?.meta[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let textHeight = (self.data?.meta[indexPath.item].label?.heightForView(font: UIFont(name: Fonts.regular, size: 12)!, width: collectionView.frame.width - 80) ?? 0)
       
        return CGSize(width: collectionView.frame.width - 40, height: textHeight > 29 ? 60 + 40 : 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
    }

}
extension PaybillsSelectedItemViewController {
    //MARK: - cell Actions

    func showDropdownView(data: [DropItem]) {
        let itemHeight = CGFloat((data.count * 50) + 10)
        let frameHeight = CGFloat(view.frame.width * 0.8)
        let height : CGFloat = itemHeight >= frameHeight ? frameHeight : itemHeight
        let vc = DropDownViewController<DropItem>(width: view.frame.width * 0.8, height: height)
        vc.data = data
        vc.modalPresentationStyle = .overCurrentContext
        vc.parentView = self
        self.present(vc, animated: false) {
           vc.showModal()
        }
    }
}
extension PaybillsSelectedItemViewController : SubmitFooterViewCellDelegate , PaybillsItemViewCellDelegate {
    func onClickDropDown(cell: PaybillsItemViewCell, data: MetaData?, index: Int?) {
        if let d = data, let options = d.options {
            self.view.endEditing(true)
            var items: [DropItem] = []
            for x in options {
                items.append(DropItem(key: x.key, value: x.value?.string ?? ""))
            }
            
            self.cellDropSelected = index
            self.showDropdownView(data: items)
        }
    }
    
    func onSubmit(cell: SubmitFooterViewCell) {
        self.submitAction()
    }
    
    
}
