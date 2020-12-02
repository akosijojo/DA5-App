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
            logInCoordinator() // no account
//            pinCodeCoordinator() // have account not logged in
//        }
    }
    
    func logInCoordinator() {
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

    func pinCodeCoordinator() {
        let vc = PinViewController()
        vc.coordinator = self
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func termsCoordinator() {
       let vc = TermsViewController()
       vc.coordinator = self
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
