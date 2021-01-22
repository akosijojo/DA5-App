//
//  LoadWalletCell.swift
//  DA5-APP
//
//  Created by Jojo on 12/17/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit


class LoadWalletHeaderCell: UICollectionReusableView {

     lazy var headerView : CustomHeaderView = {
          let v = CustomHeaderView()
          v.title.text = "Load Wallet!"
          v.desc.text  = "Choose your preferred cash-in method"
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

protocol LoadWalletCellDelegate: class {
    func onClickItem(cell: LoadWalletCell, index: Int)
}

class LoadWalletCell: UICollectionViewCell {

    var delegate : LoadWalletCellDelegate?
    
    var index : Int = 0
    
    lazy var imageViewContainer : UIView = {
      let v = UIView()
      return v
    }()
    
    lazy var imageView : UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 10
        v.layer.masksToBounds = true
        v.clipsToBounds = true
        v.contentMode = .scaleAspectFill
//        v.layer.borderWidth = 1
//        v.layer.borderColor = ColorConfig().lightGray?.cgColor
        return v
    }()
    
    var datePicker : UIDatePicker?
    
    var data : CashInData? {
        didSet {
            self.imageView.image = UIImage(named: self.data?.image ?? "")
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
       super.layoutSubviews()
       imageViewContainer.layer.cornerRadius = 10
        imageView.backgroundColor = .white
       let rect = CGRect(x: 0, y: 5, width: imageViewContainer.frame.width, height: imageViewContainer.frame.height - 5)
       imageViewContainer.backgroundColor = .white
       imageViewContainer.layer.shadowPath = UIBezierPath(rect:rect).cgPath
       imageViewContainer.layer.shadowRadius = 4
       imageViewContainer.layer.shadowOffset = .zero
       imageViewContainer.layer.shadowOpacity = 0.2
    }
  
    
    func setUpView() {
        addSubview(imageViewContainer)
        imageViewContainer.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
        }
        
       imageViewContainer.addSubview(imageView)
       imageView.snp.makeConstraints { (make) in
           make.top.equalTo(imageViewContainer)
           make.leading.equalTo(imageViewContainer)
           make.trailing.equalTo(imageViewContainer)
           make.bottom.equalTo(imageViewContainer)
       }
        
       imageView.isUserInteractionEnabled = true
       let tap = UITapGestureRecognizer(target: self, action: #selector(onClickItem))
       imageView.addGestureRecognizer(tap)
   }
   
   @objc func onClickItem() {
       self.delegate?.onClickItem(cell: self, index: index)
   }
}
