//
//  CustomProgressView.swift
//  DA5-APP
//
//  Created by Jojo on 12/7/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

class CustomProgressView: UIView {
    var isAnimating : Bool = false
    lazy var container : UIView = {
        let v = UIView()
        v.layer.cornerRadius = 5
        v.backgroundColor = .white
        return v
    }()

    lazy var title : UILabel = {
       let v = UILabel()
       v.font = UIFont(name: Fonts.medium, size: 12)
        v.textAlignment = .center
       return v
    }()
    
    lazy var activtyIndicator : UIActivityIndicatorView = {
        let v = UIActivityIndicatorView(style: .gray)
        v.hidesWhenStopped = true
        return v
    }()

    lazy var message : UILabel = {
      let v = UILabel()
      v.font = UIFont(name: Fonts.regular, size: 12)
        
        v.textAlignment = .center
        
      return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        setUpView()
        self.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView(height: CGFloat){
    
        addSubview(container)
        container.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.leading.equalTo(self).offset(40)
            make.trailing.equalTo(self).offset(-40)
            make.height.equalTo(height)
        }
        container.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.top.equalTo(container).offset(10)
            make.leading.equalTo(container).offset(10)
            make.trailing.equalTo(container).offset(-10)
            make.height.equalTo(20)
        }
        container.addSubview(activtyIndicator)
        activtyIndicator.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(5)
            make.width.equalTo(40)
            make.centerX.equalTo(container)
            make.height.equalTo(20)
        }
        container.addSubview(message)
        message.snp.makeConstraints { (make) in
            make.top.equalTo(activtyIndicator.snp.bottom).offset(5)
            make.leading.equalTo(container).offset(10)
            make.trailing.equalTo(container).offset(-10)
            make.height.equalTo(20)
        }
    }
    
    func removeViews() {
        self.title.removeFromSuperview()
        self.container.removeFromSuperview()
        self.message.removeFromSuperview()
     
        self.activtyIndicator.removeFromSuperview()
    }
    
    func runLoadingAnimation(vc: UIViewController?,navBar: UINavigationBar? ,view: UIView, title: String?, message: String?) {
        if !isAnimating {
            
             UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.alpha = 1
             }) { (res) in
               
             }

             if let nav = navBar {
                 nav.isTranslucent = true
             }
             view.addSubview(self)
             self.frame = view.frame
             self.title.text = title
             self.message.text = message
             setUpView(height: 90)//returnHeight(title: title, msg: message)
             self.activtyIndicator.startAnimating()
             self.isAnimating = true
             UIApplication.shared.beginIgnoringInteractionEvents()
        }else {
            self.title.text = title
            self.message.text = message
        }
    }
    
    
    func returnHeight(title: String?, msg: String?) -> CGFloat {
        var height : CGFloat = 40
        if let _ = title {
            height += 25
        }
        if let _ = msg {
            height += 25
        }
        return height
    }
    
    func removeLoadingAnimation(vc: UIViewController?, navBar: UINavigationBar?)  {
        if isAnimating {
            self.activtyIndicator.stopAnimating()
            removeViews()
            isAnimating = false
            if let nav = navBar {
                nav.isTranslucent = true
            }
            UIApplication.shared.endIgnoringInteractionEvents()
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.alpha = 0
            }) { (res) in
                self.removeFromSuperview()
                self.layoutIfNeeded()
            }
        }
    }
    
}
