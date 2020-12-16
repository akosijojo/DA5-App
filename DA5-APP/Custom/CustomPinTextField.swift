//
//  CustomPinTextField.swift
//  DA5-APP
//
//  Created by Jojo on 11/19/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

class CustomPinTextField: UITextField {

    var defaultText = ""
    
    var didEnterFirstDigit : ((String) -> Void)?
    var didEnterLastDigit : ((String) -> Void)?
    
    private var isConfigured = false
    
    private var digitsLabel = [UILabel()]
    
    var labelStackView = UIStackView()
    
    var showBottomLine : Bool = false
    
    private lazy var tapRecognizer : UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(becomeFirstResponder))
        return recognizer
    }()
    
    func configure(with slotCount: Int = 6,kbShow: Bool = false) {
        guard isConfigured == false else {   return  }
        isConfigured.toggle()
        configureTextField()
        
        labelStackView = createLabelsStackView(with: slotCount)
        addSubview(labelStackView)
        if kbShow {
            addGestureRecognizer(tapRecognizer)
        }
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: topAnchor),
            labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        
    }
    
    private func configureTextField() {
        tintColor = .clear
        textColor = .clear
        keyboardType = .numberPad
        textAlignment = .center
        if #available(iOS 12.0, *) {
            textContentType = .oneTimeCode
        } else {
            
        }
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        delegate = self
    }
    
    private func createLabelsStackView(with count: Int) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        for lbl in 1...count {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: Fonts.bold, size: 45)
//            label.backgroundColor = .red
            label.isUserInteractionEnabled = true
            label.textColor = ColorConfig().lightGray
            label.text = defaultText
            label.textAlignment = .center
            label.tag = lbl
            //MARK: - show line if you can hahah
//            if showBottomLine {
//                label.addBorders(edges: .bottom, color: ColorConfig().lightGray!)
//            }
            stackView.addArrangedSubview(label)
            digitsLabel.append(label)
        }
        
        return stackView
    }
    
    @objc
    private func textDidChange() {
        guard let text = self.text, text.count <= digitsLabel.count else { return }
        for i in 1 ..< digitsLabel.count {
            let currentLabel = digitsLabel[i]
            if i < text.count + 1 {
                let index = text.index(text.startIndex, offsetBy: i)
                currentLabel.font = UIFont(name: Fonts.bold, size: 60)
                currentLabel.textColor = ColorConfig().black
            }else {
                currentLabel.font = UIFont(name: Fonts.bold, size: 45)
                currentLabel.textColor = ColorConfig().lightGray
            }
        }
        if text.count == digitsLabel.count - 1 {
            didEnterLastDigit?(text)
        }
    }
    
    func textUpdate(text: String?) {
           guard let text = text, text.count <= digitsLabel.count else { return }
           for i in 1 ..< digitsLabel.count {
               let currentLabel = digitsLabel[i]
               if i < text.count + 1 {
//                   let index = text.index(text.startIndex, offsetBy: i)
                   currentLabel.font = UIFont(name: Fonts.bold, size: 60)
                   currentLabel.textColor = ColorConfig().black
               }else {
                   currentLabel.font = UIFont(name: Fonts.bold, size: 45)
                   currentLabel.textColor = ColorConfig().lightGray
               }
           }
           if text.count == 1 {
               didEnterFirstDigit?(text)
           }
           if text.count == digitsLabel.count - 1 {
               didEnterLastDigit?(text)
           }
     }
    
    func clearText(isWrong: Bool? = nil) {
         for i in 1 ..< self.digitsLabel.count {
           let currentLabel = self.digitsLabel[i]
              if let _ = isWrong {
                UIView.animate(withDuration: 2) {
                    currentLabel.font = UIFont(name: Fonts.bold, size: 45)
                    currentLabel.textColor = ColorConfig().darkRed
                    self.labelStackView.layoutIfNeeded()
                }
              }else {
                  currentLabel.textColor = ColorConfig().lightGray
              }
          }
    }
    
}

extension CustomPinTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let charactersCount = textField.text?.count else { return false }
        return charactersCount < digitsLabel.count || string == ""
    }
}
