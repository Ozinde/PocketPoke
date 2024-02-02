//
//  PokeInfo.swift
//  PocketPoke
//
//  Created by Oneh Zinde on 2024/02/02.
//

import Foundation

struct PokeInfo: Codable {
    let stats: [PokeStats]
    let abilities: [PokeAbilities]
}

struct PokeStats: Codable {
    let health: Int
    
    enum CodingKeys: String, CodingKey {
        case health = "base_stat"
    }
    
}

struct PokeAbilities: Codable {
    let ability: PokeAbility
    
}

struct PokeAbility: Codable {
    let name: String
    
}
