//
//  Post.swift
//  Networking(URLSession)
//
//  Created by 123 on 6.07.23.
//

import Foundation

struct Post: Codable {
    let id: Int
    let node_id: String
    let name: String
    let full_name: String
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case node_id
        case name
        case full_name
    }
}
