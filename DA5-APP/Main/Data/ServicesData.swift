//
//  ServicesData.swift
//  DA5-APP
//
//  Created by Jojo on 11/24/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

struct ServicesData:Decodable {
    let id : Int
    let name : String
    let image : String
    
    init(id: Int, name: String, image: String) {
        self.id = id
        self.name = name
        self.image = image
    }
}
