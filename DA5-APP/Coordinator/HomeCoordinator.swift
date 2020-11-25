//
//  HomeCoordinator.swift
//  DA5-APP
//
//  Created by Jojo on 8/27/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

class HomeCoordinator: NSObject, Coordinator{
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        // we'll add code here
        navigationController.delegate = self
        navigationController.navigationBar.barTintColor = ColorConfig().white
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
    }
    
    func showSample() {
          let vc = FoodController()
          navigationController.navigationBar.isHidden = false
          navigationController.pushViewController(vc, animated: false)
    }
    
    func showBase2ndViewController() {
          let vc = BaseSecondaryViewController()
          vc.homeCoordinator = self
          navigationController.navigationBar.isHidden = false
          navigationController.pushViewController(vc, animated: false)
    }
    
    func showProfileViewController(data: AccountData?) {
         let vc = ProfileViewController()
         vc.accountData = data
         vc.homeCoordinator = self
         navigationController.navigationBar.isHidden = false
         navigationController.pushViewController(vc, animated: false)
    }
    
    func showPrivacyViewController() {
         let vc = PrivacyViewController()
         vc.homeCoordinator = self
         navigationController.navigationBar.isHidden = false
         navigationController.pushViewController(vc, animated: false)
    }
    
    func showTermsViewController() {
         let vc = TermsAndConditionsViewController()
         vc.homeCoordinator = self
         navigationController.navigationBar.isHidden = false
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

extension HomeCoordinator : UINavigationControllerDelegate{
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
