//
//  HeaderCell.swift
//  DA5-APP
//
//  Created by Jojo on 1/25/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit
class HeaderCell: UICollectionReusableView {
    lazy var headerView : CustomHeaderView = {
      let v = CustomHeaderView()
      v.title.text = ""
      v.desc.text  = ""
      v.desc.numberOfLines = 0
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
        addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
           make.top.equalTo(self).offset(25)
           make.leading.equalTo(self).offset(20)
           make.trailing.equalTo(self).offset(-20)
           make.bottom.equalTo(self)
        }
    }
}
