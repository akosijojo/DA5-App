//
//  Alert Extension.swift
//  DA5-APP
//
//  Created by Jojo on 9/8/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(_ buttonTitle: String, _ title: String, _ message: String, action: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: action))
        return alert
    }
    
    func alertAction(_ buttonOk: String,_ buttonCancel: String, _ title: String, _ message: String, actionOk: ((UIAlertAction) -> Void)?,actionCancel: ((UIAlertAction) -> Void)?) -> UIAlertController {
          let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
          alert.addAction(UIAlertAction(title: buttonOk, style: .default, handler: actionOk))
         alert.addAction(UIAlertAction(title: buttonCancel, style: .default, handler: actionCancel))
          return alert
   }
}
