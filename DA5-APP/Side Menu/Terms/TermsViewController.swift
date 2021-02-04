//
//  TermsViewController.swift
//  DA5-APP
//
//  Created by Jojo on 9/9/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

class TermsViewController: BaseViewControler {
    
    var forViewing : Bool? = nil
    
    let terms = "The information provided above and documents hereby submitted/attached have been made in good faith, verified correct to the best of my knowledge and pursuant to all laws and regulations applicable. I fully understand that Direct Agent 5, Inc. (DA5) is authorized to accept and process payments and remittances submitted to its branches.\n\n With this, I hereby provide the necessary information in order for DA5 to complete the transaction, wherefore, we can avail of the services requested. DA5 reserves the right not to accept, process or payout any money transfer at its sole discretion after having made a determination that processing of thetransaction will result to a violation of any DA5 policy, BSP, AMLA or any applicable laws or regulations. Likewise, I voluntarily give my consent for the collection, use, processing, storage and retention of my personal data or information to DA5 for the purpose(s) described herein and hold free and harmless and indentify DA5 from any complaint or damages which any party may file or claim in relation to my consent.\n\n I also understand that my consent does not prevent the existence of other criteria for lawful processing of personal data and does not waive any of my rights under Data Privacy Act of 2012 and other applicable laws."
    
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
    
    init(forViewing: Bool? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.forViewing = forViewing
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUpNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "arrow_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = ColorConfig().black
        backButton.addTarget(self, action: #selector(navBackAction), for: .touchUpInside)
        self.title = "Terms and Conditions"
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
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view).offset(self.forViewing == true ?  0 : -70) // + 10 offset
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
            make.bottom.equalTo(scrollView)
        }
        
        view.addSubview(btnContainer)
        btnContainer.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView.snp.bottom).offset(10)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(self.forViewing == true ?  0 : 60)
        }
        
        if self.forViewing == nil {
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
        }
    
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
