//
//  PokeList.swift
//  PocketPoke
//
//  Created by Oneh Zinde on 2024/02/02.
//

import Foundation

struct PokeList: Codable {
    
    let next: String
    let results: [PokeItems]
}

struct PokeItems: Codable {
    
    let name: String
}
