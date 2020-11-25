//
//  CustomHeaderView.swift
//  DA5-APP
//
//  Created by Jojo on 8/27/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

class CustomHeaderView : UIView {
    lazy var title : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Fonts.bold, size: 20)
        return v
    }()
    lazy var desc : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Fonts.regular, size: 12)
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
        addSubview(title)
        title.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(40)
        }
        addSubview(desc)
        desc.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(20)
        }
    }
}
