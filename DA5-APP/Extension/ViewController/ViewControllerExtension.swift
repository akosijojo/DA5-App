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
//        print("MSG: ",msg)
        DispatchQueue.main.async {
            self.startAnimating(size, message: msg,messageFont:UIFont(name: Fonts.regular, size: 12), type: NVActivityIndicatorType.circleStrokeSpin, fadeInAnimation: nil)
        }
    }
    
    
    func showAnimation (msg: String) {
        self.navigationController?.navigationBar.isTranslucent = true
//        if let _ = actTxt , actTxt?.text != msg {x
//        }else {
            overlay = UIView(frame: self.view.bounds)
            overlay?.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
//            actView = UIView()
//            actView?.center = overlay!.center
//            actView?.frame = CGRect(x: 0, y: 0, width: overlay?.frame.width ?? 20.0 / 2, height: 80.0)
          
           
            let ai = UIActivityIndicatorView(style: .gray)
            ai.center = overlay!.center
            ai.startAnimating()
//            actTxt = UILabel()
//            actTxt?.text = msg
//            actTxt?.frame =  CGRect(x: 0, y: 20, width: 20, height: 20)
            overlay?.addSubview(ai)
//            actView?.addSubview(actTxt!)
//            overlay?.addSubview(actView!)
            self.view.addSubview(overlay!)
//        }
        
    }
    
    func removeShowedAnimation() {
        self.navigationController?.navigationBar.isTranslucent = false
        overlay?.removeFromSuperview()
        overlay = nil
    }
}
