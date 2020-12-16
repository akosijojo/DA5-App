//
//  ForgotPinViewController.swift
//  DA5-APP
//
//  Created by Jojo on 12/14/20.
//  Copyright © 2020 OA. All rights reserved.
//
import UIKit
import AVFoundation
import NVActivityIndicatorView

class ForgotPinViewController: BaseViewControler {
    var timer : Timer?
    var seconds : Int = 0
    var pagerIndex : Int = 0
    
    var viewModel : LoginViewModel?
    
    var mobileNumber: String? = ""
    var emailAddress: String? = ""

    lazy var pager : PagerView = {
        let v = PagerView()
        v.itemCount = 2
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
    
    lazy var customProgressView : CustomProgressView = {
       let v = CustomProgressView()
        v.title.text = "Please wait"
        v.message.text = ""
       return v
    }()

    let form3 = "form3"

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AuthenticationCollectionViewCell.self, forCellWithReuseIdentifier: form3)
        
        // Add Observer when keyboard will show and hide
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(self.whenShowKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(self.whenHideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.hidesKeyboardOnTapArround()
    }
    
    override func getData() {
        //MARK: - BASIC REQUEST
        self.viewModel?.onSuccessRequest = { [weak self] res in
            DispatchQueue.main.async {
                self?.stopAnimationBlocker()
            }
        }
        //MARK:-Registration Successfull
        self.viewModel?.onSuccessRegistrationData = { [weak self] data in
            DispatchQueue.main.async {
                self?.stopAnimationBlocker()
                if let result = data {
                    self?.showAlert(buttonOK: "Ok", message: "Registration Successful.", actionOk: { (act) in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            if data?.customer != nil {
                                self?.coordinator?.pinCodeCoordinator(isChecking: true, customerData:result.customer)
                            }
                            print("NO DATA GET")
                        }
                    }, completionHandler: nil)
                }
            }
            
        }
        //MARK: - ALL REQUEST ERROR
        self.viewModel?.onErrorHandling = { [weak self] error in
            DispatchQueue.main.async {
                self?.stopAnimationBlocker()
                //MARK:- show this code
                self?.showAlert(buttonOK: "Ok", message: error?.message ?? "", actionOk: nil, completionHandler: nil)
            }
            
        }
        
        self.viewModel?.getOtp(number: mobileNumber ?? "", email: emailAddress ?? "", isResend: 0, type: 2)
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

    }

    @objc func whenHideKeyboard(_ notification : NSNotification) {

    }
    
    override func setUpNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "arrow_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = ColorConfig().darkBlue
        backButton.addTarget(self, action: #selector(navBackAction), for: .touchUpInside)
        let leftButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    override func navBackAction() {
        self.viewModel = nil
        self.navigationController?.popViewController(animated: true)
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
}

extension ForgotPinViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: form3, for: indexPath) as? AuthenticationCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        cell.data = self.mobileNumber
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
    
    //MARK: - ANIMATION ON LOADING
    func beginAnimation(animate: Bool = true,title: String? = nil, msg: String? = nil) {
        if animate {
            customProgressView.runLoadingAnimation(vc: self,navBar: self.navigationController?.navigationBar, view: self.view,title: title,message: msg)
        }else {
             customProgressView.removeLoadingAnimation(vc: self, navBar: self.navigationController?.navigationBar)
        }
    }
    //MARK:-STOP ALL LOADING ANIMATION
    func stopAnimationBlocker() {
        print("STOP ANIMATION")
        self.stopAnimating()
        self.beginAnimation(animate: false)
    }
}

extension ForgotPinViewController : AuthenticationCollectionViewCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    func resendCode(cell: AuthenticationCollectionViewCell) {
        self.setAnimate(msg: "Please wait..")
        self.viewModel?.getOtp(number: self.mobileNumber ?? "", email: self.emailAddress ?? "", isResend: 1, type: 2)

    }
    
    func submitAction(cell: AuthenticationCollectionViewCell, index: Int) {
        //MARK: - SUBMITING FORGOT MPIN
     // show terms and condition
        coordinator?.termsCoordinator(parentView: self)
        self.viewModel?.registrationForm?.code = cell.verificationCode.text?.replacingOccurrences(of: " ", with: "")
        print(" VERIFICATION CODE ",self.viewModel?.registrationForm?.code)
    }
}
