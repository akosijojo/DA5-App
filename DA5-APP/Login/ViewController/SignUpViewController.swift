//
//  SignUpViewController.swift
//  DA5-APP
//
//  Created by Jojo on 8/26/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit
import AVFoundation

class SignUpViewController: BaseViewControler {
    var bdate : UITextField? = nil
    let datePicker : UIDatePicker? = nil
    var pagerIndex : Int = 0
    
    lazy var pager : PagerView = {
        let v = PagerView()
        v.itemCount = 3
        v.itemColor = ColorConfig().lightBlue!
        v.itemIndex = 0
        return v
    } ()
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = ColorConfig().white
        view.isPagingEnabled = true
        view.bounces = false
        view.isScrollEnabled = false
        return view
    }()
    
    let form1 = "form1"
    let form2 = "form2"
    let form3 = "form3"

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BasicInfoCell.self, forCellWithReuseIdentifier: form1)
        collectionView.register(IdentificationCollectionViewCell.self, forCellWithReuseIdentifier: form2)
        collectionView.register(VerifyCollectionViewCell.self, forCellWithReuseIdentifier: form3)
        showDatePicker()
        
        // Add Observer when keyboard will show and hide
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(self.whenShowKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(self.whenHideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.hidesKeyboardOnTapArround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpNavigationBar()
        self.pager.collectionView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        coordinator?.dismissViewController()
    }
    
    func hidesKeyboard() {
        print("HEY CLOSING")
        view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    @objc func whenShowKeyboard(_ notification : NSNotification) {
          if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                guard let cell = collectionView.cellForItem(at: IndexPath(item: pagerIndex, section: 0))  else {
                        return
                }
                if let cellView = cell as? BasicInfoCell {
                     if #available(iOS 11.0, *) {
                        cellView.addShowKeyboard(offset: -(keyboardSize.height - self.view.safeAreaInsets.bottom))
                    } else {
                        cellView.addShowKeyboard(offset: -keyboardSize.height)
                    }
                }
                if let cellView = cell as? IdentificationCollectionViewCell {
                     if #available(iOS 11.0, *) {
                        cellView.addShowKeyboard(offset: -(keyboardSize.height - self.view.safeAreaInsets.bottom))
                    } else {
                        cellView.addShowKeyboard(offset: -keyboardSize.height)
                    }
                }
            }
    }

    @objc func whenHideKeyboard(_ notification : NSNotification) {
        guard let cell = collectionView.cellForItem(at: IndexPath(item: pagerIndex, section: 0)) else {
             return
         }
          if let cellView = cell as? BasicInfoCell {
              cellView.addShowKeyboard(offset:0)
          }
          if let cellView = cell as? IdentificationCollectionViewCell {
              cellView.addShowKeyboard(offset:0)
          }
    }
    
    func setUpNavigationBar() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "arrow_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = ColorConfig().darkBlue
        backButton.addTarget(self, action: #selector(navBackAction), for: .touchUpInside)
        let leftButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    override func setUpView() {
        view.addSubview(pager)
        pager.snp.makeConstraints { (make) in
            make.top.equalTo(view.layoutMarginsGuide.snp.top)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(30)
        }
        pager.collectionView.reloadData()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(pager.snp.bottom).offset(10)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom).offset(0)
        }
    }
    
    func showDatePicker(){
        print("SELECT DATE")
       //Formate Date
        datePicker?.datePickerMode = .date

        //ToolBar
       let toolbar = UIToolbar();
       toolbar.sizeToFit()

       //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action:  #selector(cancelDatePicker))
       toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

        // add toolbar to textField
        bdate?.inputAccessoryView = toolbar
         // add datepicker to textField
        bdate?.inputView = datePicker

     }

     @objc func donedatePicker(){
      //For date formate
       let formatter = DateFormatter()
       formatter.dateFormat = "dd/MM/yyyy"
        if let date = datePicker?.date {
            bdate?.text = formatter.string(from: date)
        }
       //dismiss date picker dialog
        self.view.endEditing(true)
     }

      @objc func cancelDatePicker(){
       //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
      }
    
}

extension SignUpViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: form1, for: indexPath) as? BasicInfoCell else {
                return UICollectionViewCell()
            }
            cell.vc = self
            cell.delegate = self
            return cell
        }else if  indexPath.item == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: form2, for: indexPath) as? IdentificationCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            return cell
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: form3, for: indexPath) as? VerifyCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
}

extension SignUpViewController : BasicInfoCellDelegate, IdentificationCollectionViewCellDelegate, VerifyCollectionViewCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    //form 1
    func submitAction(cell: BasicInfoCell, index: Int) {
        self.view.endEditing(true)
        self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .right, animated: true)
        self.pager.itemIndex = 1
        self.pager.collectionView.reloadData()
        self.pagerIndex = 1
        self.view.endEditing(true)
    }
    //form 2
    func submitAction(cell: IdentificationCollectionViewCell, index: Int) {
        self.view.endEditing(true)
        self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .right, animated: true)
        self.pager.itemIndex = 2
        self.pager.collectionView.reloadData()
        self.pagerIndex = 2
    }
    
    func submitAction(cell: VerifyCollectionViewCell, index: Int) {
     // show terms and condition
        coordinator?.termsCoordinator()
    }
    
    // image
    func selectValidId(cell: IdentificationCollectionViewCell, index: Int) {
        print("SELECT IMAGE")
         if UIImagePickerController.isSourceTypeAvailable(.camera){
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.allowsEditing = true
            vc.delegate = self
            present(vc, animated: true)
        }else{
            let alert = self.alert("Ok", "Camera is not Available", "", action: { (action) in
            })
            self.present(alert, animated: true, completion: nil)
        }
   
    }
    
    func selectSelfieId(cell: IdentificationCollectionViewCell, index: Int) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.allowsEditing = true
            vc.delegate = self
            vc.showsCameraControls = true
            self.present(vc, animated: true)
        }else{
            let alert = self.alert("Ok", "Camera is not Available", "", action: { (action) in
            })
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        // save image
        // reload collectionview cell
        //

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }

        // print out the image size as a test
        print(image.size)
    }
}
