//
//  SideMenuViewController.swift
//  DA5-APP
//
//  Created by Jojo on 11/24/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

class SideMenuView : UIView {

    var menus : [String]  = ["Home", "Privacy", "Terms", "Share App","Logout"]

    private var menuViewLbl = [UILabel()]
    weak var vc : HomeViewController?
    var isShowMenu : Bool = false
    var widthMultiplier : CGFloat = 0.6 // percentage
    var userData : Customer? {
        didSet {
          if let profile = userData?.image,profile != "" {
               self.profileImg.downloaded(from: profile)
          }else {
              if let gender = userData?.gender {
                self.profileImg.image = gender == "male" ?  UIImage(named: "prof-man") : UIImage(named: "prof-woman")
              }
          }
        }
    }
    
    let containerView : UIView = {
        let v = UIView()
        v.backgroundColor = ColorConfig().blueViolet
        v.isUserInteractionEnabled = true
        return v
    }()
    
    let profileImg : UIImageView = {
       let v = UIImageView()
//        v.image = UIImage(named: "prof-man")
        v.clipsToBounds = true
        v.backgroundColor = ColorConfig().white
       return v
    }()
    
    let editBtn : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Fonts.medium, size: 12)
        v.textColor = ColorConfig().white
        v.isUserInteractionEnabled = true
        v.textAlignment = .center
        v.text = "Edit Profile"
        return v
    }()
    
    let menuView : UIStackView = {
        let v = UIStackView()
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isHidden = true
        backgroundColor = UIColor(white: 0, alpha: 0.2)
        setUpView()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func setUpView() {
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.width.equalTo(self).multipliedBy(widthMultiplier)
            make.bottom.equalTo(self)
        }
        
        containerView.addSubview(profileImg)
        profileImg.snp.makeConstraints { (make) in
            make.top.equalTo(containerView.layoutMarginsGuide.snp.top).offset(20)
            make.centerX.equalTo(containerView)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        profileImg.layer.cornerRadius = 50
        
        containerView.addSubview(editBtn)
        editBtn.snp.makeConstraints { (make) in
            make.top.equalTo(profileImg.snp.bottom).offset(5)
            make.centerX.equalTo(containerView)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        containerView.addSubview(menuView)
        menuView.snp.makeConstraints { (make) in
            make.top.equalTo(editBtn.snp.bottom).offset(40)
            make.leading.equalTo(containerView).offset(20)
            make.trailing.equalTo(containerView).offset(-20)
            make.height.equalTo(menus.count * 50)
        }
        
        let screenGesture = UIPanGestureRecognizer(target: self, action: #selector(dismissSelfAnimate(_:)))
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissSelf))
        self.gestureRecognizers = [tap,screenGesture]
        
        let containerGesture = UITapGestureRecognizer(target: self, action: #selector(containerAction))
        self.containerView.addGestureRecognizer(containerGesture)
        
        let editProfileTap = UITapGestureRecognizer(target: self, action: #selector(showProfileView))
        editBtn.addGestureRecognizer(editProfileTap)
        
        createLabelsStackView()
    }
        
    private func createLabelsStackView() {
        menuView.axis = .vertical
        menuView.alignment = .fill
        menuView.distribution = .fillEqually
        
        for lbl in 0...menus.count - 1 {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: menuView.frame.width, height: 40))
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: Fonts.medium, size: 14)
            label.isUserInteractionEnabled = true
            label.textColor = ColorConfig().white
            label.text = menus[lbl]
            label.tag = lbl
            let tap = UITapGestureRecognizer(target: self, action: #selector(labelAction(_:)))
            label.addGestureRecognizer(tap)
            menuView.addArrangedSubview(label)
            menuViewLbl.append(label)
        }
    }
    
    @objc func labelAction(_ gesture: UIGestureRecognizer) {
        switch gesture.view?.tag {
        case 0:
            print("0")
        case 1:
            vc?.coordinator?.showPrivacyViewController()
        case 2:
            vc?.coordinator?.termsCoordinator(parentView: nil, forViewing: true)
        case 3:
            self.shareApp()
        case 4:
            let rToken = RefreshTokenLocal().getRefreshTokenLocal()
            vc?.viewModel?.logout(rToken: rToken?.refreshToken)
            //MARK: show this and remove checking on vc to logout even without internet or error occured
//            vc?.coordinator?.logInCoordinator(didLogout: true)
        default:
            break
        }
        
    }
    
    func shareApp() {
        let text = "A mobile wallet that lets you send, save and more with your smartphone\n\nEnjoy Fast and easy payment."
        let img = UIImage(named: "app_logo")
        let url = AppConfig().appLink
         
        let shareAll = [text , img! , url] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        // Anything you want to exclude
       activityViewController.excludedActivityTypes = [
           UIActivity.ActivityType.print,
           UIActivity.ActivityType.assignToContact,
           UIActivity.ActivityType.saveToCameraRoll,
           UIActivity.ActivityType.addToReadingList,
       ]
           
        activityViewController.popoverPresentationController?.sourceView = vc?.view
        vc?.present(activityViewController, animated: true, completion: nil)
    }
    
    func updateSideMenu(width: CGFloat){
        isShowMenu = width > 0 ? true : false
        if isShowMenu {
           self.isHidden = false
           self.containerView.transform = CGAffineTransform(translationX: -(self.frame.width * widthMultiplier), y: 0)
        }
        let xPos = isShowMenu ? 0 : -(self.frame.width * widthMultiplier)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.containerView.transform = CGAffineTransform(translationX: xPos, y: 0)
            self.containerView.layoutIfNeeded()
        }, completion: { (res) in
            UIView.animate(withDuration: 0.2) {
                if !self.isShowMenu {
                    self.isHidden = true
                    self.layoutIfNeeded()
                }
            }
        })
        
        vc?.collectionView.isScrollEnabled = isShowMenu ? false : true
    }
    
    @objc func dismissSelfAnimate(_ gesture: UIPanGestureRecognizer ) {
        let position =  gesture.translation(in: self)
        let xPos = position.x
        switch gesture.state {
        case .began :
            break
        case .changed:
            if(position.x < 0)
            {
                self.containerView.transform = CGAffineTransform(translationX: xPos, y: 0)
            }
        case .ended:
            if xPos < -50 {
                self.updateSideMenu(width: 0)
            }else {
                UIView.animate(withDuration: 0.5) {
                    self.containerView.transform = CGAffineTransform(translationX: 0, y: 0)
                    self.containerView.layoutIfNeeded()
                }
            }
        case .possible:
            break
        case .cancelled:
            break
        case .failed:
            break
        @unknown default:
            break
        }
      
    
    }
    
    @objc func dismissSelf() {
        updateSideMenu(width: 0)
    }
    
    @objc func containerAction() {
        
    }
    
    @objc func showProfileView() {
        if vc?.customerData?.kycStatus == nil {
            vc?.customerData?.kycStatus = 0
        }
        vc?.coordinator?.showProfileViewController(data: vc?.customerData)
    }
}

