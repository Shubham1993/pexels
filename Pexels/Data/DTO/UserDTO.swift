//
//  UserDTO.swift
//  Pexels
//
//  Created by shubham gupta on 22/03/26.
//

import Foundation

struct UserDTO: Decodable {
    let id: Int
    let name: String
    let url: String
}
