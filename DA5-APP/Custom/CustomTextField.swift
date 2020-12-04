//
//  CustomTextField.swift
//  DA5-APP
//
//  Created by Jojo on 8/19/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit
class CustomTextField: UITextField {
    var padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
