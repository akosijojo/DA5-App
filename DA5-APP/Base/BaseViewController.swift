//
//  BaseViewController.swift
//  DA5-APP
//
//  Created by Jojo on 8/18/20.
//  Copyright © 2020 OA. All rights reserved.
//

import Foundation
import UIKit

class BaseViewControler : UIViewController {
    weak var coordinator : MainCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorConfig().bgColor
        setUpView()
        getData()
    }
    
    func getData() {
//         self.viewModel?.onErrorHandling = { [weak self] error in
//            print("ERROR : \(error?.message)")
//
//            if let stat = error {
//                self?.showErrorAlert(status: stat)
//            }
////            self?.stopLoading()
//        }
    }
    
    func setUpView() {
        
    }
    
    func setUpData() {
        
    }
    
    @objc func navBackAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissBackAction(completion: (() -> Void)?){
        self.dismiss(animated: true, completion: completion)
    }
    
    deinit {
        
    }
    
    func setUpNavigationBar() {
       self.navigationController?.navigationBar.isHidden = false
       self.navigationController?.setNavigationBarHidden(false, animated: false)
       let backButton = UIButton(type: .system)
       backButton.setImage(UIImage(named: "arrow_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
       backButton.tintColor = ColorConfig().darkBlue
       backButton.addTarget(self, action: #selector(navBackAction), for: .touchUpInside)
       let leftButton = UIBarButtonItem(customView: backButton)
       self.navigationItem.leftBarButtonItem = leftButton
   }
    
   func showAlert(buttonOK: String, buttonCancel: String? = nil, title: String = "", message: String,actionOk: ((UIAlertAction) -> Void)? ,actionCancel:  ((UIAlertAction) -> Void)? = nil, completionHandler: (() -> Void)?) {
        if buttonCancel == nil {
            let alert = self.alert(buttonOK, title, message, action: actionOk)
            self.present(alert, animated: true, completion: completionHandler)
        }else {
            let alert = self.alertAction(buttonOK, buttonCancel ?? "Cancel", title, message, actionOk: actionOk, actionCancel: actionCancel)
            self.present(alert, animated: true, completion: completionHandler)
        }
   }


}


class BaseHomeViewControler : UIViewController {
    weak var coordinator : MainCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorConfig().bgColor
        setUpView()
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
    }
    
    func setUpView() {
        
    }
    
    func setUpData() {
        
    }
    
    @objc func navBackAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissBackAction(completion: (() -> Void)?){
        self.dismiss(animated: true, completion: completion)
    }
    
    deinit {
        print("DEINIT")
    }
    
    func setUpNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "arrow_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = ColorConfig().darkBlue
        backButton.addTarget(self, action: #selector(navBackAction), for: .touchUpInside)
        let leftButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = leftButton
    }

    func showAlert(buttonOK: String, buttonCancel: String? = nil, title: String = "", message: String,actionOk: ((UIAlertAction) -> Void)? ,actionCancel:  ((UIAlertAction) -> Void)? = nil, completionHandler: (() -> Void)?) {
       if buttonCancel == nil {
           let alert = self.alert(buttonOK, title, message, action: actionOk)
           self.present(alert, animated: true, completion: completionHandler)
       }else {
           let alert = self.alertAction(buttonOK, buttonCancel ?? "Cancel", title, message, actionOk: actionOk, actionCancel: actionCancel)
           self.present(alert, animated: true, completion: completionHandler)
       }
    }
}


class BaseCollectionViewControler : UICollectionViewController {
    weak var coordinator : MainCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorConfig().bgColor
        setUpView()
    }
    
    func setUpView() {
        
    }
    
    func getData() {
        
    }
    
    @objc func navBackAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissBackAction(completion: (() -> Void)?){
        self.dismiss(animated: true, completion: completion)
    }
    
    deinit {
        
    }

}
