//
//  CustomHeaderView.swift
//  DA5-APP
//
//  Created by Jojo on 8/27/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

class CustomHeaderView : UIView {
    lazy var mainTitle : UILabel = {
       let v = UILabel()
       v.font = UIFont(name: Fonts.bold, size: 20)
       return v
    }()
    
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
            make.bottom.equalTo(self)
        }
    }
}



class CustomHeaderView2 : UIView {
    lazy var mainTitle : UILabel = {
       let v = UILabel()
       v.font = UIFont(name: Fonts.bold, size: 20)
       return v
    }()
    
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
        addSubview(mainTitle)
        mainTitle.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(40)
        }
        
        addSubview(title)
        title.snp.makeConstraints { (make) in
            make.top.equalTo(mainTitle.snp.bottom)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(20)
        }
        addSubview(desc)
        desc.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom)
            make.leading.trailing.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
}


class CustomHeaderView2Desc : UIView {
    lazy var title : UILabel = {
       let v = UILabel()
       v.font = UIFont(name: Fonts.bold, size: 20)
       return v
    }()
    
    lazy var desc1 : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Fonts.regular, size: 12)
        return v
    }()
    lazy var desc2 : UILabel = {
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
        addSubview(desc1)
        desc1.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(10)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(20)
        }
        addSubview(desc2)
        desc2.snp.makeConstraints { (make) in
            make.top.equalTo(desc1.snp.bottom)
            make.leading.trailing.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
}
