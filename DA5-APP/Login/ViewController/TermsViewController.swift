//
//  TermsViewController.swift
//  DA5-APP
//
//  Created by Jojo on 9/9/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

class TermsViewController: BaseViewControler {
    
    let terms = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus bibendum lacus in vehicula tempus. Curabitur ac hendrerit nunc, a dapibus odio. Nunc commodo neque tempus euismod semper. Vestibulum varius varius sem vitae pharetra. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nullam urna felis.\n\n Rutrum ornare nunc sit amet, viverra lobortis lectus. Phasellus fringilla ac libero ut consectetur. Integer ut lacinia elit, non laoreet sapien. Donec id luctus felis. Aliquam ultricies ultrices tincidunt. Aliquam erat volutpat. Suspendisse potenti. Donec commodo dui eros, vel laoreet mauris aliquet a. Nullam in auctor turpis. Morbi aliquet nec dui vitae gravida.\n\n Vivamus tempor accumsan vulputate. Curabitur auctor justo sit amet dui fermentum, eu maximus diam porta. Aliquam ultricies nec lorem eget auctor. Donec venenatis, tortor a interdum placerat, purus metus pulvinar massa, ac scelerisque tellus diam sed nisi. Quisque eu turpis urna. Curabitur laoreet sem pharetra arcu dapibus consequat. Mauris semper orci elit.\n\n Vivamus tempor accumsan vulputate. Curabitur auctor justo sit amet dui fermentum, eu maximus diam porta. Aliquam ultricies nec lorem eget auctor. Donec venenatis, tortor a interdum placerat, purus metus pulvinar massa, ac scelerisque tellus diam sed nisi. Quisque eu turpis urna. Curabitur laoreet sem pharetra arcu dapibus consequat."
    
    weak var parentView : UIViewController?
    
    lazy var scrollView : UIScrollView = {
        let v = UIScrollView()
        v.backgroundColor = ColorConfig().innerbgColor
        return v
    }()
  
    lazy var termsLabel : UITextView = {
        let v = UITextView()
        v.text = ""
//        v.numberOfLines = 0
        v.font = UIFont(name: Fonts.regular, size: 14)
        v.backgroundColor = .green
        v.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 100, right: 20)
        v.isScrollEnabled = false
        v.isEditable = false
        v.backgroundColor = ColorConfig().white
        return v
    }()
    
    lazy var btnContainer : UIView = {
        let v = UIView()
        return v
    }()
    
    lazy var cancel : UIButton = {
        let v = UIButton()
        v.titleLabel?.font = UIFont(name: Fonts.regular, size: 14)
        v.titleLabel?.textAlignment = .center
        v.setTitle("Cancel", for: .normal)
        v.setTitleColor(ColorConfig().black, for: .normal)
        v.addTarget(self, action: #selector(cancelButton), for: .touchUpInside)
        return v
    }()
    
    lazy var agree : UIButton = {
        let v = UIButton()
        v.titleLabel?.font = UIFont(name: Fonts.regular, size: 14)
        v.layer.cornerRadius = 5
        v.layer.masksToBounds = true
        v.titleLabel?.textAlignment = .center
        v.setTitle("Agree", for: .normal)
        v.setTitleColor(ColorConfig().white, for: .normal)
        v.backgroundColor = ColorConfig().black
        v.addTarget(self, action: #selector(agreeButton), for: .touchUpInside)
        return v
    }()

//    lazy var btnView : TermsButtonView = {
//        let v = TermsButtonView()
//        v.cancel.text = "Cancel"
//        v.agree.text = "Agree"
//        v.agree.backgroundColor = ColorConfig().black
//        return v
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        termsLabel.text = terms
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpNavigationBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        coordinator?.dismissViewController()
    }
    
    override func setUpNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "arrow_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = ColorConfig().black
        backButton.addTarget(self, action: #selector(navBackAction), for: .touchUpInside)
        self.title = "Terms and Conditions"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: Fonts.bold, size: 20)!]
        let leftButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func cancelButton() {
        self.navBackAction()
    }
    
    @objc func agreeButton() {
        // vc agree terms then action to save data collected
        // after uploading and saving data show success then show mpin creation and saving
        if let vc = parentView as? SignUpViewController {
            self.navigationController?.popViewController(animated: true)
            
            vc.agreeTermsAndCondition = true //agreeOnTermsAndCondition()
        }else {
            self.navBackAction()
        }
    }
    
    override func setUpView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(view.layoutMarginsGuide.snp.top)
            make.leading.trailing.bottom.equalTo(view)
        }
        
        let txtHeight = terms.heightForView(font:UIFont(name: Fonts.regular, size: 14)!, width: view.frame.width - 40)
        let vHeight =  view.layoutMarginsGuide.layoutFrame.height - 200
        let txtComputedHeight = txtHeight + 140//txtHeight > vHeight ? txtHeight + 140 : vHeight
        
        scrollView.addSubview(termsLabel)
        termsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(txtComputedHeight)
        }
        
        scrollView.addSubview(btnContainer)
        btnContainer.snp.makeConstraints { (make) in
            make.top.equalTo(termsLabel.snp.bottom).offset(10)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(60)
            make.bottom.equalTo(scrollView)
        }
        
        btnContainer.addSubview(cancel)
        cancel.snp.makeConstraints { (make) in
            make.top.equalTo(btnContainer)
            make.leading.equalTo(btnContainer)
            make.width.equalTo(btnContainer).multipliedBy(0.5)
            make.height.equalTo(40)
        }
        
        btnContainer.addSubview(agree)
        agree.snp.makeConstraints { (make) in
            make.top.equalTo(btnContainer)
            make.leading.equalTo(cancel.snp.trailing)
            make.width.equalTo(btnContainer).multipliedBy(0.5)
            make.height.equalTo(40)
        }
        
        
//        scrollView.addSubview(btnView)
//        btnView.snp.makeConstraints { (make) in
//            make.top.equalTo(termsLabel.snp.bottom).offset(10)
//            make.leading.equalTo(view).offset(20)
//            make.trailing.equalTo(view).offset(-20)
//            make.height.equalTo(40)
//            make.bottom.equalTo(scrollView)
//        }
    }
}

class TermsButtonView : UIView {
    
    lazy var cancel : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Fonts.bold, size: 14)
        v.textAlignment = .center
        return v
    }()
    
    lazy var agree : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Fonts.regular, size: 14)
        v.layer.cornerRadius = 10
        v.textAlignment = .center
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        addSubview(cancel)
        cancel.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.width.equalTo((self.frame.width / 2) - 25)
            make.bottom.equalTo(self)
        }
        addSubview(agree)
        agree.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(cancel.snp.trailing).offset(10)
            make.width.equalTo((self.frame.width / 2) - 25)
            make.bottom.equalTo(self)
        }
    }
}
