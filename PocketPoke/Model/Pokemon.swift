//
//  Pokemon.swift
//  PocketPoke
//
//  Created by Oneh Zinde on 2024/02/02.
//

import Foundation

struct Pokemon: Codable {
    
    let image: PokeImage
    let name : Species
    
    enum CodingKeys: String, CodingKey {
        case image = "sprites"
        case name = "species"
    }
    
}

struct PokeImage: Codable {
    
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case image = "front_shiny"
    }
}

struct Species: Codable {
    
    let name: String
}




