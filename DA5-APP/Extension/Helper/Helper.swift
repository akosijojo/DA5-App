//
//  Helper.swift
//  DA5-APP
//
//  Created by Jojo on 12/3/20.
//  Copyright © 2020 OA. All rights reserved.
//

import Foundation
import PKHUD

public class Helper: NSObject {
    
    func onShowProgress() {
        HUD.show(.progress)
    }
    
    func onProgress(title: String?,message: String?) {
        HUD.flash(.labeledProgress(title: title, subtitle: message), delay: 500)
    }
    
    func onHideHUD() {
        HUD.hide()
    }
    
    func openlink(link: String? = "") {
        let text = link!
        
        guard let url = URL(string: text) else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
