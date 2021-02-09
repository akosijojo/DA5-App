//
//  CollectionViewExtension.swift
//  DA5-APP
//
//  Created by Jojo on 12/16/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit
enum emptyViewType {
    case main
    case secondary
}

extension UICollectionView {
    
    func emptyView(image: String,text: String,dataCount: Int,emptyViewType: emptyViewType) {
//        print("Set Up Empty View")
        if dataCount == 0 {
            self.backgroundView = setEmptyViewUI(image: image, text: text, type: emptyViewType)
        }else {
            self.backgroundView = nil
        }
    
    }
    
    func setEmptyViewUI (image: String,text: String,type: emptyViewType) -> UIView {
        if image != "" {
            let img = UIImageView()
            img.contentMode = .scaleAspectFit
            img.tintColor = type == .main ? ColorConfig().lightGray : ColorConfig().txtSecondaryColor
            img.image = UIImage(named: image)?.withRenderingMode(.alwaysTemplate)
            
            let desc = UILabel()
            desc.font = type == .main ?  UIFont(name: Fonts.bold, size: 14) : UIFont(name: Fonts.regular, size: 12)
            desc.textColor = type == .main ? ColorConfig().lightGray : ColorConfig().txtSecondaryColor
            desc.minimumScaleFactor = 0.2
            desc.numberOfLines = 2
            desc.adjustsFontSizeToFitWidth = true
            desc.text = text
            desc.textAlignment = .center
            
            let mainView = UIView()
            mainView.frame = self.bounds
            mainView.addSubview(img)
            mainView.addSubview(desc)
            
            img.snp.makeConstraints { (make) in
                make.centerX.equalTo(mainView)
                make.width.equalTo(mainView).multipliedBy(0.9)
                make.height.equalTo(80)
                make.centerY.equalTo(mainView)
            }
            
            desc.snp.makeConstraints { (make) in
                make.centerX.equalTo(mainView)
                make.width.equalTo(mainView).multipliedBy(0.9)
                make.height.equalTo(40)
                make.top.equalTo(img.snp.bottom).offset(10)
            }
            
            return mainView
        }else {
        
            let desc = UILabel()
            desc.font = type == .main ?  UIFont(name: Fonts.bold, size: 14) : UIFont(name: Fonts.regular, size: 12)
            desc.textColor =  type == .main ? ColorConfig().lightGray : ColorConfig().txtSecondaryColor
            desc.minimumScaleFactor = 0.2
            desc.numberOfLines = 2
            desc.adjustsFontSizeToFitWidth = true
            desc.text = text != "" ? text : "Something went wrong. Please try again."
            desc.textAlignment = .center
            
            let mainView = UIView()
            mainView.frame = self.bounds
            mainView.addSubview(desc)
            desc.snp.makeConstraints { (make) in
                make.center.equalTo(mainView)
                make.height.equalTo(40)
                make.width.equalTo(mainView).multipliedBy(0.9)
            }
            
            return mainView
        }
    }
}
