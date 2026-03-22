//
//  VideoFileDTO.swift
//  Pexels
//
//  Created by shubham gupta on 22/03/26.
//

import Foundation

struct VideoFileDTO: Decodable {
    let id: Int
    let quality: String?
    let fileType: String?
    let width: Int?
    let height: Int?
    let fps: Double?
    let link: String
    let size: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case quality
        case fileType = "file_type"
        case width
        case height
        case fps
        case link
        case size
    }
}
