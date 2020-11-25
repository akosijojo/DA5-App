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

}


class BaseHomeViewControler : UIViewController {
    weak var coordinator : MainCoordinator?
    var homeCoordinator : HomeCoordinator?
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
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "arrow_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = ColorConfig().darkBlue
        backButton.addTarget(self, action: #selector(navBackAction), for: .touchUpInside)
        let leftButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = leftButton
    }

}


class BaseCollectionViewControler : UICollectionViewController {
    weak var coordinator : MainCoordinator?
    var homeCoordinator : HomeCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorConfig().bgColor
        setUpView()
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

}
