//
//  Media.swift
//  DA5-APP
//
//  Created by Jojo on 12/2/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = ""
        
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = data
    }
    
}

// MARK: - Welcome
struct ImageUploadData: Codable {
    var image: String?
    var imagePath: String?
    var thumbnail: String?
    var thumbnailPath: String?

    enum CodingKeys: String, CodingKey {
        case image
        case imagePath = "image_path"
        case thumbnail
        case thumbnailPath = "thumbnail_path"
    }
}
