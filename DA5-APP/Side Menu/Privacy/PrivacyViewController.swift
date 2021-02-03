//
//  PrivacyViewController.swift
//  DA5-APP
//
//  Created by Jojo on 11/25/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

class PrivacyViewController: BaseHomeViewControler {
    let dot : String = "\u{25CF}"
    let space : String = "\n"
    let doubleSpace : String = "\n\n"
    
    let privacy = "This privacy policy sets out how Direct Agent 5, Inc. uses and protects any information that you give us when you use this website. DA5 is committed to ensuring that your privacy is protected. Should we ask you to provide certain information by which you can be identified when using this website, then you can be assured that it will only be used in accordance with this privacy statement. We may change this policy from time to time by updating this page. You should check this page from time to time to ensure that you are happy with any changes. This policy is effective from 1st of January, 2013. \n\n What we collect\n We may collect the following information:\n\n \u{25CF} Name and job title\n \u{25CF} Contact information including email address \n \u{25CF} Demographic information such as postcode, preferences and interests \n \u{25CF} Other information relevant to customer surveys and/or offers What we do with the information we gather We require this information to understand your needs and provide you with a better service, and in particular for the \n \n Following reasons: \n\n \u{25CF} Internal record keeping.\n \u{25CF} We may use the information to improve our products and services. \n \u{25CF}  We may periodically send promotional emails about new products, special offers or other information that we think you may find interesting using the email address that you have provided.\n \u{25CF} From time to time, we may also use your information to contact you for market research purposes. We may contact you by email, phone, fax or mail. \n \u{25CF} We may use the information to customize the website according to your interests. Security We are committed to ensuring that your information is secure. In order to prevent unauthorised access or disclosure we have put in place suitable physical, electronic and managerial procedures to safeguard and secure the information we collect online."
       
    lazy var scrollView : UIScrollView = {
        let v = UIScrollView()
        v.backgroundColor = ColorConfig().innerbgColor
        return v
    }()
  
    lazy var privacyView : UITextView = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        privacyView.text = privacy
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        self.title = "Privacy Policy"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setUpNavigationBar()
    }
    
    override func setUpView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(view.layoutMarginsGuide.snp.top)
            make.leading.trailing.bottom.equalTo(view)
        }
        
        let txtHeight = privacy.heightForView(font:UIFont(name: Fonts.regular, size: 14)!, width: view.frame.width - 40)
        let vHeight =  view.layoutMarginsGuide.layoutFrame.height - 200
        let txtComputedHeight = txtHeight + 140//txtHeight > vHeight ? txtHeight + 140 : vHeight
        
        scrollView.addSubview(privacyView)
        privacyView.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(txtComputedHeight)
            make.bottom.equalTo(scrollView)
        }
        
    }
}
