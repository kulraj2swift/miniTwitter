//
//  UploadImage.swift
//  miniTwitter
//
//  Created by kulraj singh on 22/01/23.
//

import Foundation

struct Image {
    struct Keys {
        static let imageType = "image_type"
        static let width = "w"
        static let height = "h"
    }
    
    var imageType: String?
    var width: Double?
    var height: Double?
    
    init?(json: JSON?) {
        guard let dict = json else {
            return nil
        }
        imageType = dict[Keys.imageType].string
        width = dict[Keys.width].double
        height = dict[Keys.height].double
    }
}

struct UploadImageResponse {
    
    struct Keys {
        static let size = "size"
        static let image = "image"
        static let mediaIdString = "media_id_string"
        static let expiresAfter = "expires_after_secs"
        static let mediaId = "media_id"
    }
    
    var size: Int?
    var image: Image?
    var mediaIdString: String?
    var expiresAfterSeconds: Int?
    var mediaId: Double?
    
    init(json: [String: JSON]?) {
        guard let dict = json else {
            return
        }
        size = dict[Keys.size]?.integer
        image = Image(json: dict[Keys.image])
        mediaIdString = dict[Keys.mediaIdString]?.string
        expiresAfterSeconds = dict[Keys.expiresAfter]?.integer
        mediaId = dict[Keys.mediaId]?.double
    }
}
