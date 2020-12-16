//
//  CollectionViewExtension.swift
//  DA5-APP
//
//  Created by Jojo on 12/16/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func emptyView(image: String,text: String,dataCount: Int) {
        if dataCount == 0 {
            self.backgroundView = setEmptyViewUI(image: image, text: text)
        }else {
            self.backgroundView = nil
        }
    
    }
    
    func setEmptyViewUI (image: String,text: String) -> UIView {
        if image != "" {
            let img = UIImageView()
            img.contentMode = .scaleAspectFit
            img.image = UIImage(named: image)?.withRenderingMode(.alwaysOriginal)
            
            let desc = UILabel()
            desc.font = UIFont(name: Fonts.bold, size: 20)
            desc.textColor = ColorConfig().txtSecondaryColor
            desc.minimumScaleFactor = 0.2
            desc.numberOfLines = 2
            desc.adjustsFontSizeToFitWidth = true
            desc.text = text
            desc.textAlignment = .center
            
            let mainView = UIView()
            mainView.addSubview(img)
            mainView.addSubview(desc)
            
            img.snp.makeConstraints { (make) in
                make.centerX.equalTo(mainView)
                make.width.equalTo(ColorConfig().screenWidth - 40)
                make.height.equalTo(ColorConfig().screenWidth - 40)
                make.centerY.equalTo(mainView)
            }
            
            desc.snp.makeConstraints { (make) in
                make.centerX.equalTo(mainView)
                make.width.equalTo(ColorConfig().screenWidth - 40)
                make.height.equalTo(40)
                make.top.equalTo(img.snp.bottom).offset(10)
            }
            
            return mainView
        }else {
        
            let desc = UILabel()
            desc.font = UIFont(name: Fonts.bold, size: 20)
            desc.textColor = ColorConfig().txtSecondaryColor
            desc.minimumScaleFactor = 0.2
            desc.numberOfLines = 2
            desc.adjustsFontSizeToFitWidth = true
            desc.text = text != "" ? text : "Something went wrong. Please try again."
            desc.textAlignment = .center
            
            let mainView = UIView()
            mainView.addSubview(desc)
            desc.snp.makeConstraints { (make) in
                make.centerX.equalTo(mainView)
                make.centerY.equalTo(ColorConfig().screenWidth - 40)
                make.height.equalTo(ColorConfig().screenWidth - 40)
                make.width.equalTo(ColorConfig().screenWidth - 40)
            }
            
            return mainView
        }
    }
}

