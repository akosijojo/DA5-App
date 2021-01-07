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
    
    lazy var imageView : UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 10
        v.layer.masksToBounds = true
        v.clipsToBounds = true
        v.contentMode = .scaleAspectFill
        return v
    }()
    
    var datePicker : UIDatePicker?
    
    var data : NewsData? {
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
//       let rect = CGRect(x: 0, y: 5, width: imageView.frame.width, height: imageView.frame.height - 5)
//       imageView.backgroundColor = .white
//       imageView.layer.shadowPath = UIBezierPath(rect:rect).cgPath
//       imageView.layer.shadowRadius = 4
//       imageView.layer.shadowOffset = .zero
//       imageView.layer.shadowOpacity = 0.2
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
       self.delegate?.onClickItem(cell: self, index: index)
   }
}
