//
//  HeaderCollectionViewCell.swift
//  DA5-APP
//
//  Created by Jojo on 11/20/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

class HeaderCollectionViewCell: UICollectionReusableView {
    let label = UILabel()
    let rightBtn = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.font = UIFont(name: Fonts.regular, size: 12)
        rightBtn.font = UIFont(name: Fonts.regular, size: 10)
        rightBtn.textColor = ColorConfig().lightBlue
        rightBtn.isHidden = true
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    func setUpView() {
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self).offset(20)
            make.width.equalTo(self).multipliedBy(0.6)
            make.bottom.equalTo(self)
        }
        addSubview(rightBtn)
        rightBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.trailing.equalTo(self).offset(-20)
            make.width.equalTo(40)
            make.bottom.equalTo(self)
        }
    }
    
    func addAction() {
        rightBtn.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewAll))
        rightBtn.addGestureRecognizer(tap)
        rightBtn.isHidden = false
    }
    @objc func viewAll() {
        print("TAPPING HEADER")
    }
}