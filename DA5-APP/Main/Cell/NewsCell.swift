//
//  NewsCell.swift
//  DA5-APP
//
//  Created by Jojo on 11/23/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit
protocol NewsCellDelegate: class {
    func onClickItem(cell: NewsCell, data: [String:AnyObject]? , type: Int)
}

class NewsCell: UICollectionViewCell {
    weak var delegate: NewsCellDelegate?
    var data : NewsData? {
        didSet {
            if let d = data {
                self.imageView.image = UIImage(named: d.image)
            }
        }
    }
    
    lazy var imageView : UIImageView = {
       let v = UIImageView()
        v.layer.cornerRadius = 10
        v.layer.masksToBounds = true
        v.clipsToBounds = true
        v.contentMode = .scaleAspectFill
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = ColorConfig().white
        setUpView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
        let rect = CGRect(x: 0, y: 5, width: self.frame.width, height: self.frame.height - 5)
        self.layer.shadowPath = UIBezierPath(rect:rect).cgPath
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.2
    }
    
    func setUpView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
        }
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClickItem))
        imageView.addGestureRecognizer(tap)
    }
    
    @objc func onClickItem() {
        self.delegate?.onClickItem(cell: self, data: nil, type: 3)
    }
    
}
