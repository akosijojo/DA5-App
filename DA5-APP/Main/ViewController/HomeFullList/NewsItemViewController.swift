//
//  NewsItemViewController.swift
//  DA5-APP
//
//  Created by Jojo on 1/25/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

class NewsItemViewController: BaseHomeViewControler {
    var data : NewsData?
    
    lazy var scrollView : UIScrollView = {
        let v = UIScrollView()
        return v
    }()
    
    lazy var imageView : UIImageView = {
        let v = UIImageView()
        v.backgroundColor = .white
        return v
    }()
    
    lazy var descriptionLbl : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Fonts.regular, size: 16)
        v.numberOfLines = 0
        return v
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        getData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpNavigationBar()
    }
    
    init(data: NewsData?) {
        super.init(nibName: nil, bundle: nil)
        self.data = data
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getData() {
        self.imageView.downloaded(from: data?.image ?? "", contentMode: .scaleAspectFill)
        self.descriptionLbl.text =  data?.desc
        self.title = data?.name
    }
    
    override func setUpView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(view.layoutMarginsGuide.snp.top)
            
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom)
        }
        
        scrollView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView)
            make.height.equalTo(200)
            if ColorConfig().screenWidth > 500 {
                make.centerX.equalTo(view)
                make.width.equalTo(400)
            }else {
                make.leading.equalTo(view)
                make.trailing.equalTo(view)
            }
        }
        
        scrollView.addSubview(descriptionLbl)
        descriptionLbl.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(60)
            make.bottom.equalTo(scrollView).offset(-20)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
        }
        
    }
    
}
