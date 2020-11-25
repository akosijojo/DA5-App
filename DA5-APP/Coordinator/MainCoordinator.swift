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
        
        //show login
        logInCoordinator()
        //show pin code
//        pinCodeCoordinator()
//        homeCoordinator()
    }
       
    func logInCoordinator() {
        let vc = LoginViewController()
        vc.coordinator = self
        navigationController.navigationBar.isHidden = false
        navigationController.pushViewController(vc, animated: false)
    }
      
    func signUpCoordinator() {
       let vc = SignUpViewController()
       vc.coordinator = self
       navigationController.navigationBar.isHidden = false
       navigationController.pushViewController(vc, animated: false)
    }
    
    func termsCoordinator() {
       let vc = TermsViewController()
       vc.coordinator = self
       navigationController.navigationBar.isHidden = false
       navigationController.pushViewController(vc, animated: false)
    }
    
    func dismissViewController() {
//        navigationController.navigationBar.isHidden = true
    }
    
    func homeCoordinator() {
       let vc = HomeViewController(collectionViewLayout: UICollectionViewFlowLayout())
        self.navigationController.navigationBar.isHidden = true
        vc.homeCoordinator = HomeCoordinator(navigationController: self.navigationController)
       vc.homeCoordinator?.start()
       vc.coordinator = self
       navigationController.pushViewController(vc, animated: false)
    }
    func sampleCoordinator() {
       let vc = FoodController()
//       vc.coordinator = self
       vc.navigationController?.navigationBar.isHidden = true
       navigationController.pushViewController(vc, animated: false)
    }

    func pinCodeCoordinator() {
       let vc = PinViewController()
       vc.coordinator = self
       vc.navigationController?.navigationBar.isHidden = true
       navigationController.pushViewController(vc, animated: false)
   }
    
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
        if let signupViewController = fromViewController as? SignUpViewController {
            // We're popping a buy view controller; end its coordinator
            childDidFinish(signupViewController.coordinator)
        }
    }
}
