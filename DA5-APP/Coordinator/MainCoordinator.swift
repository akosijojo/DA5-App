//
//  MainCoordinator.swift
//  DA5-APP
//
//  Created by Jojo on 8/18/20.
//  Copyright © 2020 OA. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator :  NSObject, Coordinator {
    weak var parentCoordinator: MainCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var usersDataLocal = CustomerLocal().getCustomerFromLocal()
    var showPinOnChangeAppState : Bool = false
    
    var token : String? = ""

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        navigationController.delegate = self
        navigationController.navigationBar.barTintColor = ColorConfig().white
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        
//        if user {
//            homeCoordinator()
//        }else {
//            logInCoordinator() // no account
//            pinCodeCoordinator(isChecking: true) // have account not logged in
//        }
        if let customerLocalData = usersDataLocal{
            pinCodeCoordinator(customerData: customerLocalData.convertData()) // have account not logged in
        }else {
             logInCoordinator()
        }
        
    }
    
    func setUpUserLogin(user: Customer?) {
        if let data = user {
            UserLoginData.shared.id = data.id
            UserLoginData.shared.firstName = data.firstName
            UserLoginData.shared.middleName = data.middleName
            UserLoginData.shared.lastName = data.lastName
            UserLoginData.shared.image = data.image
        }
    }
    
    func removeUserLogin() {
        UserLoginData.shared.id = nil
        UserLoginData.shared.firstName = nil
        UserLoginData.shared.middleName = nil
        UserLoginData.shared.lastName = nil
        UserLoginData.shared.image = nil
    }
    
    func removeCustomerLocalData() {
        UserDefaults.standard.removeObject(forKey: AppConfig().customerLocalKey)
    }
    
    func logInCoordinator(didLogout: Bool? = nil) {
        if let _ = didLogout {
            self.removeCustomerLocalData()
            self.removeUserLogin()
        }
        
        if self.navigationController.viewControllers.count > 0 {
           self.navigationController.viewControllers.removeAll()
        }
        let vc = LoginViewController()
        vc.coordinator = self
        vc.viewModel = LoginViewModel()
        vc.viewModel?.model = LoginModel()
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(vc, animated: false)
    }
      
    func signUpCoordinator() {
       let vc = SignUpViewController()
       vc.viewModel = LoginViewModel()
       vc.viewModel?.model = LoginModel()
       vc.coordinator = self
       navigationController.setNavigationBarHidden(false, animated: false)
       navigationController.pushViewController(vc, animated: false)
    }

    func pinCodeCoordinator(isChecking: Bool? = false,customerData: Customer? = nil) {
        self.setUpUserLogin(user: customerData)
        let vc = PinViewController()
        vc.coordinator = self
        vc.viewModel = LoginViewModel()
        vc.viewModel?.model = LoginModel()
        vc.customerData = customerData
        vc.isChecking = usersDataLocal?.mpin == nil ? (customerData?.mpin == nil ? true : false) : false
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func forgotMPINCoordinator() {
       let vc = ForgotPinViewController()
       vc.viewModel = LoginViewModel()
       vc.viewModel?.model = LoginModel()
       vc.mobileNumber = usersDataLocal?.phone
       vc.emailAddress = usersDataLocal?.email
       vc.coordinator = self
       navigationController.setNavigationBarHidden(false, animated: false)
       navigationController.pushViewController(vc, animated: false)
    }
    
    func termsCoordinator(parentView: UIViewController?) {
       let vc = TermsViewController()
       vc.coordinator = self
       vc.parentView = parentView
       navigationController.setNavigationBarHidden(false, animated: false)
       navigationController.pushViewController(vc, animated: false)
    }
    
    func showProfileViewController(data: AccountData?) {
         let vc = ProfileViewController()
         vc.accountData = data
         vc.coordinator = self
         navigationController.setNavigationBarHidden(false, animated: false)
         navigationController.pushViewController(vc, animated: false)
    }
    
    func showPrivacyViewController() {
         let vc = PrivacyViewController()
         vc.coordinator = self
         navigationController.setNavigationBarHidden(false, animated: false)
         navigationController.pushViewController(vc, animated: false)
    }
    
    func showTermsViewController() {
         let vc = TermsAndConditionsViewController()
         vc.coordinator = self
         navigationController.setNavigationBarHidden(false, animated: false)
         navigationController.pushViewController(vc, animated: false)
    }
    
    func dismissViewController() {
//        navigationController.navigationBar.isHidden = true
    }
    
    func homeCoordinator(setAsRoot: Bool = false) {
        if self.navigationController.viewControllers.count > 0 {
            self.navigationController.viewControllers.removeAll()
        }
        let vc = HomeViewController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.coordinator = self
        vc.viewModel = HomeViewModel()
        vc.viewModel?.model = HomeModel()
        if let user = self.usersDataLocal {
            vc.customerData = user.convertData()
        }else {
            vc.customerData = CustomerLocal().getCustomerFromLocal()?.convertData()
        }
        vc.customerData = self.usersDataLocal?.convertData()
        print("DATA CUSTOMER : \(self.usersDataLocal?.convertData())")
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(vc, animated: false)
    }

    func showBase2ndViewController() {
       let vc = BaseSecondaryViewController()
       vc.coordinator = self
       navigationController.setNavigationBarHidden(false, animated: false)
       navigationController.pushViewController(vc, animated: false)
    }
    
    // used when 2 or more coordinators
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func becomeInActiveState() {
        print("VIEW CONTROLLERS : \(self.navigationController.viewControllers)")
        if let _ =  self.navigationController.viewControllers.last as? PinViewController {
            self.showPinOnChangeAppState = false
        }else {
             self.showPinOnChangeAppState = true
        }
    }
    func becomeActiveState() {
        if let usersData = usersDataLocal {
            if self.showPinOnChangeAppState {
               self.removeAllViewController()
               self.pinCodeCoordinator(customerData: usersData.convertData())
            }
        }
    }
    
    func removeAllViewController() {
        if let _ = usersDataLocal {
            if self.navigationController.viewControllers.count > 0 {
                 print("REMOVING ACTIVE VIEWS : \(self.navigationController.viewControllers.count)")
                self.navigationController.viewControllers.removeAll()
            }
       }
    }
}

extension MainCoordinator : UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Read the view controller we’re moving from.
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }

        // Check whether our view controller array already contains that view controller. If it does it means we’re pushing a different view controller on top rather than popping it, so exit.
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }

        // We’re still here – it means we’re popping the view controller, so we can check whether it’s a buy view controller
        if let homeViewController = fromViewController as? HomeViewController {
            // We're popping a buy view controller; end its coordinator
            print("HEY POPPING HOME")
            childDidFinish(homeViewController.coordinator)
        }
    }
}


extension MainCoordinator {
    func showLoadWalletViewController(type: Int? = 0) {
        let vc = LoadWalletViewController()
        vc.coordinator = self
        vc.type = type
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(vc, animated: false)
    }
    func showCashInViewController(data: CashInData?,type: Int? = 0) {
        let vc = WalletViewController(data: data,type:  type ?? 0)
        vc.coordinator = self
        vc.viewModel = LoadWalletViewModel()
        vc.viewModel?.model = LoadWalletModel()
        vc.viewModel?.model?.token = self.token
        vc.headerView.title.text = type == 0 ? "Cash In" : "Cash Out"
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func ShowELoadViewController() {
        let vc = ELoadViewController()
        vc.viewModel = ELoadViewModel()
        vc.viewModel?.model = ELoadModel()
        vc.viewModel?.model?.token = self.token
        vc.coordinator = self
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func ShowELoadProductsViewController(data: [ELoadProducts?],phone: String?) {
        let vc = ELoadProductsViewController(data: data, phone: phone)
        vc.viewModel = ELoadViewModel()
        vc.viewModel?.model = ELoadModel()
        vc.coordinator = self
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(vc, animated: false)
   }
    
    func ShowELoadRegularViewController(data: ELoadProducts? , phone: String?) {
        let vc = ELoadRegularViewController(data: data, phone: phone)
        vc.viewModel = ELoadViewModel()
        vc.viewModel?.model = ELoadModel()
        vc.coordinator = self
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(vc, animated: false)
    }

    func ShowELoadProductDetailsViewController(data: ELoadProducts? , phone: String?) {
        let vc = ELoadProductDetailsViewController(data: data, phone: phone)
        vc.viewModel = ELoadViewModel()
        vc.viewModel?.model = ELoadModel()
        vc.coordinator = self
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showCashOutViewController() {
//       let vc = WalletViewController()
//       vc.coordinator = self
//       navigationController.setNavigationBarHidden(false, animated: false)
//       navigationController.pushViewController(vc, animated: false)
    }
}
