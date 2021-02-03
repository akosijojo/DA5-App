//
//  SubmitFooterViewCell.swift
//  DA5-APP
//
//  Created by Jojo on 1/31/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

protocol SubmitFooterViewCellDelegate : class {
    func onSubmit(cell: SubmitFooterViewCell)
}

class SubmitFooterViewCell: UICollectionReusableView {
    
    var delegate : SubmitFooterViewCellDelegate?
    
    lazy var submitBtn : UIButton = {
      let v = UIButton()
       v.layer.cornerRadius = 5
       v.backgroundColor = ColorConfig().black
       v.setTitle("Proceed", for: .normal)
       v.titleLabel?.font = UIFont(name: Fonts.medium, size: 12)
       v.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
      return v
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpView() {
        addSubview(submitBtn)
        submitBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(20)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.bottom.equalTo(self).offset(-20)
        }
    }
    
    @objc func submitAction() {
        self.delegate?.onSubmit(cell: self)
    }
}
