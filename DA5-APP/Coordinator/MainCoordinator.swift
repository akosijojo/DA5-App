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
    var timer : Timer?
    
    var viewControllersActive : [UIViewController] = []
    var alertView : UIViewController?
    
    
    weak var parentCoordinator: MainCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var usersDataLocal = CustomerLocal().getCustomerFromLocal()
    var showPinOnChangeAppState : Bool = false
    
    var token : String? = ""
    
    var refreshToken : String? = ""

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.delegate = self
        navigationController.navigationBar.barTintColor = ColorConfig().white
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.black,
         NSAttributedString.Key.font: UIFont(name: Fonts.bold, size: 16)!]
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
            UserLoginData.shared.phoneNumber = data.phone
            saveCustomerToLocal(data: user)
        }
    }
    
    func saveCustomerToLocal(data: Customer?) {
        if !CustomerLocal().checkIfExistingData() {
            if let d = data {
               let getData =  d.convertToLocalData()
               getData.saveCustomerToLocal()
                print("USER SAVE TO COORDINATOR LOCAL")
                self.usersDataLocal = getData // SAVE TO coordinator local data for checking
           }
        }
       
    }
    
    func removeUserLogin() {
        UserLoginData.shared.id = nil
        UserLoginData.shared.firstName = nil
        UserLoginData.shared.middleName = nil
        UserLoginData.shared.lastName = nil
        UserLoginData.shared.image = nil
        UserLoginData.shared.phoneNumber = nil
    }
    
    func removeCustomerLocalData() {
        UserDefaults.standard.removeObject(forKey: AppConfig().customerLocalKey)
        self.usersDataLocal = nil
    }
    
    func removeRefreshTokenLocalData() {
        UserDefaults.standard.removeObject(forKey: AppConfig().refreshTokenLocalKey)
    }
    
    func logInCoordinator(didLogout: Bool? = nil) {
        if let _ = didLogout {
            self.removeCustomerLocalData()
            self.removeUserLogin()
            self.removeRefreshTokenLocalData()
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
      
    func signUpCoordinator(fbData: RegistrationForm? = nil) {
       let vc = SignUpViewController()
       vc.viewModel = LoginViewModel()
       vc.viewModel?.model = LoginModel()
        if let data = fbData {
            print("FBID : \(data.fbId)")
            vc.viewModel?.registrationForm = data
        }
       vc.coordinator = self
       navigationController.setNavigationBarHidden(false, animated: false)
       navigationController.pushViewController(vc, animated: false)
    }

    func pinCodeCoordinator(isChecking: Bool? = false,customerData: Customer? = nil,fromBackground: Bool = false, forgotMpin: Bool? = nil,refreshToken : String? = nil) {
        if !fromBackground {
            print("!FROM BACKGROUND ")
            self.setUpUserLogin(user: customerData)
        }
        
        //MARK: - Save Refresh token used in logout
        if let refToken = refreshToken {
            print("SAVING REFRESH TOKEN ")
            let rToken = RefreshTokenLocal(refreshToken: refToken)
            rToken.saveRefreshTokenLocal()
        }
        
        
        let vc = PinViewController()
        vc.coordinator = self
        vc.viewModel = LoginViewModel()
        vc.viewModel?.model = LoginModel()
        vc.customerData = customerData
        vc.isChecking = forgotMpin != nil ? true : usersDataLocal?.mpin == nil ? (customerData?.mpin == nil ? true : false) : false
        
        //MARK: - CHECKING IF FROM INACTIVE STATE
        if fromBackground {
            vc.fromBackground = fromBackground
        }
        
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func forgotMPINCoordinator(type: forgotPinType? = .phone) {
       let vc = ForgotPinViewController()
       vc.viewModel = LoginViewModel()
       vc.viewModel?.model = LoginModel()
        print("TYPE : \(type) = phone :\(usersDataLocal?.phone) == email : \(usersDataLocal?.email)")
        if type == .phone {
            vc.mobileNumber = usersDataLocal?.phone
        }else {
            vc.emailAddress = usersDataLocal?.email
        }
       vc.type = type ?? .phone
       vc.coordinator = self
       navigationController.setNavigationBarHidden(false, animated: false)
       navigationController.pushViewController(vc, animated: false)
    }
    
    func termsCoordinator(parentView: UIViewController?,forViewing: Bool? = nil) {
       let vc = TermsViewController(forViewing: forViewing)
       vc.coordinator = self
       vc.parentView = parentView
       navigationController.setNavigationBarHidden(false, animated: false)
       navigationController.pushViewController(vc, animated: false)
    }
    
    func showProfileViewController(data: Customer?) {
         let vc = ProfileViewController()
         vc.viewModel = LoginViewModel()
         vc.viewModel?.model = LoginModel()
         vc.data = data
         vc.coordinator = self
         navigationController.setNavigationBarHidden(false, animated: false)
         navigationController.pushViewController(vc, animated: false)
    }
    
    func showProfileVerificationViewController(data: Customer?, vM: LoginViewModel?, view: ProfileViewController?) {
        let vc = ProfileVerificationViewController()
        vc.validId = view?.validId
        vc.selfieId = view?.selfieId
        vc.viewModel = vM
        vc.viewModel?.model = vM?.model
        vc.mobileNumber = vM?.registrationForm?.phoneNumber
        vc.vc = view
//        vc.data = data
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
    
//    func showTermsViewController() {
//         let vc = TermsAndConditionsViewController()
//         vc.coordinator = self
//         navigationController.setNavigationBarHidden(false, animated: false)
//         navigationController.pushViewController(vc, animated: false)
//    }
//
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
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(vc, animated: false)
    }

    func showBase2ndViewController(title: String) {
       let vc = BaseSecondaryViewController()
       vc.coordinator = self
       vc.title = title
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
    //MARK: -COMMENT OUT TO HIDE PIN VIEW
    func becomeInActiveState() {
//        if let _ =  self.navigationController.viewControllers.first as? HomeViewController {
//            self.showPinOnChangeAppState = true
//        }else {
//             self.showPinOnChangeAppState = false
//        }
    }
    
    func becomeActiveState() {
//        if let usersData = usersDataLocal {
//            if self.showPinOnChangeAppState {
//                if let presentedView = self.navigationController.topViewController?.presentedViewController {
//                    self.alertView = presentedView
//                    self.navigationController.topViewController?.presentedViewController?.dismiss(animated: false, completion: nil)
//
//                }
//               self.viewControllersActive = self.navigationController.viewControllers
//               self.removeAllViewController()
//               self.pinCodeCoordinator(customerData: usersData.convertData(),fromBackground: true)
//            }
//        }
    }
    
    func gotoPreviousViewControllers() {
        self.navigationController.viewControllers = self.viewControllersActive
        if let alert = self.alertView {
             self.navigationController.topViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func removeAllViewController() {
        if let _ = usersDataLocal {
            if self.navigationController.viewControllers.count > 0 {
                self.navigationController.viewControllers.removeAll()
            }
       }
    }
    
    func updateToken(data: APIToken?) {
        DispatchQueue.main.async {
            let interval = TimeInterval(data?.expiresIn ?? 0)
                print("timer  \(data?.expiresIn) == \(interval)")
            self.timer = Timer.scheduledTimer(timeInterval: interval, target: self,   selector: (#selector(self.requestToken)), userInfo: nil, repeats: false)
        }
    }
    
    @objc func requestToken() {
        timer?.invalidate()
        for vc in self.navigationController.viewControllers {
            if let homeVc = vc as? HomeViewController {
                homeVc.viewModel?.generateAPIToken(update: true)
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


//MARK:- SERVICES
extension MainCoordinator {
    
    func showParentView() {
  
        for x in self.navigationController.viewControllers {
            if let homeVc = x as? HomeViewController {
                self.navigationController.viewControllers = [homeVc]
                homeVc.refreshData()
                return
            }
        }
//        var navigationArray = navigationController.viewControllers // To get all UIViewController stack as Array
//        navigationArray.remove(at: navigationArray.count - 2) // To remove previous UIViewController
//        self.navigationController?.viewControllers = navigationArray
    }
    
    func showLoadWalletViewController(type: Int? = 0) {
        let vc = LoadWalletViewController()
        vc.coordinator = self
        vc.type = type
        vc.viewModel = LoadWalletViewModel()
        vc.viewModel?.model = LoadWalletModel()
        vc.viewModel?.model?.token = self.token
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showCashInViewController(data: PartnerListItem?,type: Int? = 0) {
        let vc = WalletViewController(data: data,type:  type ?? 0)
        vc.coordinator = self
        vc.viewModel = LoadWalletViewModel()
        vc.viewModel?.model = LoadWalletModel()
        vc.viewModel?.model?.token = self.token
        vc.headerView.title.text = type == 0 ? "Cash In" : "Cash Out"
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showWalletTransferViewController() {
         let vc = WalletTransferViewController()
         vc.coordinator = self
         vc.viewModel = LoadWalletViewModel()
         vc.viewModel?.model = LoadWalletModel()
         vc.viewModel?.model?.token = self.token
         navigationController.setNavigationBarHidden(false, animated: false)
         navigationController.pushViewController(vc, animated: false)
    }
    
    func showWalletTransferDetailsViewController(data: WalletTransferData?) {
        let vc = WalletTransferDetailsViewController(data: data)
         vc.coordinator = self
         vc.viewModel = LoadWalletViewModel()
         vc.viewModel?.model = LoadWalletModel()
         vc.viewModel?.model?.token = self.token
         navigationController.setNavigationBarHidden(false, animated: false)
         navigationController.pushViewController(vc, animated: false)
    }
    
    func ShowELoadViewController() {
        let vc = ELoadViewController()
        vc.viewModel = ELoadViewModel()
        vc.viewModel?.model = ELoadModel()
//        vc.viewModel?.model?.token = self.token
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
        vc.coordinator = self
        vc.viewModel = ELoadViewModel()
        vc.viewModel?.model = ELoadModel()
//        vc.viewModel?.model?.token = self.token
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showBankTransferViewController() {
        let vc = BankTransferViewController()
        vc.coordinator = self
        vc.viewModel = BankTransferViewModel()
        vc.viewModel?.model = BankTransferModel()
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showBankTransferDetailsViewController(data: TransferDetails?) {
        let vc = BankTransferDetailsViewController(data: data)
        vc.coordinator = self
        vc.viewModel = BankTransferViewModel()
        vc.viewModel?.model = BankTransferModel()
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showFxViewController(balance: String?) {
       let vc = FXViewController(balance: balance)
       vc.coordinator = self
       vc.viewModel = FxViewModel()
       vc.viewModel?.model = FxModel()
       navigationController.setNavigationBarHidden(false, animated: false)
       navigationController.pushViewController(vc, animated: false)
    }
    
    func showPaybillsViewController() {
       let vc = PaybillsViewController()
       vc.coordinator = self
       vc.viewModel = PaybillsViewModel()
       vc.viewModel?.model = PaybillsModel()
       navigationController.setNavigationBarHidden(false, animated: false)
       navigationController.pushViewController(vc, animated: false)
    }
    
    func showPaybillsSelectedViewController(data: BillerData) {
        let vc = PaybillsSelectedItemViewController(data: data )
       vc.coordinator = self
       vc.viewModel = PaybillsViewModel()
       vc.viewModel?.model = PaybillsModel()
       navigationController.setNavigationBarHidden(false, animated: false)
       navigationController.pushViewController(vc, animated: false)
    }

    
    
    
}

//MARK:- FullList
extension MainCoordinator {
    func showNewsItem(data: NewsData?) {
        let vc = NewsItemViewController(data: data)
        vc.coordinator = self
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showNewsFullList() {
        let vc = NewsFullListViewController()
        vc.coordinator = self
        vc.viewModel = HomeFullListViewModel()
        vc.viewModel?.model = HomeFullListModel()
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showPendingTransactionFullList() {
        let vc = PendingTransactionFullViewController()
        vc.coordinator = self
        vc.viewModel = HomeFullListViewModel()
        vc.viewModel?.model = HomeFullListModel()
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showTransactionHistoryFullList() {
        let vc = TransactionsFullViewController()
        vc.coordinator = self
        vc.viewModel = HomeFullListViewModel()
        vc.viewModel?.model = HomeFullListModel()
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(vc, animated: false)
    }
    
    
}



