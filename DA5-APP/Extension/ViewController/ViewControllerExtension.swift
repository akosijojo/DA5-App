//
//  ViewControllerExtension.swift
//  DA5-APP
//
//  Created by Jojo on 12/4/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


fileprivate var overlay : UIView?

fileprivate var actView : UIView?
fileprivate var actTxt : UILabel?

extension UIViewController : NVActivityIndicatorViewable {
    
    func setAnimate(msg: String) {
        let size = CGSize(width: 30, height: 30)
        DispatchQueue.main.async {
            self.startAnimating(size, message: msg,messageFont:UIFont(name: Fonts.regular, size: 12), type: NVActivityIndicatorType.circleStrokeSpin, fadeInAnimation: nil)
        }
    }
    
    
    func showAnimation (msg: String) {
        self.navigationController?.navigationBar.isTranslucent = true
        overlay = UIView(frame: self.view.bounds)
        overlay?.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
       
        let ai = UIActivityIndicatorView(style: .gray)
        ai.center = overlay!.center
        ai.startAnimating()
        overlay?.addSubview(ai)
        self.view.addSubview(overlay!)
    }
    
    func removeShowedAnimation() {
        self.navigationController?.navigationBar.isTranslucent = false
        overlay?.removeFromSuperview()
        overlay = nil
    }
}
