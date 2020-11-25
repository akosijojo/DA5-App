//
//  Alert Extension.swift
//  DA5-APP
//
//  Created by Jojo on 9/8/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(_ buttonTitle: String, _ title: String, _ message: String, action: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: action))
        return alert
    }
}
