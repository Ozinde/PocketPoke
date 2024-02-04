//
//  Pokemon.swift
//  PocketPoke
//
//  Created by Oneh Zinde on 2024/02/02.
//

import Foundation

struct Pokemon: Codable {
    
    let name : String
    let image: PokeImage
    
    enum CodingKeys: String, CodingKey {
        case name
        case image = "sprites"
    }
    
}

struct PokeImage: Codable {
    
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "front_shiny"
    }
}




