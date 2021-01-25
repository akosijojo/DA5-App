//
//  NewsItemViewController.swift
//  DA5-APP
//
//  Created by Jojo on 1/25/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

class NewsItemViewController: BaseHomeViewControler {
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
        self.title = "News Sample"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpNavigationBar()
    }
    
    func getData() {
        self.imageView.image = UIImage(named: "app_logo")
        self.descriptionLbl.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
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
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
        }
        
        scrollView.addSubview(descriptionLbl)
        descriptionLbl.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.bottom.equalTo(scrollView).offset(-20)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
        }
        
    }
    
}
